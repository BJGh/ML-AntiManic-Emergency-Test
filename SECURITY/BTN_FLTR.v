`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BurinZhargal Computer Soyot Industries International Bureau of Jargalizment
// Engineer: 
// 
// Create Date:    11:37:35 04/26/2021 
// Design Name: 
// Module Name:    BTN_FLTR 
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
module BTN_FLTR(
	input CLK,
	input RST,
	input CE,
	input BTN_I,

	output reg BTN_CEO
);
reg BTN_O;
reg[1:0] BTN_I_SYNC;
reg[3:0] CNT;
always @(posedge CLK, posedge RST)
	begin
	if(RST)
	BTN_I_SYNC<=2'b00;
	else
	BTN_I_SYNC<={BTN_I_SYNC[0], BTN_I};
	if (RST)
	CNT<=4'b0000;
	else if(BTN_I_SYNC[1]~^BTN_O)
	CNT<=4'b0000;
	else if(CE)
	CNT<=CNT+1;
	end
always@(posedge CLK, posedge RST)
	if(RST)
	BTN_O<=1'b0;
	else if (&(CNT)&CE)
	BTN_O<=BTN_I_SYNC[1];
always@(posedge CLK, posedge RST)
	if(RST) 
	BTN_CEO<=1'b0;
	else
	BTN_CEO<=&(CNT)&CE&BTN_I_SYNC[1];
endmodule

