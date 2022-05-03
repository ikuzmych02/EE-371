module DE1_SoC(CLOCK_50, SW, LEDR, HEX0, KEY);

	input logic [7:0] SW;
	input logic [3:0] KEY;
	input logic CLOCK_50;
	
	output logic [9:9] LEDR;
	output logic [6:0] HEX0;
	
	logic reset, clk, s;
	logic [6:0] leds;
	logic [3:0] seg7in;
	logic [7:0] A;
	logic oldKey0, newKey0;
	logic oldKey3, newKey3;
	
	// 2 DFFs to prevent metastability
	always_ff @(posedge clk) begin
		oldKey0 <= ~KEY[0];
		newKey0 <= oldKey0;
		
		oldKey3 <= ~KEY[3];
		newKey3 <= oldKey3;
	
	end // always_ff
	
	
	assign reset = newKey0;
	assign s = newKey3;
	assign clk = CLOCK_50;
	assign A = SW[7:0];
	
	assign HEX0 = leds;
	
	bitCount countOnes(.clk, .reset, .s, .A, .result(seg7in), .done(LEDR[9]));
	seg7 hexOut(.hex(seg7in), .leds);
	
endmodule



module DE1_SoC_testbench();
	
	logic [7:0] SW;
	logic [3:0] KEY;
	logic CLOCK_50;
	logic [9:9] LEDR;
	logic [6:0] HEX0;

	DE1_SoC dut(.*);
	// generated clock for sim
	initial begin
		CLOCK_50 = 1;
		forever #50 CLOCK_50 = ~CLOCK_50;
	end // initial	
	
	assign SW[7:0] = 8'b11001100;
	
	initial begin 
		KEY[0] <= 0; @(posedge CLOCK_50);
		KEY[0] <= 1; KEY[3] <= 1; @(posedge CLOCK_50);
		KEY[3] <= 0; repeat(15) @(posedge CLOCK_50);
		
		KEY[3] <= 1; repeat(3) @(posedge CLOCK_50);
	$stop;
	end
	
endmodule
