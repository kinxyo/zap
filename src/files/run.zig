const std = @import("std");

const fmt = @import("shared").fmt;
const Flag = @import("shared").Flag;
const Http = @import("shared").Http;

const Parser = @import("parser.zig");

const FILE = "config.zap";

pub fn run(allocator: std.mem.Allocator, flags: *const Flag.Type) void {
    _ = flags;

    // We create a collection where we store all config and APIs.
    var collection: Http.Types.Collection = .init(allocator);

    // We copy the content of the file to a buffer in program.
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

    // Parse the content to set appropriate values for http layer
    Parser.run(content, &collection) catch |err| {
        fmt.fatal("Failed to parse: {}\n", .{err});
        return;
    };

    collection.print();
}
