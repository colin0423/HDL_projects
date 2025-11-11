/**********************************************************************/
//      COPYRIGHT (C)  National Chung-Cheng University
//
// MODULE:        To Capture image pixel sequence generated from DUT
//
// FILE NAME:     image_capture.v
// CODE TYPE:     RTL model
//
// DESCRIPTION:   Use to verify image processing blocks
//                Capture output of Circuit Under Test into .tbl file
//                then convert to *.bmp file for comparing
//      
/**********************************************************************/

module image_capture(

  input        clk,
  input        rst_n,
  input        AP_en,
  input [3:0]  AP_mode,
  input [26:0] DPi,
  input [11:0] Hsize,
  input [10:0] Vsize);

// Output filename
parameter file_name = "./image_out/img_out.bmp";

// Output channels control
// (R, G, B) or (Y, Cb, Cr) or (Y, U, V) or (Y, I, Q) channels
parameter r_channel = 1;
parameter g_channel = 1;
parameter b_channel = 1;

// File handle
integer fp_0, fp_1, fp_2, fp_3, fp_4, fp_5, fp_6, fp_7, fp_8, fp_9, fp_10, fp_11, fp_12, fp_13, fp_14, fp_15;

// Pixel position
integer x, y, count;

// Image size
wire [31:0] img_size = Hsize*Vsize*3;

// Header size (file header + DIB header)
// Windows and OS/2 Bitmap headers: 14 bytes (file header)
// Windows BITMAPINFOHEADER: 40 bytes (DIB header)

parameter file_header_size = 14;
parameter DIB_header_size = 40;
parameter header_size = file_header_size+DIB_header_size;

