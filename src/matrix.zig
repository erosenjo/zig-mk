// test keyboard is [Shift] [Z] [X] [C]
const Matrix = struct { .{ .{ 0, 0 }, .{ 0, 1 }, .{ 0, 2 } } };

pub fn scan(oldarray: Matrix) Matrix { // Get changes from matrix
    _ = oldarray;
}

pub fn process() !void {} // translate changes from scan() to keycodes and
// then send them to USB
