//! File with matrix scanning routine

const std = @import("std");
const KC = @import("keycodes.zig").KC;

pub const USBBuffer = struct {
    mods: u8, // Modifier bitmap (is there a way to make this an enum?)
    keys: [14]u8, // Array of keycodes

    pub fn init() !USBBuffer {
        return USBBuffer{
            .mods = 0,
            .keys = [_]u8{0} ** 14, // initializes array to 0
        };
    }

    pub fn press(self: *USBBuffer, keycode: u8) !void {
        // while implementation
        //        var ctr: u8 = 0;
        //        while (self.keys[ctr] != 0) { // Goes through array looking for empty
        //            ctr += 1;
        //            if (self.keys[ctr] == keycode) return error.KeyAlreadyPressed;
        //            if (ctr >= 14) return error.TooManyKeys;
        //        }
        //        self.keys[ctr] = keycode; // if empty is found, set it to key
        var is_modifier = keycode >= '\xE0' and keycode <= '\xE7';
        if (is_modifier) {
            var mod_shift: u3 = @truncate(keycode);
            var mod_bit: u8 = 1;
            mod_bit <<= mod_shift;
            self.mods |= mod_bit;
            return;
        }
        // for implementation
        for (&self.keys) |*key| {
            if (key.* == 0) { // if empty spot found, set it to KC and return
                key.* = keycode;
                return;
            } else if (key.* == keycode) {
                return error.KeyAlreadyPressed;
            }
        }
        return error.TooManyKeys;
    }

    pub fn depress(self: *USBBuffer, keycode: u8) !void {
        // while implementation
        // var ctr: u8 = 0;
        // while (self.keys[ctr] != key) { // Goes through array looking for key
        //     ctr += 1;
        //     if (ctr >= 14) return error.KeyNotPressed;
        // }
        // self.keys[ctr] = 0; // if key is found, set it to empty
        var is_modifier = keycode >= 0xE0 and keycode <= 0xE7;
        if (is_modifier) {
            var mod_shift: u3 = @truncate(keycode);
            var mod_bit: u8 = 1;
            mod_bit <<= mod_shift;
            self.mods &= ~mod_bit;
            return;
        }
        // for implementation
        for (&self.keys, 1..) |*key, i| {
            std.debug.print("keycode at {d} is: {d}\n", .{ i, key.* });
            if (key.* == keycode) {
                var oldptr = key;
                for (self.keys[i..]) |*newptr| { //shift to fill gap
                    if (oldptr.* == 0) return;
                    oldptr.* = newptr.*;
                    oldptr = newptr;
                }
                self.keys[13] = 0;
                return;
            } else if (key.* == 0) break;
        }
        return error.KeyNotPressed;
    }
};

// Tests

const testing = std.testing;

test "Press 1 button" {
    var buffer = try USBBuffer.init();
    try buffer.press(@intFromEnum(KC.a));
    try testing.expect(buffer.keys[0] == @intFromEnum(KC.a));
}

test "Press and release" {
    var buffer = try USBBuffer.init();
    try buffer.press(@intFromEnum(KC.a));
    try buffer.depress(@intFromEnum(KC.a));
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

test "modifier press" {
    var buffer = try USBBuffer.init();

    try buffer.press(@intFromEnum(KC.lshift));

    try testing.expect(buffer.mods == 2);
}

test "modifier press and release" {
    var buffer = try USBBuffer.init();

    try buffer.press(@intFromEnum(KC.lshift));

    try testing.expect(buffer.mods == 2);

    try buffer.depress(@intFromEnum(KC.lshift));

    try testing.expect(buffer.mods == 0);
}

//not expecting this to happen, but making sure that it doesn't break anything
test "double press modifier" {
    var buffer = try USBBuffer.init();

    try buffer.press(@intFromEnum(KC.lshift));
    try buffer.press(@intFromEnum(KC.lshift));

    try testing.expect(buffer.mods == 2);
}

test "release key not pressed" {
    var buffer = try USBBuffer.init();

    try buffer.depress(@intFromEnum(KC.lshift));

    try testing.expect(buffer.mods == 0);
}
