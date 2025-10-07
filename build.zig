const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const mod = b.addModule("lazypath_dupe_bug_repr", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const include_path = std.fmt.allocPrint(b.allocator, "include", .{}) catch @panic("OOM");
    defer b.allocator.free(include_path);

    const dep = b.dependency("fake_dep", .{});
    // NOTE: This will fail because the path isn't duplicated correctly,
    // so the final include path just has random data appended at the end
    mod.addIncludePath(dep.path(include_path));

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
