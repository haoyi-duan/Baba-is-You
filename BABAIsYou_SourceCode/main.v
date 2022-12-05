`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:23 01/07/2021 
// Design Name: 
// Module Name:    main 
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
module main(
	input wire clk, rst,
	input wire [4:0] key,
	input wire keyReady,
	input wire [11:0] ROM_dout,
	input wire [7:0] RAM_dout,
	output reg RAM_we,
	output reg [31:0] ROM_raddr, RAM_rwaddr,
	output reg [7:0] RAM_din,
	output reg [3:0] level
   );
	
	reg wasReady = 1'b0;
	reg [7:0] state = 8'h10;
	reg [4:0] keyReg;
	reg [4:0] x, y, x2, y2;
	reg [3:0] index, index2;
	reg [7:0] property;
	reg [4:0] pushNum = 5'b0;
	reg [8:0] curpos;
	wire [8:0] pos, pos2;
	assign pos = y * 20 + x;
	assign pos2 = y2 * 20 + x2;
	initial level = 4'b0;
	
	//上：01010 下：01110 左：01101 右：01111
	always @ (posedge clk) begin
		case(state)
			8'h0: begin//待命状态
				wasReady <= keyReady;
				if (!wasReady && keyReady) begin
					if (key == 5'b00110) state = 8'h10;//重置当前关卡
					else if (key == 5'b00101 && level != 0) begin//跳到上一关
						level = level - 1;
						state = 8'h10;
					end
					else if (key == 5'b00111 && level != 12) begin//跳到下一关
						level = level + 1;
						state = 8'h10;
					end
					else if (key == 5'b01010 || key == 5'b01110 || key == 5'b01101 || key == 5'b01111) begin
						x <= 5'h1F; y <= 5'h0;
						keyReg <= key;
						state = 8'h1;
					end
				end
			end
			8'h1: begin//扫描所有格子
				pushNum = 5'b0;
				if (x == 19 && y == 14) begin//扫描结束
					x <= 5'h1F; y <= 5'h0;
					state = 8'hf0;//根据下一帧地图进行属性和显示的更新
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'h2;
				end
			end
			8'h2: begin//获取格子内元素信息
				RAM_we = 0;
				RAM_rwaddr = {1'b0, pos};
				state = 8'h3;
			end
			8'h3: begin//获取格子内元素属性
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h1;//格子内元素是文字，无需检查，不能走动
				else begin
					index = RAM_dout[3:0];
					if (index < 3) index = 4'b0;
					else index = index - 4'd3;
					RAM_rwaddr = {6'b011111, index};//元素属性地址
					state = 8'h23;
				end
			end
			8'h23: begin
				if (RAM_dout[3:0] == 4'b0001 || RAM_dout[7:4] == 4'b0001) state = 8'h4;//格子元素可以走动
				else state = 8'h1;//不能走动
			end
			8'h4: begin//准备移动
				pushNum = pushNum + 1'b1;//记录累积检查的总格子数
				case(keyReg)
					5'b01010: begin//向上
						curpos = pos - (20 * pushNum);
						if(((pos - 20 * (pushNum - 1)) / 20) == 0) state = 8'h1;//走到最上
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01110: begin//向下
						curpos = pos + (20 * pushNum);
						if(((pos + 20 * (pushNum - 1)) / 20) == 14) state = 8'h1;//走到最下
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01101: begin//向左
						curpos = pos - (1 * pushNum);
						if(((pos - 1 * (pushNum - 1)) % 20) == 0) state = 8'h1;//走到最左
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
					5'b01111: begin//向右
						curpos = pos + (1 * pushNum);
						if(((pos + 1 * (pushNum - 1)) % 20) == 19) state = 8'h1;//走到最右
						else begin
							RAM_rwaddr = {1'b0, curpos};
							state = 8'h5;
						end
					end
				endcase
			end
			8'h5: begin//读取下一格元素
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h4;//下一格元素是文字，无需检查，可以推动
				else if (RAM_dout[5:4] == 2'b11) state = 8'h7;//下一格是空格，可以走过
				else begin//否则需要具体检测属性
					index = RAM_dout[3:0];
					if (index < 3) index = 4'b0;
					else index = index - 4'd3;//获取物体编号
					RAM_rwaddr = {6'b011111, index};//元素属性地址
					state = 8'h6;
				end
			end
			8'h6: begin//检查下一格元素属性
				if (RAM_dout[3:0] == 4'b0100 || RAM_dout[7:4] == 4'b0100) state = 8'h4;//可以推动
				else if (RAM_dout[3:0] == 4'b0011 || RAM_dout[7:4] == 4'b0011) state = 8'h1;//是障碍物
				else if (RAM_dout[3:0] == 4'b0010 || RAM_dout[7:4] == 4'b0010) begin//是终点
               if (pushNum == 1) begin//且不是被推动的物体
						level = level + 1;//进入下一关
						state = 8'h10;//更新初始地图
               end
					else state = 8'h7;//否则当成直接走过
				end
				else state = 8'h7;//可以走过
			end
			8'h7: begin//读取上一格信息
				RAM_we = 0;
				case(keyReg)
					5'b01010: RAM_rwaddr = {1'b0, curpos + 20};//向上
					5'b01110: RAM_rwaddr = {1'b0, curpos - 20};//向下
					5'b01101: RAM_rwaddr = {1'b0, curpos + 1} ;//向左
					5'b01111: RAM_rwaddr = {1'b0, curpos - 1} ;//向右
				endcase
				state = 8'h8;
			end
			8'h8: begin//写入该格信息
				RAM_we = 1;
				RAM_rwaddr = {1'b1, curpos};//下一帧地图中该格位置的地址
				if (RAM_dout[5:0] != 6'b000000 && RAM_dout[5:0] != 6'b000001 && RAM_dout[5:0] != 6'b000010 && RAM_dout[5:0] != 6'b000011)
					RAM_din = RAM_dout;//不是BABA，直接写入
				else case(keyReg)//否则判断BABA的朝向
					5'b01010: RAM_din = 8'b11000000;//向上
					5'b01110: RAM_din = 8'b11000001;//向下
					5'b01101: RAM_din = 8'b11000010;//向左
					5'b01111: RAM_din = 8'b11000011;//向右
				endcase
				case(keyReg)
					5'b01010: curpos = curpos + 20;//向上
					5'b01110: curpos = curpos - 20;//向下
					5'b01101: curpos = curpos + 1 ;//向左
					5'b01111: curpos = curpos - 1 ;//向右
				endcase
				pushNum = pushNum - 1'b1;//回退一格
				if (pushNum == 0) state = 8'h9;//如果已经推完了所有格子，则更改最开始的格子
				else state = 8'h7;//否则继续处理
			end
			8'h9: begin//开始判断是否要更新初始格
			if((keyReg == 5'b01110 && curpos / 20 != 0) || (keyReg == 5'b01111 && curpos % 20 != 0)) begin//如果是向右走或向下走，要对上一格作判断
					RAM_we = 0;
					if (keyReg == 5'b01110) curpos = curpos - 20;
					else curpos = curpos - 1;
					RAM_rwaddr = {1'b0, curpos};//检查上一格元素内容
					state = 8'ha;
				end
				else state = 8'hc;//否则直接改写初始格
			end
			8'ha: begin
				if (RAM_dout[4] ^ RAM_dout[5]) state = 8'h9;//上一格元素是文字，可以推动，接着检查
				else if (RAM_dout[4:3] == 2'b11) state = 8'hc;//上一格为空，直接改写初始格
				else begin
					index = RAM_dout[3:0];
					if (index < 4'd3) index = 4'b0;
					else index = index - 4'd3;//获取物体编号
					RAM_rwaddr = {6'b011111, index};//元素属性地址
					state = 8'hb;
				end
			end
			8'hb: begin//检查当前格元素
				if (RAM_dout[3:0] == 4'b0001 || RAM_dout[7:4] == 4'b0001) state = 8'h1;//可以走动，不改写初始格
				else if (RAM_dout[3:0] == 4'b0100 || RAM_dout[7:4] == 4'b0100) state = 8'h9;//可以推动，接着检查
				else state = 8'hc;//可以走过
			end
			8'hc: begin//清除初始格
				RAM_we = 1;
				RAM_rwaddr = {1'b1, pos};
				RAM_din = 8'b11111111;
				state = 8'h1;
			end
			
			/////////////////////////////////////////
			
			//更新层数
			8'h10: begin
				x <= 5'h1F; y <= 5'h0;
				state = 8'h11;
			end
			8'h11: begin
				if (x == 19 && y == 14) begin
					x <= 5'h1F; y <= 5'h0;
					state = 8'hf0;//扫描完毕，根据下一帧地图进行属性和显示的更新
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'h12;
				end
			end
			8'h12: begin//读取初始地图的格子内元素
				ROM_raddr = {4'b1000, level, pos};
				state = 8'h13;
			end
			8'h13: begin//将每一格内元素写入下一帧地图
				RAM_we = 1;
				RAM_rwaddr = {1'b1, pos};
				RAM_din = {2'b11, ROM_dout[5:0]};
				state = 8'h11;
			end
			
			/////////////////////////////////////////
			
			//根据下一帧地图更改元素属性
			8'hf0: begin//扫描地图
				if (x == 19 && y == 14) begin
					x <= 5'h1F; y <= 5'h0;
					state = 8'hfa;//准备将当前地图更新为下一帧地图
				end else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'hf1;
				end
			end
			8'hf1: begin//读取当前格的下一帧信息
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos};
				state = 8'hf2;
			end
			8'hf2: begin//更改当前格
				if (RAM_dout[5:4] == 2'b01) begin//如果是物体文字
					index = RAM_dout[3:0];//获取物体编号
					state = 8'hf3;//要进行判定
				end
				else state = 8'hf0;
			end
			8'hf3: begin//属性判定，横向本格
				RAM_we = 0;
				if (x == 19 || x == 18) begin//如果横向空间不足以构成语句
					property[3:0] = 4'b0000;//没有属性
					state = 8'hf6;//跳到纵向判定
				end else begin//否则看右边一格
					RAM_rwaddr = {1'b1, pos + 9'd1};
					state = 8'hf4;
				end
			end
			8'hf4: begin//属性判定，横向第一格
				if (RAM_dout[5:0] != 6'b100000) begin//如果右边一格不是IS
					property[3:0] = 4'b0000;//没有属性
					state = 8'hf6;//跳到纵向判定
				end else begin//否则看右边第二格
					RAM_rwaddr = {1'b1, pos + 9'd2};
					state = 8'hf5;
				end
			end
			8'hf5: begin//属性判定，横向第二格
				if (RAM_dout[5:4] == 2'b10)//如果是属性文字
					property[3:0] = RAM_dout[3:0];//记录属性
				else property[3:0] = 4'b0000;//否则没有属性
				if (RAM_dout[5:4] != 2'b01) state = 8'hf6;//如果不是物体文字
				else begin//如果是物体文字
						index2 = RAM_dout[3:0];
						x2 <= 5'h1F; y2 <= 5'h0;
						state = 8'he0;//开始扫描地图，转换物体元素
				end
			end
			8'he0: begin//扫描地图
				if (x2 == 19 && y2 == 14)
					state = 8'hf6;
				else begin
					if (x2 == 19) begin
						x2 <= 0;
						y2 <= y2 + 1'b1;
					end else x2 <= x2 + 1'b1;
					state = 8'he1;
				end
			end
			8'he1: begin//获取格内物体
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos2};
				state = 8'he2;
			end
			8'he2: begin
				if (RAM_dout[5:4] == 2'b00 && ((RAM_dout[3:0] < 4'd3) ? 4'd3 : RAM_dout[3:0]) - 4'd3  == index) begin//如果是要改变的物体
					RAM_we = 1;
					RAM_rwaddr = {1'b1, pos2};
					RAM_din = {4'b1100, index2 + 4'd3};
				end
				state = 8'he0;
			end
			
			8'hf6: begin//属性判定，纵向本格
				if (y == 14 || y == 13) begin//如果纵向空间不足以构成语句
					property[7:4] = 4'b0000;//没有属性
					state = 8'hf9;//跳到属性输入
				end else begin//否则看下边一格
					RAM_rwaddr = {1'b1, pos + 9'd20};
					state = 8'hf7;
				end
			end
			8'hf7: begin//属性判定，纵向第一格
				if (RAM_dout[5:0] != 6'b100000) begin//如果右边一格不是IS
					property[7:4] = 4'b0000;//没有属性
					state = 8'hf9;//跳到属性输入
				end else begin//否则看下边第二格
					RAM_rwaddr = {1'b1, pos + 9'd40};
					state = 8'hf8;
				end
			end
			8'hf8: begin//属性判定，纵向第二格
				if (RAM_dout[5:4] == 2'b10)//如果是属性文字
					property[7:4] = RAM_dout[3:0];//记录属性
				else property[7:4] = 4'b0000;//否则没有属性
				if (RAM_dout[5:4] != 2'b01) state = 8'hf9;//如果是物体文字
				else begin
					index2 = RAM_dout[3:0];
					x2 <= 5'h1F; y2 <= 5'h0;
					state = 8'hea;//开始扫描地图，转换物体元素
				end
			end
			8'hea: begin//扫描地图
				if (x2 == 19 && y2 == 14)
					state = 8'hf9;
				else begin
					if (x2 == 19) begin
						x2 <= 0;
						y2 <= y2 + 1'b1;
					end else x2 <= x2 + 1'b1;
					state = 8'heb;
				end
			end
			8'heb: begin//获取格内物体
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos2};
				state = 8'hec;
			end
			8'hec: begin
				if (RAM_dout[5:4] == 2'b00 && ((RAM_dout[3:0] < 4'd3) ? 4'd3 : RAM_dout[3:0]) - 4'd3 == index) begin//如果是要改变的物体
					RAM_we = 1;
					RAM_rwaddr = {1'b1, pos2};
					RAM_din = {4'b1100, index2 + 4'd3};
				end
				state = 8'hea;
			end
			
			8'hf9: begin//写入属性
				if (property == 8'b0001_0010 || property == 8'b0010_0001) begin//如果有元素同时具有YOU和WIN属性
					level = level + 1;
					state = 8'h10;
				end else begin
					RAM_we = 1;
					RAM_rwaddr = {6'b011111, index};
					RAM_din = property;
					state = 8'hf0;
				end
			end
			
			//将当前地图更新为下一帧地图
			8'hfa: begin//扫描地图
				if (x == 19 && y == 14)
					state = 8'h0;
				else begin
					if (x == 19) begin
						x <= 0;
						y <= y + 1'b1;
					end else x <= x + 1'b1;
					state = 8'hfb;
				end
			end
			8'hfb: begin//读取当前格的下一帧信息
				RAM_we = 0;
				RAM_rwaddr = {1'b1, pos};
				state = 8'hfc;
			end
			8'hfc: begin//更改当前格
				RAM_we = 1;
				RAM_din = RAM_dout;
				RAM_rwaddr = {1'b0, pos};
				state = 8'hfa;
			end
		endcase
	end

endmodule
