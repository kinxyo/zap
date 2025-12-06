const std = @import("std");
const eql = std.mem.eql;

const fmt = @import("fmt.zig");

pub const Flag = struct {
    verbose: bool = false,
    header: ?[]const u8 = null,

    pub fn init() Flag {
        return .{};
    }

    pub fn parse(self: *Flag, v: []const u8) void {
        self.isVerbose(v);
    }

    pub fn setHeader(self: *Flag, v: ?[]const u8) void {
        if (v) |h| {
            if (eql(u8, h, "")) {
                fmt.fatal("No header provided.", .{});
                return;
            }
            if (h[0] == '{' and h[h.len - 1] == '}') {
                self.header = h;
                return;
            }
        }
        fmt.fatal("Invalid header provided.", .{});
        return;
    }

    pub fn print(self: *const Flag) void {
        std.debug.print("verbose: {any}\n", .{self.verbose});
        std.debug.print("headers: {s}\n", .{self.header.?});
    }

    fn isVerbose(self: *Flag, v: []const u8) void {
        if (eql(u8, v, "-v") or
            eql(u8, v, "--v") or
            eql(u8, v, "--verbose") or
            eql(u8, v, "-verbose"))
        {
            self.verbose = true;
        }
    }
};
