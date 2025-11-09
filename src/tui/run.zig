const fmt = @import("shared").fmt;

pub fn run() void {
    fmt.log(
        "tui.\n",
        .{},
    );
    fmt.logFlush();
    return;
}
