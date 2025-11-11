/**********************************************************************/
//      COPYRIGHT (C)  National Chung-Cheng University
//
// MODULE:        To generate image pixel sequence to circuit under test
//
// FILE NAME:     image_source.v
// VERSION:       1.0
// DATE:          Oct. 12, 2009
// AUTHOR:        Chao-Yung Chang
// 
// CODE TYPE:     RTL model
//
// DESCRIPTION:   Use to verify image processing blocks
//
// Revisions:     2009/10/12  created by sunrise          
/**********************************************************************/

module image_source(
  
input             clk,               
input             rst_n,
input     [26:24] Synci,
output reg [26:0] DPo);

// Bits per pixel
parameter BPP = 24;
// Bitmap width
parameter BITMAP_WIDTH = 640;
// Bitmap height
parameter BITMAP_HEIGHT = 480;
// Image buffer
reg [BPP-1:0] img_buf [0:BITMAP_WIDTH*BITMAP_HEIGHT-1];
// Image buffer index
reg [31:0] i;



initial begin
   `ifdef IMG1
   $readmemh("../image_in/karina_noisy.txt", img_buf);
   `elsif IMG2
   $readmemh("../image_in/miyeon_noisy.txt", img_buf);
   `elsif IMG3
   $readmemh("../image_in/yuna_noisy.txt", img_buf);
   `endif
end

// DPo
always @(posedge clk or negedge rst_n)
begin
   if (!rst_n) DPo <= 27'b0;
   else
   begin
      if (Synci[24]) DPo[23:0] <= img_buf[i];
      DPo[26:24] <= Synci[26:24];
   end 
end

// Image buffer index
always @(posedge clk or negedge rst_n)
begin
   if (!rst_n) i <= 32'b0;
   else
   begin
      if (Synci[26]) i <= 32'b0;
      if (Synci[24]) i <= i + 1'b1;
   end   
end

endmodule    

  
