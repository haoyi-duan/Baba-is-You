`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:58:17 11/11/2020 
// Design Name: 
// Module Name:    pbdeBounce 
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
module pbdebounce(
	input wire clk_1ms,
	input wire [4:0] button, 
	output reg [4:0] pbreg
	);
 
	reg [7:0] pbshift = 8'b0;

	always@(posedge clk_1ms) begin
		pbshift = pbshift << 1;
		pbshift[0] = (button != 5'b11111);
		if (pbshift == 8'b0)
			pbreg <= 5'b0;
		if (pbshift == 8'hFF)
			pbreg <= button;	
	end
endmodule
