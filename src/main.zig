const std = @import("std");

const fmt = @import("shared").fmt;
const Flag = @import("shared").Flag;
const Http = @import("shared").Http;

const CLI = @import("cli/run.zig");
const TUI = @import("tui/run.zig");
const FILE = @import("files/run.zig");

//  ========================================================================================
//
//      $$$$$$$$\ $$$$$$\   $$$$$$\
//      \____$$  |\____$$\ $$  __$$\
//        $$$$ _/ $$$$$$$ |$$ /  $$ |
//       $$  _/  $$  __$$ |$$ |  $$ |
//      $$$$$$$$\\$$$$$$$ |$$$$$$$  |
//      \________|\_______|$$  ____/
//                         $$ |
//                         $$ |
//                         \__|
//
//        ⚡Version 0.6 ⚡
//
//  ========================================================================================

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var arena: std.heap.ArenaAllocator = .init(gpa.allocator());
    defer arena.deinit();

    const allocator = arena.allocator();

    var flags = Flag.init(allocator);
    defer flags.deinit();

    var iter: std.process.ArgIterator = std.process.args();
    _ = iter.skip();

    while (iter.next()) |current_value| {
        // Collect flags (to be provided before the command)
        if (current_value[0] == '-') {
            Flag.parse(&flags, current_value);
        } else {
            // Run FILE or CLI (based on first non-flag token)
            command_run(allocator, current_value, &iter, &flags);
            return;
        }
    }

    // If no args provided, run TUI (no flags needed for this mode)
    TUI.run();
    return;
}

fn command_run(alloc: std.mem.Allocator, first_arg: []const u8, iter: *std.process.ArgIterator, flags: *Flag.Type) void {
    if (std.mem.eql(u8, first_arg, "run")) {
        FILE.run(alloc, flags);
        return;
    } else {
        const second_arg = iter.next();
        const third_arg = iter.next();
        CLI.run(alloc, first_arg, second_arg, third_arg, flags);
        return;
    }
}

// TODO:
// 1. enums for flag keys
// 2. set a proper convention for library namespace, file namespace and local function, file namespace and local function.
