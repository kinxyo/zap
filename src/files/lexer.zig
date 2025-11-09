const std = @import("std");

// ======== Tokens =========================|

pub const TokenType = enum {
    PROPERTIES, // @
    GLOBAL_HEADERS, // #

    pub fn symbol(self: TokenType) u8 {
        return switch (self) {
            .PROPERTIES => '@',
            .GLOBAL_HEADERS => '#',
        };
    }
};

pub const Token = struct { Type: TokenType, Value: []const u8 };

pub const Lexer = struct {
    alloc: std.mem.Allocator,
    tokens: std.ArrayList(Token) = .empty,
    pos: usize = 0,

    pub fn new(alloc: std.mem.Allocator) Lexer {
        return .{ .alloc = alloc };
    }

    pub fn run(self: *Lexer, content: []const u8) !void {
        const t = TokenType;

        while (self.pos <= content.len - 1) {
            if (content[self.pos] == t.PROPERTIES.symbol()) {
                try self.extractToken(.PROPERTIES, content);
            }

            // std.debug.print("{c}", .{content[self.pos]});
            self.move();
        }

        self.print();
    }

    pub fn add(self: *Lexer, t: Token) !void {
        try self.tokens.append(self.alloc, t);
    }

    pub fn move(self: *Lexer) void {
        self.pos += 1;
    }

    pub fn extractToken(self: *Lexer, token_type: TokenType, content: []const u8) !void {
        const start = self.pos;

        while (content[self.pos] != '\n') {
            self.move();
        }

        const value = content[start .. self.pos + 1];
        try self.add(.{ .Type = token_type, .Value = value });
    }

    pub fn print(self: *Lexer) void {
        std.debug.print("=== Tokens ===\n", .{});
        for (self.tokens.items) |t| {
            std.debug.print("{s}:{s}", .{ @tagName(t.Type), t.Value });
        }
    }
};

fn collect_properties(lexer: *Lexer, content: []const u8) !void {
    const s = lexer.pos;

    while (content[lexer.pos] != '\n') {
        lexer.move();
    }

    if (content[lexer.pos - 1] == '{') {
        while (content[lexer.pos] != '}') {
            lexer.move();
        }
    }

    const value = content[s .. lexer.pos + 1];

    const token: Token = .{ .Type = TokenType.Properties, .Value = value };
    try lexer.add(token);
}