initial #1 begin


   ////////////////////////////fp_0////////////////////////////
   wait(AP_mode == 4'b0000);
   if(AP_en && AP_mode == 4'b0000)
   begin
      fp_0 = $fopen ("../image_out/mode_0.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_0.bmp");

      // BMP Header
      $fwrite (fp_0, "%s", "BM");                 // MB header
      $fwrite (fp_0, "%u", img_size+header_size); // File size
      $fwrite (fp_0, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_0, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_0, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_0, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_0, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_0, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_0, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_0, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_0, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_0, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_0, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_0, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_0, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_0, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_0, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_0, "%c", DPi[7:0]);
            else $fwrite (fp_0, "%c", 8'b0);
            if (g_channel) $fwrite (fp_0, "%c", DPi[15:8]);
            else $fwrite (fp_0, "%c", 8'b0);
            if (r_channel) $fwrite (fp_0, "%c", DPi[23:16]);
            else $fwrite (fp_0, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_0);
   end

   ////////////////////////////fp_1////////////////////////////
   wait(AP_mode == 4'b0001);
   if(AP_en && AP_mode == 4'b0001)
   begin
      fp_1 = $fopen ("../image_out/mode_1.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_1.bmp");

      // BMP Header
      $fwrite (fp_1, "%s", "BM");                 // MB header
      $fwrite (fp_1, "%u", img_size+header_size); // File size
      $fwrite (fp_1, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_1, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_1, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_1, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_1, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_1, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_1, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_1, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_1, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_1, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_1, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_1, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_1, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_1, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_1, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_1, "%c", DPi[7:0]);
            else $fwrite (fp_1, "%c", 8'b0);
            if (g_channel) $fwrite (fp_1, "%c", DPi[15:8]);
            else $fwrite (fp_1, "%c", 8'b0);
            if (r_channel) $fwrite (fp_1, "%c", DPi[23:16]);
            else $fwrite (fp_1, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_1);
   end
   ////////////////////////////fp_2////////////////////////////
   wait(AP_mode == 4'b0010);
   if(AP_en && AP_mode == 4'b0010)
   begin
      fp_2 = $fopen ("../image_out/mode_2.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_2.bmp");

      // BMP Header
      $fwrite (fp_2, "%s", "BM");                 // MB header
      $fwrite (fp_2, "%u", img_size+header_size); // File size
      $fwrite (fp_2, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_2, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_2, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_2, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_2, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_2, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_2, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_2, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_2, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_2, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_2, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_2, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_2, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_2, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_2, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_2, "%c", DPi[7:0]);
            else $fwrite (fp_2, "%c", 8'b0);
            if (g_channel) $fwrite (fp_2, "%c", DPi[15:8]);
            else $fwrite (fp_2, "%c", 8'b0);
            if (r_channel) $fwrite (fp_2, "%c", DPi[23:16]);
            else $fwrite (fp_2, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_2);
   end
   ////////////////////////////fp_3////////////////////////////
   wait(AP_mode == 4'b0011);
   if(AP_en && AP_mode == 4'b0011)
   begin
      fp_3 = $fopen ("../image_out/mode_3.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_3.bmp");

      // BMP Header
      $fwrite (fp_3, "%s", "BM");                 // MB header
      $fwrite (fp_3, "%u", img_size+header_size); // File size
      $fwrite (fp_3, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_3, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_3, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_3, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_3, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_3, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_3, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_3, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_3, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_3, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_3, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_3, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_3, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_3, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_3, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_3, "%c", DPi[7:0]);
            else $fwrite (fp_3, "%c", 8'b0);
            if (g_channel) $fwrite (fp_3, "%c", DPi[15:8]);
            else $fwrite (fp_3, "%c", 8'b0);
            if (r_channel) $fwrite (fp_3, "%c", DPi[23:16]);
            else $fwrite (fp_3, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_3);
   end
   ////////////////////////////fp_4////////////////////////////
   wait(AP_mode == 4'b0100);
   if(AP_en && AP_mode == 4'b0100)
   begin
      fp_4 = $fopen ("../image_out/mode_4.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_4.bmp");

      // BMP Header
      $fwrite (fp_4, "%s", "BM");                 // MB header
      $fwrite (fp_4, "%u", img_size+header_size); // File size
      $fwrite (fp_4, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_4, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_4, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_4, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_4, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_4, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_4, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_4, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_4, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_4, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_4, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_4, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_4, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_4, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_4, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_4, "%c", DPi[7:0]);
            else $fwrite (fp_4, "%c", 8'b0);
            if (g_channel) $fwrite (fp_4, "%c", DPi[15:8]);
            else $fwrite (fp_4, "%c", 8'b0);
            if (r_channel) $fwrite (fp_4, "%c", DPi[23:16]);
            else $fwrite (fp_4, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_4);
   end
   ////////////////////////////fp_5////////////////////////////
   wait(AP_mode == 4'b0101);
   if(AP_en && AP_mode == 4'b0101)
   begin
      fp_5 = $fopen ("../image_out/mode_5.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_5.bmp");

      // BMP Header
      $fwrite (fp_5, "%s", "BM");                 // MB header
      $fwrite (fp_5, "%u", img_size+header_size); // File size
      $fwrite (fp_5, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_5, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_5, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_5, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_5, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_5, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_5, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_5, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_5, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_5, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_5, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_5, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_5, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_5, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_5, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_5, "%c", DPi[7:0]);
            else $fwrite (fp_5, "%c", 8'b0);
            if (g_channel) $fwrite (fp_5, "%c", DPi[15:8]);
            else $fwrite (fp_5, "%c", 8'b0);
            if (r_channel) $fwrite (fp_5, "%c", DPi[23:16]);
            else $fwrite (fp_5, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_5);
   end
   ////////////////////////////fp_6////////////////////////////
   wait(AP_mode == 4'b0110);
   if(AP_en && AP_mode == 4'b0110)
   begin
      fp_6 = $fopen ("../image_out/mode_6.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_6.bmp");

      // BMP Header
      $fwrite (fp_6, "%s", "BM");                 // MB header
      $fwrite (fp_6, "%u", img_size+header_size); // File size
      $fwrite (fp_6, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_6, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_6, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_6, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_6, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_6, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_6, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_6, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_6, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_6, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_6, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_6, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_6, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_6, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_6, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_6, "%c", DPi[7:0]);
            else $fwrite (fp_6, "%c", 8'b0);
            if (g_channel) $fwrite (fp_6, "%c", DPi[15:8]);
            else $fwrite (fp_6, "%c", 8'b0);
            if (r_channel) $fwrite (fp_6, "%c", DPi[23:16]);
            else $fwrite (fp_6, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_6);
   end
   ////////////////////////////fp_7////////////////////////////
   wait(AP_mode == 4'b0111);
   if(AP_en && AP_mode == 4'b0111)
   begin
      fp_7 = $fopen ("../image_out/mode_7.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_7.bmp");

      // BMP Header
      $fwrite (fp_7, "%s", "BM");                 // MB header
      $fwrite (fp_7, "%u", img_size+header_size); // File size
      $fwrite (fp_7, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_7, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_7, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_7, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_7, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_7, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_7, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_7, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_7, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_7, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_7, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_7, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_7, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_7, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_7, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_7, "%c", DPi[7:0]);
            else $fwrite (fp_7, "%c", 8'b0);
            if (g_channel) $fwrite (fp_7, "%c", DPi[15:8]);
            else $fwrite (fp_7, "%c", 8'b0);
            if (r_channel) $fwrite (fp_7, "%c", DPi[23:16]);
            else $fwrite (fp_7, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_7);
   end
   ////////////////////////////fp_8////////////////////////////
   wait(AP_mode == 4'b1000);
   if(AP_en && AP_mode == 4'b1000)
   begin
      fp_8 = $fopen ("../image_out/mode_8.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_8.bmp");

      // BMP Header
      $fwrite (fp_8, "%s", "BM");                 // MB header
      $fwrite (fp_8, "%u", img_size+header_size); // File size
      $fwrite (fp_8, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_8, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_8, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_8, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_8, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_8, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_8, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_8, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_8, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_8, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_8, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_8, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_8, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_8, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_8, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_8, "%c", DPi[7:0]);
            else $fwrite (fp_8, "%c", 8'b0);
            if (g_channel) $fwrite (fp_8, "%c", DPi[15:8]);
            else $fwrite (fp_8, "%c", 8'b0);
            if (r_channel) $fwrite (fp_8, "%c", DPi[23:16]);
            else $fwrite (fp_8, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_8);
   end
   ////////////////////////////fp_9////////////////////////////
   wait(AP_mode == 4'b1001);
   if(AP_en && AP_mode == 4'b1001)
   begin
      fp_9 = $fopen ("../image_out/mode_9.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_9.bmp");

      // BMP Header
      $fwrite (fp_9, "%s", "BM");                 // MB header
      $fwrite (fp_9, "%u", img_size+header_size); // File size
      $fwrite (fp_9, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_9, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_9, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_9, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_9, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_9, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_9, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_9, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_9, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_9, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_9, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_9, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_9, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_9, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_9, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_9, "%c", DPi[7:0]);
            else $fwrite (fp_9, "%c", 8'b0);
            if (g_channel) $fwrite (fp_9, "%c", DPi[15:8]);
            else $fwrite (fp_9, "%c", 8'b0);
            if (r_channel) $fwrite (fp_9, "%c", DPi[23:16]);
            else $fwrite (fp_9, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_9);
   end
   ////////////////////////////fp_10////////////////////////////
   wait(AP_mode == 4'b1010);
   if(AP_en && AP_mode == 4'b1010)
   begin
      fp_10 = $fopen ("../image_out/mode_10.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_10.bmp");

      // BMP Header
      $fwrite (fp_10, "%s", "BM");                 // MB header
      $fwrite (fp_10, "%u", img_size+header_size); // File size
      $fwrite (fp_10, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_10, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_10, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_10, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_10, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_10, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_10, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_10, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_10, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_10, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_10, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_10, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_10, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_10, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_10, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_10, "%c", DPi[7:0]);
            else $fwrite (fp_10, "%c", 8'b0);
            if (g_channel) $fwrite (fp_10, "%c", DPi[15:8]);
            else $fwrite (fp_10, "%c", 8'b0);
            if (r_channel) $fwrite (fp_10, "%c", DPi[23:16]);
            else $fwrite (fp_10, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_10);
   end
   ////////////////////////////fp_11////////////////////////////
   wait(AP_mode == 4'b1011);
   if(AP_en && AP_mode == 4'b1011)
   begin
      fp_11 = $fopen ("../image_out/mode_11.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_11.bmp");

      // BMP Header
      $fwrite (fp_11, "%s", "BM");                 // MB header
      $fwrite (fp_11, "%u", img_size+header_size); // File size
      $fwrite (fp_11, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_11, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_11, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_11, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_11, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_11, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_11, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_11, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_11, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_11, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_11, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_11, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_11, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_11, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_11, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_11, "%c", DPi[7:0]);
            else $fwrite (fp_11, "%c", 8'b0);
            if (g_channel) $fwrite (fp_11, "%c", DPi[15:8]);
            else $fwrite (fp_11, "%c", 8'b0);
            if (r_channel) $fwrite (fp_11, "%c", DPi[23:16]);
            else $fwrite (fp_11, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_11);
   end
   ////////////////////////////fp_12////////////////////////////
   wait(AP_mode == 4'b1100);
   if(AP_en && AP_mode == 4'b1100)
   begin
      fp_12 = $fopen ("../image_out/mode_12.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_12.bmp");

      // BMP Header
      $fwrite (fp_12, "%s", "BM");                 // MB header
      $fwrite (fp_12, "%u", img_size+header_size); // File size
      $fwrite (fp_12, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_12, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_12, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_12, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_12, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_12, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_12, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_12, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_12, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_12, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_12, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_12, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_12, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_12, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_12, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_12, "%c", DPi[7:0]);
            else $fwrite (fp_12, "%c", 8'b0);
            if (g_channel) $fwrite (fp_12, "%c", DPi[15:8]);
            else $fwrite (fp_12, "%c", 8'b0);
            if (r_channel) $fwrite (fp_12, "%c", DPi[23:16]);
            else $fwrite (fp_12, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_12);
   end
   ////////////////////////////fp_13////////////////////////////
   wait(AP_mode == 4'b1101);
   if(AP_en && AP_mode == 4'b1101)
   begin
      fp_13 = $fopen ("../image_out/mode_13.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_13.bmp");

      // BMP Header
      $fwrite (fp_13, "%s", "BM");                 // MB header
      $fwrite (fp_13, "%u", img_size+header_size); // File size
      $fwrite (fp_13, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_13, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_13, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_13, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_13, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_13, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_13, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_13, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_13, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_13, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_13, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_13, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_13, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_13, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_13, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_13, "%c", DPi[7:0]);
            else $fwrite (fp_13, "%c", 8'b0);
            if (g_channel) $fwrite (fp_13, "%c", DPi[15:8]);
            else $fwrite (fp_13, "%c", 8'b0);
            if (r_channel) $fwrite (fp_13, "%c", DPi[23:16]);
            else $fwrite (fp_13, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_13);
   end
   ////////////////////////////fp_14////////////////////////////
   wait(AP_mode == 4'b1110);
   if(AP_en && AP_mode == 4'b1110)
   begin
      fp_14 = $fopen ("../image_out/mode_14.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_14.bmp");

      // BMP Header
      $fwrite (fp_14, "%s", "BM");                 // MB header
      $fwrite (fp_14, "%u", img_size+header_size); // File size
      $fwrite (fp_14, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_14, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_14, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_14, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_14, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_14, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_14, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_14, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_14, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_14, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_14, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_14, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_14, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_14, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_14, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_14, "%c", DPi[7:0]);
            else $fwrite (fp_14, "%c", 8'b0);
            if (g_channel) $fwrite (fp_14, "%c", DPi[15:8]);
            else $fwrite (fp_14, "%c", 8'b0);
            if (r_channel) $fwrite (fp_14, "%c", DPi[23:16]);
            else $fwrite (fp_14, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_14);
   end
   ////////////////////////////fp_15////////////////////////////
   wait(AP_mode == 4'b1111);
   if(AP_en && AP_mode == 4'b1111)
   begin
      fp_15 = $fopen ("../image_out/mode_15.bmp", "wb");
      $display ("File %s opened for writing", "../image_out/mode_15.bmp");

      // BMP Header
      $fwrite (fp_15, "%s", "BM");                 // MB header
      $fwrite (fp_15, "%u", img_size+header_size); // File size
      $fwrite (fp_15, "%u", "");                   // Reserved 1 and 2 (4 bytes in total)
      $fwrite (fp_15, "%u", header_size);          // Starting address of the bitmap image
      $fwrite (fp_15, "%u", DIB_header_size);      // DIB header size
      $fwrite (fp_15, "%u", Hsize);                // The bitmap width in pixels (4 bytes signed integer)
      $fwrite (fp_15, "%u", Vsize);                // The bitmap height in pixels (4 bytes signed integer)
      $fwrite (fp_15, "%c", 8'h01);                // The number of color planes must be 1 (2 bytes in total)
      $fwrite (fp_15, "%c", 8'h00);                // 16'h00_01 in little endian => 16'h01_00
      $fwrite (fp_15, "%c", 8'h18);                // The number of bits per pixel, which is the color depth of the image. (2 bytes in total)
      $fwrite (fp_15, "%c", 8'h00);                // 16'h00_18 in little endian => 4'h18_00 
      $fwrite (fp_15, "%u", "");                   // Compression method being used (4 bytes in total)
      $fwrite (fp_15, "%u", img_size);             // The image size. (size of the raw bitmap data)
      $fwrite (fp_15, "%u", 32'd3780);             // The horizontal resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_15, "%u", 32'd3780);             // The vertical resolution of the image. (pixel per meter, signed integer) => 96 dpi = 3780 ppm
      $fwrite (fp_15, "%u", "");                   // The number of colors in the color palette, or 0 to default
      $fwrite (fp_15, "%u", "");                   // The number of important colors used, or 0 when every color is important; generally ignored

      count = 0;

      for (y=0;y<Vsize;y=y+1) begin
         @(posedge DPi[24]); // wait for data enable
         x = 0;
         for (x=0;x<Hsize;x=x+1) begin
            @(posedge clk); // wait for clk edge
            if (b_channel) $fwrite (fp_15, "%c", DPi[7:0]);
            else $fwrite (fp_15, "%c", 8'b0);
            if (g_channel) $fwrite (fp_15, "%c", DPi[15:8]);
            else $fwrite (fp_15, "%c", 8'b0);
            if (r_channel) $fwrite (fp_15, "%c", DPi[23:16]);
            else $fwrite (fp_15, "%c", 8'b0);
            count = count + 1;
         end
      end
      $fclose (fp_15);
   end
end

endmodule
