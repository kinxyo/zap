const std = @import("std");

pub const Types = @import("http_types.zig");

const fmt = @import("fmt.zig");
const Cli = std.http.Client;

pub fn curl(alloc: std.mem.Allocator, method: std.http.Method, uri: std.Uri, payload: ?[]const u8) Cli.FetchResult {
    var c: Cli = .{ .allocator = alloc };

    const options: Cli.FetchOptions = .{ .method = method, .location = .{ .uri = uri }, .payload = payload, .response_writer = fmt.writer() };

    const result = c.fetch(options) catch |err| {
        std.debug.print("{}", .{err});
        fmt.fatal("Failed curl: {any}", .{err});
        unreachable;
    };

    fmt.flush();

    return result;
}
