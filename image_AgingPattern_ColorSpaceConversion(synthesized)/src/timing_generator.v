`timescale 1ns/10ps
module timing_generator(     
    input             clk,
    input             rst_n,                
    input  [11:0]     h_total,
    input  [11:0]     h_size,
    input  [10:0]     h_sync,
    input  [10:0]     h_start,
    input  [10:0]     v_total,
    input  [10:0]     v_size,
    input  [ 9:0]     v_sync,
    input  [ 9:0]     v_start,
    input  [22:0]     vs_reset, 
    output reg[26:24]    Synco
);

reg [11:0] h_cnt;
reg [10:0] v_cnt;

reg hsync, vsync, de;
//reg [22:0] reset_counter;
reg video_rst;

always @(posedge clk) begin//rst control
    if (!rst_n) begin
        //reset_counter <= 23'd0;
        video_rst <= 1'b1;
    // end else if (reset_counter == vs_reset) begin
    //     video_rst <= 1'b1;
    end 
    else begin
        video_rst <= 1'b0;
        // reset_counter <= reset_counter + 1;
    end
end

always @(posedge clk) begin
    if (video_rst) begin
        h_cnt <= 0;
        v_cnt <= 0;
        Synco <= 3'b000;
    end else begin
        if (h_cnt == h_total - 1) begin
            h_cnt <= 0;
            if (v_cnt == v_total - 1)
                v_cnt <= 0;
            else
                v_cnt <= v_cnt + 1;
        end else begin
            h_cnt <= h_cnt + 1;
        end
        Synco <= {vsync,hsync,de};
    end
end

always @(*) begin
    // HSYNC active (assume low)
    hsync = (h_cnt < h_sync) ? 1'b1 : 1'b0;
    // VSYNC active (assume low)
    vsync = (v_cnt < v_sync) ? 1'b1 : 1'b0;
    // Display Enable
    de = ((h_cnt >= h_start) && (h_cnt < h_start + h_size) && (v_cnt >= v_start) && (v_cnt < v_start + v_size));    
end
endmodule
