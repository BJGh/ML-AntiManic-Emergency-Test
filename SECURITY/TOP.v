`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:19 04/26/2021 
// Design Name: 
// Module Name:    TOP 
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
module TOP(
input CLK,
input BTN_RST,
input[4:0] SW,
input BTN_C,
input BTN_U,
output [3:0] LED);
reg [1:0] RST_SYNC;
wire RST_I;

always @(posedge CLK, negedge BTN_RST)
	if(~BTN_RST)
	RST_SYNC<=1'b1;
	else	
	RST_SYNC<={RST_SYNC[0],1'b0};
	
assign RST_I=RST_SYNC[1];

wire GEN_CEO;
wire LOAD_FSM;
wire CE_FSM;

GEN_CE2 FB1(
	.CLK(CLK),
	.RST(RST_I),
	.CEO(GEN_CEO)
);

BTN_FLTR FB2(
	.CLK(CLK),
	.RST(RST_I),
	.CE(GEN_CEO),
	.BTN_I(BTN_C),
	.BTN_CEO(CE_FSM)
);

BTN_FLTR FB3(
	.CLK(CLK),
	.RST(RST_I),
	.CE(GEN_CEO),
	.BTN_I(BTN_U),
	.BTN_CEO(LOAD_FSM)
);

FSM FB4(
.CLK(CLK),
.RST(RST_I),
.UP(SW[4]),
.LOAD(LOAD_FSM),
.CE(CE_FSM),
.DAT_I(SW[3:0]),
.DATA_O(LED)
);
endmodule
