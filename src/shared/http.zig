const std = @import("std");

pub const Types = @import("http_types.zig");

const fmt = @import("fmt.zig");
const Cli = std.http.Client;

pub const Collection = struct {
    name: []const u8,
    baseUrl: []const u8,
    tests: []Test,
};

pub const Test = struct {
    method: []const u8,
    path: []const u8,
    headers: ?std.json.Value = null,
    body: ?std.json.Value = null,
};

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

pub fn parseUrl(alloc: std.mem.Allocator, path: []const u8, baseUrl: ?[]const u8) ![]const u8 {
    // Example:
    // 1. zap /api/users (local)
    // 2. zap httpbin.org/json (global)
    // 3. zap -d httpbin.org/json (global without https)

    // FOR FILE
    if (baseUrl) |v| {
        return try std.mem.concat(alloc, u8, &[2][]const u8{ v, path });
    }

    // FOR CLI
    if (std.mem.startsWith(u8, path, "https://")) {
        return path;
    }

    // GLOBAL (by default)
    var tmp: []const u8 = "https://";

    if (path[0] == '/') {
        // LOCAL
        tmp = "http://localhost:8000";
    }

    return try std.mem.concat(alloc, u8, &[2][]const u8{ tmp, path });
}

pub fn curl(alloc: std.mem.Allocator, method: std.http.Method, url: []const u8, payload: ?[]const u8, headers: std.ArrayList(std.http.Header)) Cli.FetchResult {
    var c: Cli = .{ .allocator = alloc };

    const options: Cli.FetchOptions = .{
        .method = method,
        .location = .{ .url = url },
        .extra_headers = headers.items,
        .payload = payload,
        .response_writer = fmt.writer(),
    };

    const result = c.fetch(options) catch |err| {
        fmt.fatal("Failed curl: {any}", .{err});
        unreachable;
    };

    fmt.flush();

    return result;
}
