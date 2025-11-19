const std = @import("std");
const shared = @import("shared");

const fmt = shared.fmt;
const Flag = shared.Flag;
const Http = shared.Http;

pub fn run(
    alloc: std.mem.Allocator,
    first_value: []const u8,
    second_arg: ?[]const u8,
    third_arg: ?[]const u8,
    flags: Flag,
) void {
    var r_method: []const u8 = undefined;
    var r_path: []const u8 = undefined;

    if (second_arg) |value| {
        // zz <url>
        r_method = first_value;
        r_path = value;
    } else {
        // zz <method> <url>
        r_method = "get";
        r_path = first_value;
    }

    const method = Http.parseMethod(alloc, r_method) catch |err| switch (err) {
        error.InvalidMethod => {
            fmt.fatal("Wrong Method: use \"get\",\"post\",\"put\",\"delete\"\n", .{});
            return;
        },
        else => {
            fmt.fatal("Failed to parse method: {any}\n", .{err});
            return;
        },
    };

    const url = Http.parseUrl(alloc, r_path, null) catch |err| {
        fmt.fatal("Failed to prepare path: {any}\n", .{err});
        return;
    };

    const result = Http.curl(alloc, method, url, third_arg, .empty);

    if (flags.verbose) {
        fmt.logColored("\n{s} {s}\n", .{ @tagName(method), url }, .bold);
        if (result.status == .accepted or result.status == .created or result.status == .ok) {
            fmt.logColored("{s}\n", .{@tagName(result.status)}, .green);
        } else {
            fmt.logColored("{s}\n", .{@tagName(result.status)}, .red);
        }

        fmt.logFlush();
    }
}
