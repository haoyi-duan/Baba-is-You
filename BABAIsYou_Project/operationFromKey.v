`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:34 01/03/2020 
// Design Name: 
// Module Name:    operationFromKey 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module operationFromKey(
	 input clk,
	 input keyReady,
    input [4:0] keyCode,
    output reg [4:0] op
    );
	
	reg wasReady;
	always @(posedge clk) begin
		wasReady <= keyReady;
		if (!wasReady && keyReady) begin
			op <= keyCode;
		end
	end

endmodule
