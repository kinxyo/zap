const std = @import("std");
const fmt = @import("shared").fmt;
const eql = std.mem.eql;

// Orginal Terminal (Mode)
var org_term: std.posix.termios = undefined;

fn enableRawMode(hn: std.fs.File.Handle) !void {
    org_term = try std.posix.tcgetattr(hn);

    var raw = org_term;
    raw.lflag.ECHO = false;
    raw.lflag.ICANON = false;

    try std.posix.tcsetattr(hn, .FLUSH, raw);
}

fn disableRawMode(hn: std.fs.File.Handle) void {
    std.posix.tcsetattr(hn, .FLUSH, org_term) catch |err| {
        fmt.err("Failed to dial back terminal: {}\n", .{err});
        return;
    };
}

pub fn run() !void {
    var buf: [4096]u8 = undefined;
    var reader: std.fs.File.Reader = std.fs.File.stdin().reader(&buf);
    const handler = reader.file.handle;
    var stdin: *std.Io.Reader = &reader.interface;

    try enableRawMode(handler);
    defer disableRawMode(handler);

    var key: u8 = ' ';

    while (true) {
        // Clear
        fmt.clear();

        // Draw
        fmt.output("Key pressed: {c}\n", .{key});
        fmt.flush();

        // Poll for events (input).
        key = try stdin.takeByte();
        if (key == 'q') break;
    }

    fmt.clear();
    fmt.flush();
}
