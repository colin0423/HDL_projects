`timescale 1ns/1ps


`include "NR.v"
`include "timing_generator.v"
`include "image_capture.v"
`include "image_source.v"


module DUT_tb;


reg  [10:0] v_total, v_size;
reg  [9:0]  v_start, v_sync;
reg  [11:0] h_total, h_size;
reg  [10:0] h_start, h_sync;
reg  [22:0] vs_reset; 
reg  rst_n,clk;
wire A_M;

wire [26:0] DPi_DUT, DPo_DUT;
wire [2:0] Sync;

reg [31:0] check;

initial begin
					
/********** Timing parameter **********/
 		
  #0  clk =0;
	#0  rst_n =1;

	h_size  = 12'd640;
  h_total = 12'd768;  
  h_sync  = 11'd32;
  h_start = 11'd104;
  v_size  = 11'd480;	
  v_total = 11'd525;
  v_sync  = 10'd3;
  v_start = 10'd35;
	#10 rst_n =0;
	#10 rst_n =1;
#6500000
$finish;

end	
	
	always #(2.5) clk=~clk;

/********** Waveform output **********/

initial begin
    `ifdef FSDB
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0);
    `elsif FSDB_ALL
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0, "+mda");
    `endif
end


 
/********** Image source **********/
image_source image_source(
   .clk(clk),
   .rst_n(rst_n),
   .Synci(Sync),
   .DPo(DPi_DUT));
/********** Timing generator **********/
timing_generator timing_generator_source(
  .Synco(Sync),
  .clk(clk),
  .rst_n(rst_n),
  .v_total(v_total),
  .v_sync(v_sync),
  .v_start(v_start),
  .v_size(v_size),
  .h_total(h_total),
  .h_sync(h_sync),
  .h_start(h_start),
  .h_size(h_size),
  .vs_reset(0));

/********** Timing generator **********/
timing_generator timing_generator_NR(
  .Synco(DPo_DUT[26:24]),
  .clk(clk),
  .rst_n(rst_n),
  .v_total(v_total),
  .v_sync(v_sync),
  .v_start(v_start),
  .v_size(v_size),
  .h_total(h_total),
  .h_sync(h_sync),
  .h_start(h_start),
  .h_size(h_size),
  .vs_reset(772));

/********** Function to be verified (DUT) **********/

NR NR(
  .clk(clk),
  .rst_n(rst_n),
  .A_M(A_M),
  .DPi(DPi_DUT),
  .DPo(DPo_DUT[23:0]));

/********** Image capture (saved to BMP file) **********/

image_capture image_capture(
  .clk(clk),
  .rst_n(rst_n),
  .DPi(DPo_DUT),
  .Hsize(h_size),
  .Vsize(v_size),
  .A_M(A_M));

endmodule

