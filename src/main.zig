const std = @import("std");
const shared = @import("shared");

const fmt = shared.fmt;
const Flag = shared.Flag;
const Http = shared.Http;

const CLI = @import("cli/run.zig");
const TUI = @import("tui/run.zig");
const FILE = @import("files/run.zig");

//  ========================================================================================
//
//            /$$
//           |__/
//  /$$$$$$$$ /$$  /$$$$$$  /$$$$$$$$  /$$$$$$   /$$$$$$
// |____ /$$/| $$ /$$__  $$|____ /$$/ |____  $$ /$$__  $$
//    /$$$$/ | $$| $$  \ $$   /$$$$/   /$$$$$$$| $$  \ $$
//   /$$__/  | $$| $$  | $$  /$$__/   /$$__  $$| $$  | $$
//  /$$$$$$$$| $$|  $$$$$$$ /$$$$$$$$|  $$$$$$$|  $$$$$$$
// |________/|__/ \____  $$|________/ \_______/ \____  $$
//                /$$  \ $$                     /$$  \ $$
//               |  $$$$$$/                    |  $$$$$$/
//                \______/                      \______/
//
//
//        ⚡Version 0.8 ⚡
//
//  ========================================================================================

pub fn main() void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var arena: std.heap.ArenaAllocator = .init(gpa.allocator());
    defer arena.deinit();

    const allocator = arena.allocator();

    var flags = Flag.init();

    var iter: std.process.ArgIterator = std.process.args();
    _ = iter.skip();

    while (iter.next()) |current_value| {
        // Collect flags (to be provided before the command)
        if (current_value[0] == '-') {
            flags.parse(current_value);
        } else {
            // Run FILE or CLI (based on first non-flag token)
            if (std.mem.eql(u8, current_value, "run")) {
                const second_arg = iter.next();
                FILE.run(allocator, second_arg);
                return;
            } else {
                const second_arg = iter.next();
                const third_arg = iter.next();
                CLI.run(allocator, current_value, second_arg, third_arg, flags);
                return;
            }
        }
    }

    // If no args provided, run TUI (no flags needed for this mode)
    TUI.run() catch |err| {
        fmt.err("Failed TUI: {}\n", .{err});
        return;
    };
    return;
}

// TODO:
// 1. set a proper convention for library namespace, file namespace and local function, file namespace and local function.
// 2. headers printing for verbose.
// 3. remove internal error for api tester error
// 4. add option to include header in req via cli.
