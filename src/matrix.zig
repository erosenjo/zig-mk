//! File with matrix scanning routine

const std = @import("std");
const KC = @import("keycodes.zig").KC;

const Matrix = struct { .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 } } };

pub const USBBuffer = struct {
    mods: u8, // Modifier bitmap (is there a way to make this an enum?)
    keys: *[14]u8, // Array of keycodes

    pub fn init() !USBBuffer {
        return USBBuffer{
            .mods = 0,
            .keys = init: {
                var arr: [14]u8 = undefined;
                for (&arr) |*p| p.* = 0;
                break :init arr[0..];
            },
        };
    }

    pub fn press(self: USBBuffer, keycode: u8) !void {
        // while implementation
        //        var ctr: u8 = 0;
        //        while (self.keys[ctr] != 0) { // Goes through array looking for empty
        //            ctr += 1;
        //            if (self.keys[ctr] == keycode) return error.KeyAlreadyPressed;
        //            if (ctr >= 14) return error.TooManyKeys;
        //        }
        //        self.keys[ctr] = keycode; // if empty is found, set it to key
        // for implementation
        for (self.keys) |*key| {
            if (key.* == 0) { // if empty spot found, set it to KC and return
                key.* = keycode;
                return;
            } else if (key.* == keycode) {
                return error.KeyAlreadyPressed;
            }
        }
        return error.TooManyKeys;
    }

    pub fn depress(self: USBBuffer, keycode: u8) !void {
        _ = keycode;
        // while implementation
        // var ctr: u8 = 0;
        // while (self.keys[ctr] != key) { // Goes through array looking for key
        //     ctr += 1;
        //     if (ctr >= 14) return error.KeyNotPressed;
        // }
        // self.keys[ctr] = 0; // if key is found, set it to empty
        for (self.keys, 0..) |*key, i| {
            std.debug.print("keycode at {d} is: {d}\n", .{ i, key.* });
        }
        // for implementation
        for (self.keys, 0..) |*key, i| {
            std.debug.print("keycode at {d} is: {d}\n", .{ i, key.* });
            // if (key.* == keycode) {
            //     var oldptr = key;
            //     for (self.keys[(i + 1)..]) |*newptr| { //shift to fill gap
            //         if (oldptr.* == 0) return;
            //         oldptr.* = newptr.*;
            //         oldptr = newptr;
            //     }
            //     self.keys[13] = 0;
            //     return;
            // }
            // else if (key.* == 0) break;
        }
        return error.KeyNotPressed;
    }
};

pub fn scan() Matrix {} // Get changes from matrix

pub fn process() !void {} // translate changes from scan() to keycodes and
// then send them to USB

// Tests

const testing = std.testing;

test "Press 1 button" {
    var buffer = try USBBuffer.init();
    try buffer.press(@intFromEnum(KC.a));
    try testing.expect(buffer.keys[0] == @intFromEnum(KC.a));
}

test "Press and release" {
    var buffer = try USBBuffer.init();

    std.debug.print("Initial values: \n", .{});
    for (buffer.keys, 0..) |*ptr, i| {
        std.debug.print("Value at {d} is {d}.\n", .{ i, ptr.* });
    }

    try buffer.press(@intFromEnum(KC.a));

    std.debug.print("After press: \n", .{});
    for (buffer.keys, 0..) |*ptr, i| {
        std.debug.print("Value at {d} is {d}.\n", .{ i, ptr.* });
    }

    try buffer.depress(@intFromEnum(KC.a));

    std.debug.print("After depress: \n", .{});
    for (buffer.keys, 0..) |*ptr, i| {
        std.debug.print("Value at {d} is {d}.\n", .{ i, ptr.* });
    }

    try testing.expect(buffer.keys[0] == 0);
}

test "Keys shift down" {
    var buffer = try USBBuffer.init();

    try buffer.press(@intFromEnum(KC.a));
    try buffer.press(@intFromEnum(KC.b));

    try testing.expect(buffer.keys[0] == @intFromEnum(KC.a));
    try testing.expect(buffer.keys[1] == @intFromEnum(KC.b));

    try buffer.depress(@intFromEnum(KC.a));

    try testing.expect(buffer.keys[0] == @intFromEnum(KC.b));
}
