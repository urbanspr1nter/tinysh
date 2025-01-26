const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const exe = b.addExecutable(.{ .name = "tinysh", .target = target });

    exe.addCSourceFiles(.{ .files = &.{
        "src/config.c", 
        "src/file.c", 
        "src/jsonutil.c", 
        "src/main.c", 
        "src/memory.c", 
        "src/message.c", 
        "src/module/cJSON/cJSON.c",
        "src/module/clog/log.c",
        "src/module/libcstring/src/c_string.c",
        "src/module/linenoise/linenoise.c"
    } });
    exe.linkLibC();
    exe.linkSystemLibrary("libcurl");

    b.installArtifact(exe);
    b.installFile("./config.json", "bin/config.json");


    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("tests/message.zig"),
        .target = target
    });
    exe_unit_tests.linkLibC();
    exe_unit_tests.addIncludePath(b.path("src"));
    exe_unit_tests.addIncludePath(b.path("src/module/libcstring/src"));
    exe_unit_tests.addCSourceFiles(.{
        .root = b.path("src"),
        .files = &.{
            "config.c",
            "file.c",
            "jsonutil.c",
            "memory.c",
            "message.c",
            "module/cJSON/cJSON.c",
            "module/clog/log.c",
            "module/libcstring/src/c_string.c",
        }
    });

    const runTests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&runTests.step);    
}
