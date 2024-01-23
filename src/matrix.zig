const std = @import("std");
const testing = std.testing;
const USBBuffer = @import("usb-buffer.zig").USBBuffer;
const KC = @import("keycodes.zig").KC;

// test keyboard is [Shift] [Z] [X] [C]
const Matrix = struct { .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 } } };

pub const KeyChange = enum(i2) {
    depress = -1,
    no_change,
    press,
};

// Some compile-time stuff to make the code more flexible
const num_rows = 1;
const num_columns = 4;
const array_size = num_rows * num_columns;
const ArrayType = [array_size]i2;

fn makeChangeArray() ArrayType {
    return [_]i2{0} ** array_size;
}

// Compares two arrays and produces an array where the output maps to KeyChange
fn compare(old: ArrayType, new: ArrayType) !void {
    var changes = makeChangeArray();
    for (&old, &new, &changes) |*oldptr, *newptr, *changeptr| {
        changeptr.* = newptr.* - oldptr.*;
    }
}

pub fn scan(oldarray: Matrix) Matrix { // Get changes from matrix
    _ = oldarray;
}

pub fn process() !void {} // translate changes from scan() to keycodes and
// then send them to USB

// Tests!

test "Compare arrays" {
    // Input: 2 arrays, an old and a new
    // Output: Array representing changes
    var array_a = makeChangeArray(1, 3);
    var array_b = makeChangeArray(1, 3);

    array_b[0][2] = 1;

    var result_press = compare(array_a, array_b);
    const expected_result_press = [_]i2{ 0, 0, 1, 0 };
    var result_depress = compare(array_b, array_a);
    const expected_result_depress = [_]i2{ 0, 0, -1, 0 };

    try testing.expect(std.mem.eql(ArrayType, result_press, expected_result_press));
    try testing.expect(std.mem.eql(ArrayType, result_depress, expected_result_depress));
}
test "Array of changes to USB" {
    // Input: Array representing changes
    // Output: appropriately modified USBBuffer
    var buffer = USBBuffer.init();
    const testbuf = [_]u8{ @intFromEnum(KC.z), @intFromEnum(KC.x) } ++
        [_]u8{0} ** 12;
    try testing.expect(std.mem.eql([14]u8, buffer.keys, testbuf));
}
