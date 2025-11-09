const std = @import("std");

const fmt = @import("shared").fmt;
const Flag = @import("shared").Flag;
const Http = @import("shared").Http;

const lookup = std.StaticStringMap(std.http.Method).initComptime(.{
    .{ "get", .GET },
    .{ "post", .POST },
    .{ "p", .POST },
    .{ "put", .PUT },
    .{ "patch", .PATCH },
    .{ "delete", .DELETE },
});

pub fn parseMethod(alloc: std.mem.Allocator, value: []const u8) !std.http.Method {
    const lower = try std.ascii.allocLowerString(alloc, value);
    const trimmed = std.mem.trim(u8, lower, &std.ascii.whitespace);

    return lookup.get(trimmed) orelse error.InvalidMethod;
}

pub fn makeURL(alloc: std.mem.Allocator, path: []const u8) ![]const u8 {
    // Example:
    // 1. zap /api/users (local)
    // 2. zap httpbin.org/json (global)
    // 3. zap -d httpbin.org/json (global without https)

    if (std.mem.startsWith(u8, path, "https://")) {
        return path;
    }

    if (path[0] == '/') {
        // LOCAL
        return try std.mem.concat(alloc, u8, &[2][]const u8{ "http://localhost:8000", path });
    } else {
        // GLOBAL
        return try std.mem.concat(alloc, u8, &[2][]const u8{ "https://", path });
    }
}
