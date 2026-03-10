`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:43:23 04/26/2021
// Design Name:   FSM
// Module Name:   D:/Apps/Xilinx/Works/LR2/Lab2/TEST.v
// Project Name:  Lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TEST;

	// Inputs
	reg CLK;
	reg RST;
	reg UP;
	reg [3:0] DAT_I;
	reg LOAD;
	reg CE;

	// Outputs
	wire [3:0] DATA_O;

	// Instantiate the Unit Under Test (UUT)
	FSM uut (
		.CLK(CLK), 
		.RST(RST), 
		.UP(UP), 
		.DAT_I(DAT_I), 
		.LOAD(LOAD), 
		.CE(CE), 
		.DATA_O(DATA_O)
	);
	
	
	always 
		begin
			CLK = 0;
			#5;
			CLK = 1;
			#5;
		end
	
	initial begin
		CE = 0;
		DAT_I = 0;
		LOAD = 0;
		RST = 0;
		UP = 0;
		#15;
		RST = 1;
		#20;
		RST = 0;
		#10;
		
		UP = 1;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		
		UP = 0;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		CE = 1;
		#10;
		CE = 0;
		#10;
		DAT_I = 4'h4;
		#30;
		LOAD = 1;
		#10;
		LOAD = 0;
		#10;
		DAT_I = 4'hA;
		#30;
		LOAD = 1;
		#10;
		LOAD = 0;
		#30;
		$stop;
		
	end
      
endmodule
