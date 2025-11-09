const std = @import("std");
const eql = std.mem.eql;

const fmt = @import("shared").fmt;

pub const Type = std.StringHashMap(bool);

pub fn init(allocator: std.mem.Allocator) Type {
    var f: Type = .init(allocator);

    f.put("v", false) catch unreachable; // verbose

    return f;
}

pub fn print(f: *const Type) void {
    var i = f.*.iterator();
    while (i.next()) |v| {
        std.debug.print("{s}:{any}\n", .{ v.key_ptr.*, v.value_ptr.* });
    }
}

pub fn parse(f: *Type, arg: []const u8) void {
    isVerbose(f, arg);
}

fn isVerbose(f: *Type, arg: []const u8) void {
    if (eql(u8, arg, "-verbose") or eql(u8, arg, "--verbose") or eql(u8, arg, "--v") or eql(u8, arg, "-v")) {
        const v = f.*.getPtr("v") orelse unreachable;
        v.* = true;
    }
}
