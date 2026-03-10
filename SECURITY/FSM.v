`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:38:49 04/26/2021 
// Design Name: 
// Module Name:    FSM 
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
module FSM(
	input CLK,
	input RST,
	input UP,
	input [3:0] DAT_I,
	input LOAD,
	input CE,
	output [3:0] DATA_O
    );

reg [3:0] CODE;
reg [7:0] STATE;

always @(DAT_I)
		case(DAT_I)
		4'b0000:CODE<=4'b0101;
		4'b0001:CODE<=4'b1100;
		4'b0010:CODE<=4'b0000;
		4'b0011:CODE<=4'b1000;
		4'b0100:CODE<=4'b0110;
		4'b0101:CODE<=4'b1000;
		4'b0110:CODE<=4'b0101;
		4'b0111:CODE<=4'b1111;
		4'b1000:CODE<=4'b1001;
		4'b1001:CODE<=4'b1101;
		4'b1010:CODE<=4'b1001;
		4'b1011:CODE<=4'b1110;
		4'b1100:CODE<=4'b1100;
		4'b1101:CODE<=4'b0111;
		4'b1110:CODE<=4'b1111;
		4'b1111:CODE<=4'b1100;
		default:CODE<=0;
		endcase;
		
always @(posedge CLK, posedge RST)
		begin
	if(RST)
		begin
		STATE<=8'h05;;
		end
	else if (LOAD)
	begin
	STATE<=CODE;
	end
	else
	case(STATE)
	8'h05:
		if (CE & UP)
			STATE<=8'h0C;
		else if (CE & ~UP)
			STATE<=8'h2C; 
		else if (~CE)
			STATE<=STATE;
	8'h0C:
		if (CE & UP)
			STATE<=8'h00;
		else if (CE & ~UP)
			STATE<=8'h05;
		else if (~CE)
			STATE<=STATE;
	8'h00:
		if (CE & UP)
			STATE<=8'h08;
		else if (CE & ~UP)
			STATE<=8'h0C;
		else if (~CE)
			STATE<=STATE;
	8'h08:
		if (CE & UP)
			STATE<=8'h06;
		else if (CE & ~UP)
			STATE<=8'h00;
		else if (~CE)
			STATE<=STATE;
	8'h06:
		if (CE & UP)
			STATE<=8'h18;
		else if (CE & ~UP)
			STATE<=8'h08;
		else if (~CE)
			STATE<=STATE;
	8'h18: 
		if (CE & UP)
			STATE<=8'h15;
		else if (CE & ~UP)
			STATE<=8'h06;
		else if (~CE)
			STATE<=STATE;
	8'h15:
		if (CE & UP)
			STATE<=8'h0F;
		else if (CE & ~UP)
			STATE<=8'h18;
		else if (~CE)
			STATE<=STATE;		
	8'h0F:
		if (CE & UP)
			STATE<=8'h09;
		else if (CE & ~UP)
			STATE<=8'h15;
		else if (~CE)
			STATE<=STATE;
	8'h09:
		if (CE & UP)
			STATE<=8'h0D;
		else if (CE & ~UP)
			STATE<=8'h0F;
		else if (~CE)
			STATE<=STATE;
	8'h0D:
		if (CE & UP)
			STATE<=8'h19;
		else if (CE & ~UP)
			STATE<=8'h09;
		else if (~CE)
			STATE<=STATE;
	8'h19:
		if (CE & UP)
			STATE<=8'h0E;
		else if (CE & ~UP)
			STATE<=8'h0D;
		else if (~CE)
			STATE<=STATE;
	8'h0E:
		if (CE & UP)
			STATE<=8'h1C;
		else if (CE & ~UP)
			STATE<=8'h19;
		else if (~CE)
			STATE<=STATE;
	8'h1C:
		if (CE & UP)
			STATE<=8'h07;
		else if (CE & ~UP)
			STATE<=8'h0E;
		else if (~CE)
			STATE<=STATE;
	8'h07:
		if (CE & UP)
			STATE<=8'h1F;
		else if (CE & ~UP)
			STATE<=8'h1C;
		else if (~CE)
			STATE<=STATE;
	8'h1F:
		if (CE & UP)
			STATE<=8'h2C;
		else if (CE & ~UP)
			STATE<=8'h07;
		else if (~CE)
			STATE<=STATE;
	8'h2C:
		if (CE & UP)
			STATE<=8'h05;
		else if (CE & ~UP)
			STATE<=8'h1F;
		else if (~CE)
			STATE<=STATE;
	endcase;
		end
		assign DATA_O = STATE[3:0];
endmodule
