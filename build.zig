const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{ .name = "tinysh", .target = target });

    exe.addCSourceFiles(.{ .files = &.{ "src/main.c", "src/module/libcstring/src/c_string.c", "src/module/linenoise/linenoise.c", "src/module/cJSON/cJSON.c" } });
    exe.linkLibC();

    b.installArtifact(exe);
}
