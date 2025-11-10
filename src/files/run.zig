const std = @import("std");

const fmt = @import("shared").fmt;
const Http = @import("shared").Http;

pub fn run(allocator: std.mem.Allocator, second_arg: ?[]const u8) void {
    const FILE = second_arg orelse "config.json";

    const MAX_FILE_SIZE: usize = 1 * 1024 * 1024;
    const content = std.fs.cwd().readFileAlloc(allocator, FILE, MAX_FILE_SIZE) catch |err| switch (err) {
        error.FileTooBig => {
            fmt.fatal("File cannot be bigger than 1 MB.", .{});
            return;
        },
        error.FileNotFound => {
            fmt.fatal("No such file exists: `{s}`.", .{FILE});
            return;
        },
        else => {
            fmt.fatal("Failed to read `{s}`: {}", .{ FILE, err });
            return;
        },
    };

    const parsed: std.json.Parsed(Http.Collection) = std.json.parseFromSlice(Http.Collection, allocator, content, .{}) catch |err| switch (err) {
        error.UnexpectedToken => {
            fmt.fatal("Wrong syntax.", .{});
            return;
        },
        else => {
            fmt.fatal("Failed to parse `{s}`: {}", .{ FILE, err });
            return;
        },
    };

    const c = parsed.value;

    // show(&c);

    curl(allocator, &c) catch |err| {
        fmt.fatal("Failed network request: {}\n", .{err});
    };
}

fn curl(allocator: std.mem.Allocator, c: *const Http.Collection) !void {
    for (c.tests) |t| {
        const method = try Http.parseMethod(allocator, t.method);
        const url = try Http.parseUrl(allocator, t.path, c.baseUrl);

        fmt.logColored("{s} {s}\n", .{ @tagName(method), url }, .dim);
        fmt.logFlush();

        var headers_slices: std.ArrayList(std.http.Header) = .empty;
        var body_string: ?[]const u8 = null;

        if (t.headers) |h| {
            // headers_slices = h;
            var p = h.object.iterator();

            while (p.next()) |v| {
                try headers_slices.append(allocator, .{ .name = v.key_ptr.*, .value = v.value_ptr.*.string });
            }
        }

        if (t.body) |b| {
            body_string = try std.json.Stringify.valueAlloc(allocator, b, .{});
        }

        _ = Http.curl(allocator, method, url, body_string, headers_slices);
        fmt.log("\n\n", .{});
        fmt.logFlush();
    }
}

fn show(c: *const Http.Collection) void {
    std.debug.print("Name: {s}\n", .{c.name});
    std.debug.print("BaseURL: {s}\n", .{c.baseUrl});

    for (c.tests, 0..) |t, idx| {
        std.debug.print("\nTest #{d}:\n", .{idx});
        std.debug.print(">\tMethod: {s}\n", .{t.method});
        std.debug.print(">\tPath: {s}\n", .{t.path});
    }
}
