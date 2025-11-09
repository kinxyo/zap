const std = @import("std");

const l = @import("lexer.zig");
const Http = @import("shared").Http;

pub fn parse(alloc: std.mem.Allocator, lexer: *const l.Lexer) !void {
    var c: Http.Types.Collection = .init(alloc);

    for (lexer.tokens.items) |t| {
        if (t.Type == .PROPERTIES) {
            try parse_collection(&c, t);
        }
    }

    c.print();
}

pub fn parse_collection(c: *Http.Types.Collection, t: l.Token) !void {
    var iter = std.mem.splitSequence(u8, t.Value, " ");
    const prop = iter.first();
    const value = iter.next();
    c.add(prop, value.?);
}
