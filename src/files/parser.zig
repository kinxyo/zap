const std = @import("std");

const Http = @import("shared").Http;

// RULES:
// 1. Each line is a self-contained token
// 2. If multi-line is needed then

// ======== Tokens =========================|

pub fn run(content: []const u8, collection: *Http.Types.Collection) !void {
    // Now we skim through the content for tokens
    var pos: usize = 0;
    while (pos <= content.len - 1) {
        const char = content[pos];

        // std.debug.print("{d}-", .{pos});

        switch (char) {
            '@' => {
                // extract line
                pos = try extract(pos, content, collection, '\n');
            },
            // '#' => {
            //     // extract block
            //     pos = try extract(pos, content, collection, '}');
            // },
            else => pos += 1,
        }
    }
}

// We extract the line/block (depending on the delimiter) and then we send it to be parsed.
pub fn extract(pos: usize, content: []const u8, collection: *Http.Types.Collection, delimiter: u8) !usize {
    var d: u8 = delimiter;

    const start = pos;
    var current = pos;

    while (content[current] != d) {
        if (content[current] == '{') {
            d = '}';
        }

        current += 1;
    }

    const line = content[start..current];
    // std.debug.print("line: {s}\n", .{line});
    try parse(collection, line);
    return current + 1;
}

// Here the parser strips the line/block down into -- properties and value and send it to collection method to appropriate set the values for http layer.
fn parse(collection: *Http.Types.Collection, line: []const u8) !void {
    var iter: usize = 0;
    while (line[iter] != ' ') {
        iter += 1;
    }

    const prop = line[0..iter];
    const value = line[iter + 1 .. line.len];

    // std.debug.print("prop: {s}, value: {s}\n", .{ prop, value });

    try collection.add(prop, value);
}
