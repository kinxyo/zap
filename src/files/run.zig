const std = @import("std");

const fmt = @import("shared").fmt;
const Flag = @import("shared").Flag;

const lexer = @import("lexer.zig");
const parser = @import("parser.zig");

const FILE = "config.zap";

pub fn run(allocator: std.mem.Allocator, flags: *const Flag.Type) void {
    _ = flags;

    const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10 MB
    const content = std.fs.cwd().readFileAlloc(allocator, FILE, MAX_FILE_SIZE) catch |err| switch (err) {
        error.FileTooBig => {
            fmt.fatal("File size exceeding the 10 MB limit.\n", .{});
            return;
        },
        else => {
            fmt.fatal("Failed to read file `{s}`: {}\n", .{ FILE, err });
            return;
        },
    };

    var l = lexer.Lexer.new(allocator);

    l.run(content) catch |err| {
        fmt.fatal("Failed to run lexer: {}\n", .{err});
        return;
    };

    parser.parse(allocator, &l) catch |err| {
        fmt.fatal("Failed to parse: {}\n", .{err});
        return;
    };
}
