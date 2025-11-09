const std = @import("std");

pub const Collection = struct {
    alloc: std.mem.Allocator,
    url: []const u8 = undefined,
    authHeader: []const u8 = undefined,
    globalHeaders: ?std.json.Value = null,

    pub fn init(alloc: std.mem.Allocator) Collection {
        return .{ .alloc = alloc };
    }

    pub fn add(c: *Collection, prop: []const u8, value: []const u8) void {
        const e = std.mem.eql;

        if (e(u8, "@baseURL", prop)) {
            c.url = value;
            return;
        }

        if (e(u8, "@auth", prop)) {
            c.authHeader = value;
            return;
        }
    }

    pub fn print(c: *const Collection) void {
        std.debug.print("\n=== Parsed Result ===\n", .{});

        std.debug.print("URL: {s}\n", .{c.url});
    }
};
