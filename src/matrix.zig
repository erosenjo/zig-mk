//! File with matrix scanning routine

const KC = @import("keycodes.zig").KC;

const Matrix = struct { .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 } } };

pub const USBBuffer = struct {
    mods: u8, // Modifier bitmap (is there a way to make this an enum?)
    keys: [14]u8, // Array of keycodes

    pub fn init() USBBuffer {
        return USBBuffer{
            .mods = 0,
            .keys = [_]u8{0} ** 14,
        };
    }

    pub fn press(self: USBBuffer, key: KC) !void {
        var ctr: u8 = 0;
        while (self.keys[ctr] != 0) { // Goes through array looking for empty
            ctr += 1;
            if (self.keys[ctr] == key) return error.KeyAlreadyPressed;
            if (ctr >= 14) return error.TooManyKeys;
        }
        self.keys[ctr] = key; // if empty is found, set it to key
        // for implementation
        //        for (self.keys) |spot| {
        //            switch (spot) {
        //                0 => spot = key,
        //                key => return error.KeyAlreadyPressed,
        //            }
        //        }
        //        return error.TooManyKeys;
    }

    pub fn depress(self: USBBuffer, key: KC) !void {
        var ctr: u8 = 0;
        while (self.keys[ctr] != key) { // Goes through array looking for key
            ctr += 1;
            if (ctr >= 14) return error.KeyNotPressed;
        }
        self.keys[ctr] = 0; // if key is found, set it to empty
    }
};

pub fn scan() Matrix {} // Get changes from matrix

pub fn process() !void {} // translate changes from scan() to keycodes and
// then send them to USB
