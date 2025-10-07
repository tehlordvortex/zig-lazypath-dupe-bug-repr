const std = @import("std");
const c = @cImport({
    @cInclude("header.h");
});

pub fn doSomething() void {
    std.debug.print("{}", .{c.cool_function()});
}

test doSomething {
    doSomething();
}
