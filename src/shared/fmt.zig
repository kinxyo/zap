const std = @import("std");

// About: `fmt` for printing, logging and processing error.
// Sections:
// > terminal.
// > color.

// ======== Terminal Section =========================|

var stdout_buffer: [4 * 1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout: *std.Io.Writer = &stdout_writer.interface;

var stderr_buffer: [4096]u8 = undefined;
var stderr_writer = std.fs.File.stderr().writer(&stderr_buffer);
const stderr: *std.Io.Writer = &stderr_writer.interface;

// _____ helpers _____

pub fn writer() *std.Io.Writer {
    return stdout;
}

pub fn err_writer() *std.Io.Writer {
    return stderr;
}

pub fn flush() void {
    stdout.flush() catch unreachable;
}

pub fn logFlush() void {
    stderr.flush() catch unreachable;
}

// _____ Output _____

pub fn output(comptime fmt: []const u8, args: anytype) void {
    stdout.print(fmt, args) catch unreachable;
}

pub fn outputColored(comptime fmt: []const u8, args: anytype, color: Color) void {
    stdout.writeAll(color.code()) catch unreachable;
    stdout.print(fmt, args) catch unreachable;
    stdout.writeAll(Color.reset.code()) catch unreachable;
}

pub fn outputJson(value: std.json.Value) void {
    std.json.Stringify.value(value, .{ .whitespace = .indent_2 }, stdout) catch {
        stderr.print("unable to output JSON", .{}) catch unreachable;
        return;
    };
    stdout.print("\n", .{}) catch unreachable;
}

// _____ Logs _____

pub fn log(comptime fmt: []const u8, args: anytype) void {
    stderr.print(fmt, args) catch unreachable;
}

pub fn logColored(comptime fmt: []const u8, args: anytype, color: Color) void {
    stderr.writeAll(color.code()) catch unreachable;
    stderr.print(fmt, args) catch unreachable;
    stderr.writeAll(Color.reset.code()) catch unreachable;
}

pub fn logJson(value: anytype) void {
    std.json.Stringify.value(value, .{ .whitespace = .indent_2 }, stderr) catch {
        stderr.print("unable to log JSON", .{}) catch unreachable;
        return;
    };
    stderr.print("\n", .{}) catch unreachable;
}

// _____ Err _____

pub fn err(comptime fmt: []const u8, args: anytype) void {
    logColored(fmt, args, .red);
    stderr.flush() catch unreachable;
}

pub fn fatal(comptime fmt: []const u8, args: anytype) void {
    logColored(fmt, args, .red);
    stderr.flush() catch unreachable;
    std.process.exit(1);
}

// ======== Color Section =========================|

pub const Color = enum {
    reset,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    bold,
    dim,

    fn code(self: Color) []const u8 {
        return switch (self) {
            .reset => "\x1b[0m",
            .red => "\x1b[31m",
            .green => "\x1b[32m",
            .yellow => "\x1b[33m",
            .blue => "\x1b[34m",
            .magenta => "\x1b[35m",
            .cyan => "\x1b[36m",
            .bold => "\x1b[1m",
            .dim => "\x1b[2m",
        };
    }
};

// =================================|
