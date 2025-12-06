const std = @import("std");
const utils = @import("shared");
const tui = @import("tuilip");

pub fn run() !void {
    var buf_r: [4 * 1024]u8 = undefined;
    var reader = std.fs.File.stdin().reader(&buf_r);
    const stdin: *std.Io.Reader = &reader.interface;

    var app_fmt: tui.Fmt = .{
        .writer = utils.fmt.writer(),
        .reader = stdin,
        .handle = reader.file.handle,
    };

    var cv = tui.Canvas.init(&app_fmt) catch |err| {
        std.log.err("Failed to initialize the canvas: {s}\n", .{@errorName(err)});
        return;
    };

    cv.fmt.clear();
    cv.fmt.cursor_hide();
    defer cv.fmt.cursor_show();

    for (0..3) |_| {
        try tui.animations.slidingX(&cv, 1, 5, cv.width, 2, "===", 31);
        try tui.animations.slidingY(&cv, 5, 1, cv.height, 2, "|||", 34);
    }

    cv.fmt.clear();
}
