`timescale 1ns/10ps
`include "../src/timing_generator.v"
`include "image_capture.v"
`include "image_source.v"

`ifdef SYN
  `ifdef AP_TB
    `include "../syn/AP_syn.v"
  `elsif CSC_TB
    `include "../syn/CSC_syn.v"
  `endif
`else
  `ifdef AP_TB
    `include "../src/AP.v"
  `elsif CSC_TB
    `include "../src/CSC.v"
  `endif
`endif

module DUT_tb;

reg clk;
reg rst_n;
reg record;
reg start;

wire [26:0] DPi;
//TG
reg  [10:0] v_total, v_size;
reg  [9:0]  v_start, v_sync;
reg  [11:0] h_total, h_size;
reg  [10:0] h_start, h_sync;
reg  [22:0] vs_reset; 
wire [2:0] Synco;

//AP
reg [3:0] AP_mode;
reg AP_en;

//CSC
reg [1:0] CSC_mode;
wire [26:0] DPo_final;
wire [23:0] DPo_value;
reg [23:0] golden;
reg [18:0] ERROR_CNT, CNT;
//tb variable
string gold;
integer fd, answer_get, data, answer, charcount;

assign DPo_value = DPo_final[23:0];

initial begin
					
/********** Timing parameter **********/
h_size  = 640;
v_size  = 480;	
h_total = 800;
v_total = 525;
h_sync  = 96;
v_sync  = 2;
h_start = 144;
v_start = 35;
vs_reset = 23'd0;

`ifdef PASS_TEST
  AP_en = 0;
`elsif NONE
  AP_en = 1;
`endif

end		

always #2.5 clk = ~clk;

always @(posedge clk)
begin
  if(!rst_n)
  begin
      AP_mode <= 4'd0;
      record  <= 1'b0;
  end
  else
  begin
		if(Synco[2] && record == 1'b0 && start)
		begin
			record <= 1'b1;
			AP_mode <= AP_mode + 1;
		end
		else if(!Synco[2] && record == 1'b1 && start)
		begin
			record <= 1'b0;
		end
  end
end

initial begin
    clk = 1; 
    rst_n = 0;
    start = 0;

    `ifdef RGB2YUV
      CSC_mode = 2'b00;
    `elsif YUV2RGB
      CSC_mode = 2'b01;
    `elsif RGB2RGB
      CSC_mode = 2'b10;
    `endif

    # 200 rst_n = 1;
    #50000 start = 1;
	  `ifdef AP_TB
	  	wait(AP_mode == 4'hf);
	  	#4000000 $finish;
	  `elsif CSC_TB
	  	wait(CNT == 19'd307199);
      if(ERROR_CNT == 0)
      begin
          $display("\n");
          $display("        |\\/\\/\\/|     ************************************** "); 
          $display("        |      |     **                                  ** "); 
          $display("        |      |     **                                  ** "); 
          $display("        | (O)(O)     **        Congratulations !!        ** "); 
          $display("        C      _D    **                                  ** ");
          $display("         | ,___|     **        Simulation PASS!!!        ** "); 
          $display("         |   /       **                                  ** "); 
          $display("        /____\\       **                                  **  "); 
          $display("       /      \\      **************************************  ");   
          $display("\n");
      end
      else
      begin
          $display("\n");
          $display("        |\\/\\/\\/|     ************************************** "); 
          $display("        |      |     **                                  ** "); 
          $display("        |      |     **    HELL NAH !!                   ** "); 
          $display("        | (x)(x)     **                                  ** "); 
          $display("        C      _D    **    Simulation FAIL!!             ** ");
          $display("         | ,___|     **                                  ** "); 
          $display("         |   /       **    Pass = %6d, Fail = %6d  ** ", 307199-ERROR_CNT,ERROR_CNT); 
          $display("        /____\\       **                                  **  "); 
          $display("       /      \\      **************************************  ");   
          $display("\n");
      end
      $finish;
	  `endif 
end	


/********** Waveform output **********/
initial begin
   `ifdef FSDB
      $fsdbDumpfile("top.fsdb");
      $fsdbDumpvars;
    `elsif FSDB_ALL
      $fsdbDumpfile("top.fsdb");
      $fsdbDumpvars;
      $fsdbDumpMDA;
    `endif
end

/********** Image source **********/
image_source image_source(
   .clk(clk),
   .rst_n(rst_n),
   .Synci(Synco),
   .DPo(DPi));
/********** Timing generator **********/
timing_generator timing_generator(
  .Synco(Synco),
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
  .vs_reset(vs_reset));

/********** Function to be verified (DUT) **********/

`ifdef AP_TB
    AP DUT1(
          .clk(clk),
          .rst_n(rst_n),
          .Tp_H(h_size),
          .Tp_V(v_size),
          .enable(AP_en),
          .Mode(AP_mode),
          .DPi(DPi),
          .DPo(DPo_final)
    );
`elsif CSC_TB
    CSC DUT2(
        .clk(clk),
        .rst_n(rst_n),
        .Mode(CSC_mode),
        .DPi(DPi),
        .DPo(DPo_final)
    );
`endif


/********** Image capture (saved to BMP file) **********/
`ifdef AP_TB
  image_capture image_capture(
    .clk(clk),
    .rst_n(rst_n),
    .AP_en(AP_en),
    .AP_mode(AP_mode),
    .DPi(DPo_final),
    .Hsize(h_size),
    .Vsize(v_size)
  );
`elsif CSC_TB
  initial
  begin
    `ifdef RGB2YUV
      fd = $fopen("../image/golden/golden_YUV.txt", "r");
    `elsif YUV2RGB
      fd = $fopen("../image/golden/golden_RGB.txt", "r");
    `elsif RGB2RGB
      fd = $fopen("../image/golden/golden_RGB2.txt", "r");
    `endif
    charcount = $fgets(gold, fd);
    charcount = $sscanf(gold, "%h", golden);
    if(fd == 0)
    begin
      $display("Couldn't open the file");
      $stop;
    end
  end
  always@(posedge clk)
  begin
    if(!rst_n)
    begin
      ERROR_CNT <= 19'd0;
      CNT <= 19'd0;
    end
    else if(DPo_final[24])
    begin
      CNT <= CNT + 1;
      if(DPo_final[23:0] != golden)
      begin
        $display("--------pixel %5d--------",CNT);
        $display("your answer:%6h  golden:%6h, ERROR!!\n",DPo_final[23:0],golden);
      end
      ERROR_CNT <= (DPo_final[23:0] != golden) ? ERROR_CNT + 1 : ERROR_CNT;
      charcount = $fgets(gold, fd);
      charcount = $sscanf(gold, "%h", golden);
    end  
  end
`endif

endmodule
  

