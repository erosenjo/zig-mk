//! Declaring Keymap
const KC = @import("keycodes.zig").KC;

// rows + columns
pub const row2col = .{
    .{ .{ 0, 0 }, .{ 1, 0 }, .{ 2, 0 }, .{ 3, 0 }, .{ 4, 0 } },
    .{ .{ 0, 0 }, .{ 1, 0 }, .{ 2, 0 }, .{ 3, 0 }, .{ 4, 0 } },
    .{ .{ 0, 0 }, .{ 1, 0 }, .{ 2, 0 }, .{ 3, 0 }, .{ 4, 0 } },
    .{ .{ 3, 0 }, .{ 4, 0 } },
};
//what do array values represent?

//scanning pins

//state array

//codes --> output

pub const keymap = .{
    .{ KC.lshift, KC.z, KC.x, KC.c },
};
