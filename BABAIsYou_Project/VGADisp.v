`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:16 01/02/2021 
// Design Name: 
// Module Name:    VGADisp 
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
module VGADisp(
	input wire clk,
	input wire [11:0] ROM_dout,
	input wire [7:0] RAM_dout,
	output reg [31:0] ROM_raddr, RAM_raddr,
	output reg VRAM_we,
	output reg [31:0] VRAM_waddr,
	output reg [11:0] VRAM_din
   );
	
	reg [2:0] state = 2'b00;
	reg [9:0] xpos = 10'b0;
	reg [9:0] ypos = 10'b0;
	
	wire [4:0] grid_x, grid_y, rela_x, rela_y;
	wire [8:0] pos;
	wire [9:0] relapos;
	assign grid_x = xpos / 32;
	assign grid_y = ypos / 32;
	assign rela_x = xpos % 32;
	assign rela_y = ypos % 32;
	
	assign pos = grid_y * 20 + grid_x;
	assign relapos = rela_y * 32 + rela_x;
	always @ (posedge clk) begin
		case(state)
			2'b00: begin
				if (xpos == 639) begin
					if (ypos == 479) begin
						xpos<=0; ypos<=0;
					end
					else begin
						xpos <= 0;
						ypos <= ypos + 1'b1;
					end
				end
				else xpos <= xpos+1'b1;
				state <= 2'b01;
			end
			2'b01: begin
				RAM_raddr <= {1'b0, pos};
				state <= 2'b10;
			end
			2'b10:begin
				ROM_raddr <= {1'b0, RAM_dout[5:0], relapos};
				state <= 2'b11;
			end
			2'b11:begin
				VRAM_we <= 1'b1;
				VRAM_waddr <= ypos * 640 + xpos;
				VRAM_din <= ROM_dout;
				state <= 2'b00;
			end
		endcase
	end
	
endmodule
