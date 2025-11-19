const std = @import("std");
const eql = std.mem.eql;

const fmt = @import("shared").fmt;

pub const Flag = struct {
    verbose: bool = false,

    pub fn init() Flag {
        return .{};
    }

    pub fn parse(self: *Flag, v: []const u8) void {
        self.isVerbose(v);
    }

    pub fn print(self: *const Flag) void {
        std.debug.print("verbose: {any}\n", .{self.verbose});
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
