

//!Process takes old array, current array, usbbuffer uses/accesses keycode and keymap --> changes the usb buffer

//import USB-buffer.zig

//const USBBuffer = struct{
//	placeholder : u8,
//};


const numkeys: u8 = 4;


fn translate(r: u8, c:u8) u8{
	return(keymap.code(r, c));
}


pub fn process(comptime T: anytype, oldarray: [][]T , newarray: [][]T , buff: *USBBuffer) void{
	var chg: [][]T = compare(oldarray, newarray);
	//check rows and columns of array, use press/depress as needed
	var rowps: u8 = 0;
	var colps: u8 = 0;

	for (chg) |row|{
		for (row) |col|{
			if (col == 1){
				buff.*.press(translate(rowps, colps)); //deref pointer to modify value
			}else if(col == -1){
				buff.*.depress(translate(rowps, colps)); //deref pointer to modify value
			}
			colps += 1;
		}
		rowps += 1;
		colps = 0;
	}

}
