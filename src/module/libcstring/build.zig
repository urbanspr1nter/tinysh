const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{ .cpu_arch = .aarch64, .os_tag = .macos } });

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const lib = b.addSharedLibrary(.{ .name = "cstring", .target = target, .optimize = optimize, .link_libc = true, .version = .{ .major = 1, .minor = 0, .patch = 0 } });
    lib.addIncludePath(b.path("src"));
    lib.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{"c_string.c"},
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);
    b.installFile("src/c_string.h", "include/c_string.h");

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_unit_tests.linkLibC();
    exe_unit_tests.addIncludePath(b.path("src"));
    exe_unit_tests.addCSourceFiles(.{ .root = b.path("src"), .files = &.{"c_string.c"} });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
