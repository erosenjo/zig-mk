//!Process takes old array, current array, usbbuffer uses/accesses keycode and keymap --> changes the usb buffer

//import USB-buffer.zig

//const USBBuffer = struct{
//	placeholder : u8,
//};

//const numkeys: u8 = 4;

const keymap = @import("matrix.zig").keymapu8;//@import("example-keymap.zig");
const buffer = @import("usb-buffer.zig");
const funcaccess = @import("matrix.zig");

//example code
fn getcode(r: u8, c: u8) u8 { //may need to return KC type instead
    return (keymap[r][c]);
}

//fn translate(r: u8, c:u8) u8{
//	return(keymap.code(r, c));
//}

pub fn process(comptime T: anytype, oldarray: [][]T, newarray: [][]T, buff: *buffer.USBBuffer) void {
    var chg: [][]T = funcaccess.compare(oldarray, newarray);
    //check rows and columns of array, use press/depress as needed

    for (chg, 0..) |row, rowps| {
        for (row, 0..) |col, colps| {
            if (col == 1) {
                buff.*.press(getcode(rowps, colps)); //deref pointer to modify value
            } else if (col == -1) {
                buff.*.depress(getcode(rowps, colps)); //deref pointer to modify value
            }
        }
    }
}
