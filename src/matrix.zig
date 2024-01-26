const std = @import("std");
const testing = std.testing;
const USBBuffer = @import("usb-buffer.zig").USBBuffer;
const KC = @import("keycodes.zig").KC;

// test keyboard is [Shift] [Z] [X] [C]
//                          [Space]
const Matrix = struct {
    .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 }, .{ 0, 3 } },
    .{.{ 1, 1 }},
};
const keymap = @import("example-keymap.zig").keymap;

fn map2code(comptime map: anytype) !*[map.len][map[0].len]?u8 {
    var array: [map.len][map[0].len]?u8 = undefined;
    inline for (map, 0..) |row, i| {
        inline for (row, 0..) |pos, j| {
            array[i][j] = result: {
                switch (@TypeOf(pos)) {
                    KC => break :result @intFromEnum(pos),
                    @TypeOf(null) => break :result null,
                    else => return error.KeymapError,
                }
            };
        }
    }
    return &array;
}

pub const keymapu8 = map2code(keymap);

test "test example keymap conversion" {
    const result = try map2code(keymap);
    const expected_row0 = [_]?u8{ '\xE1', '\x1D', '\x1B', '\x06' };
    const expected_row1 = [_]?u8{ null, '\x2C', null, null };

    try testing.expect(std.mem.eql(?u8, &result[0], &expected_row0));
    try testing.expect(std.mem.eql(?u8, &result[1], &expected_row1));
}

pub const KeyChange = enum(i2) {
    depress = -1,
    no_change,
    press,
};

// Some compile-time stuff to make the code more flexible
const num_rows = 1;
const num_columns = 4;
const array_data_type = i2;
const ArrayType = [num_rows][num_columns]array_data_type;

fn makeChangeArray() ArrayType {
    return [num_rows][num_columns]array_data_type{[_]array_data_type{0} ** num_columns} ** num_rows;
}

// Compares two arrays and produces an array where the output maps to KeyChange
fn compare(old: ArrayType, new: ArrayType) ArrayType {
    var changes: ArrayType = makeChangeArray();
    for (&old, &new, &changes) |*oldrowp, *newrowp, *changerowp| {
        for (oldrowp, newrowp, changerowp) |*oldptr, *newptr, *changeptr| {
            changeptr.* = newptr.* - oldptr.*;
        }
    }
    return changes;
}

pub fn scan(oldarray: Matrix) Matrix { // Get changes from matrix
    _ = oldarray;
}

// Tests!

test "Compare arrays" {
    // Input: 2 arrays, an old and a new
    // Output: Array representing changes
    var array_a = makeChangeArray();
    var array_b = makeChangeArray();

    array_b[0][2] = 1;

    var result_press = compare(array_a, array_b)[0];
    const expected_result_press = [_]array_data_type{ 0, 0, 1, 0 };
    var result_depress = compare(array_b, array_a)[0];
    const expected_result_depress = [_]array_data_type{ 0, 0, -1, 0 };

    try testing.expect(std.mem.eql(array_data_type, result_press[0..], expected_result_press[0..]));
    try testing.expect(std.mem.eql(array_data_type, result_depress[0..], expected_result_depress[0..]));
}
test "Array of changes to USB" {
    return error.SkipZigTest;
    // Input: Array representing changes
    // Output: appropriately modified USBBuffer
    // var buffer = USBBuffer.init();
    // const testbuf = [_]u8{ @intFromEnum(KC.z), @intFromEnum(KC.x) } ++
    //     [_]u8{0} ** 12;
    // try testing.expect(std.mem.eql([14]u8, buffer.keys, testbuf));
}
