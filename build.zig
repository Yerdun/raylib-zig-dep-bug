const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib_dep =  b.dependency("raylib", .{
        .target = target,
        .optimize = optimize,
        .config = @as([]const []const u8, &.{"-DSUPPORT_FILEFORMAT_FLAC", "-DSUPPORT_CUSTOM_FRAME_CONTROL", }),
    });
    const raylib = raylib_dep.artifact("raylib");

    const exe = b.addExecutable(.{
        .name = "raylib-zig-dep-bug",
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(raylib);
    exe.linkLibrary(raylib);

    exe.linkLibC();

    exe.addCSourceFiles(.{
        .files = &.{"example.c"},
        .flags = &.{"-lraylib"},
    });

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_exe.step);
}
