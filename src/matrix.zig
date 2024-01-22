//! File with matrix scanning routine

const Matrix = struct { .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 } } };

const Keycode = enum {};

const USBBuffer = struct {
    mods: u8, // Modifier bitmap (is there a way to make this an enum?)
    keys: [14]u8, // Array of keycodes

    pub fn press(self: USBBuffer, key: Keycode) !void {
        var ctr: u8 = 0;
        while (self.keys[ctr] != 0) { // Goes through array looking for empty
            ctr += 1;
            if (self.keys[ctr] == key) return error.KeyAlreadyPressed;
            if (ctr >= 14) return error.TooManyKeys;
        }
        self.keys[ctr] = key; // if empty is found, set it to key
    }

    pub fn depress(self: USBBuffer, key: Keycode) !void {
        var ctr: u8 = 0;
        while (self.keys[ctr] != key) {
            ctr += 1;
            if (ctr >= 14) return error.KeyNotPressed;
        }
        self.keys[ctr] = 0;
    }
};

pub fn scan() Matrix {}
