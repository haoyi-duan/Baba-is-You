`timescale 1us / 1ns
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:56:50 01/07/2021
// Design Name:   GameTop
// Module Name:   D:/ISE/BABAIsYou/SIM.v
// Project Name:  BABAIsYou
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: GameTop
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SIM;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire HSYNC;
	wire VSYNC;
	wire [3:0] Red;
	wire [3:0] Green;
	wire [3:0] Blue;

	// Bidirs
	wire [4:0] BTN_X;
	wire [3:0] BTN_Y;

	// Instantiate the Unit Under Test (UUT)
	GameTop uut (
		.clk(clk), 
		.rst(rst), 
		.BTN_X(BTN_X), 
		.BTN_Y(BTN_Y), 
		.HSYNC(HSYNC), 
		.VSYNC(VSYNC), 
		.Red(Red), 
		.Green(Green), 
		.Blue(Blue)
	);
	
	always begin
		#0.005;
		clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#0.002;
		rst = 0;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b11101;
		force BTN_Y = 4'b1101;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b11101;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b11101;
		force BTN_Y = 4'b1101;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b0111;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
		#12000;
		force BTN_X = 5'b11111;
		force BTN_Y = 4'b1111;
		#12000;
		force BTN_X = 5'b10111;
		force BTN_Y = 4'b1011;
	end
      
endmodule

