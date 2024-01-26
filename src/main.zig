//!main

//initialize USBbuffer
//initialize arrays (make change array)

//loop
//scan
//process

//provide USBbuffer

const b = @import("usb-buffer.zig");
const p = @import("process.zig");
const mkchg = @import("matrix.zig").makeChangeArray;

fn scan() [][]u8 {
    return ([_][1]u8{[_]u8{ 1, 0, 1, 0 }});
}

pub fn main() !void {
    var buffer: b.USBBuffer = b.USBBuffer.init();

    var newarray = mkchg();
    var oldarray = mkchg();

    while (true) {
        oldarray = newarray; //old array pointer points to new array
        newarray = scan(); //new array pointer points to scanned array
        p.process(u8, oldarray, newarray, buffer);
    }
}
