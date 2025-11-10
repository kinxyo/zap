const std = @import("std");

const AnyJson = std.json.Value;

pub const Collection = struct {
    alloc: std.mem.Allocator,
    url: []const u8 = undefined,
    global_headers: ?[]std.http.Header = null,
    auth: ?[]std.http.Header = null,

    pub fn init(alloc: std.mem.Allocator) Collection {
        return .{ .alloc = alloc };
    }

    pub fn add(self: *Collection, prop: []const u8, value: []const u8) !void {
        const e = std.mem.eql;

        if (e(u8, "@baseURL", prop)) {
            self.url = value;
            return;
        }

        if (e(u8, "@glHeaders", prop)) {
            const h = try parseBlock(self.alloc, value);
            self.global_headers = h;
            return;
        }

        if (e(u8, "@auth", prop)) {
            const h = try parseBlock(self.alloc, value);
            self.auth = h;
            return;
        }
    }

    pub fn print(self: *const Collection) void {
        std.debug.print("=== Parsed Result ===\n", .{});

        std.debug.print("URL: `{s}`\n", .{self.url});

        std.debug.print("Headers: \n", .{});
        for (self.global_headers orelse &[_]std.http.Header{}) |v| {
            std.debug.print("{s}:{s}\n", .{ v.name, v.value });
        }

        std.debug.print("Auth: \n", .{});
        for (self.auth orelse &[_]std.http.Header{}) |v| {
            std.debug.print("{s}:{s}\n", .{ v.name, v.value });
        }
    }
};

fn parseBlock(alloc: std.mem.Allocator, content: []const u8) ![]std.http.Header {
    var iter = std.mem.splitScalar(u8, content[2 .. content.len - 1], '\n');

    var headers: std.ArrayList(std.http.Header) = try .initCapacity(alloc, 1024);

    while (iter.next()) |v| {
        const t = std.mem.trimStart(u8, v, &std.ascii.whitespace);
        var tmp_iter = std.mem.splitSequence(u8, t, ": ");

        const prop = tmp_iter.next() orelse return error.InvalidFormat;
        const value = tmp_iter.next() orelse return error.InvalidFormat;

        try headers.append(alloc, .{ .name = prop, .value = value });

        // std.debug.print("prop: `{s}` | value: `{s}`\n", .{ prop, value });
    }

    return headers.toOwnedSlice(alloc);
}
