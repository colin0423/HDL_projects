`include "negative_film.v"

module negative_film_tb;

logic clk, rst;
logic [23:0] pixel_in, pixel_out;

logic valid;

logic [23:0] img [0:65535];
logic [23:0] golden [0:65535];

logic [23:0] golden_temp;

integer img_idx, golden_idx, err;

string path;

negative_film negative_film(
    .clk(clk),
    .rst(rst),
    .pixel_in(pixel_in),
    .pixel_out(pixel_out),
    .valid(valid)
);

always #5 clk = ~clk;

assign golden_temp = golden[golden_idx];

initial begin
    $value$plusargs("path=%s", path);
    $readmemh({path, "/butterfly.txt"}, img);
    $readmemh({path, "/golden.txt"}, golden);
end

initial begin
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars(0, "+mda");
end

initial begin
    clk = 0; rst = 1;
    img_idx = 0; golden_idx = 0;
    err = 0;

    #18
    rst = 0;

    while(img_idx < 65536) begin
        @(negedge clk) begin
            img_idx++;
        end
    end

    #1000000
    $display("--------------------------------------------------");
    $display("-- Failed waiting valid signal, Simulation STOP --");
    $display("--------------------------------------------------");
    $finish;
end

assign pixel_in = img[img_idx-1];

initial begin
    while(golden_idx < 65536) begin
        @(negedge clk) begin
            if(valid) begin
                if(golden[golden_idx] == pixel_out) begin
                    $display("Pixel %5d, Pass", golden_idx);
                    golden_idx++;
                end
                else begin
                    $display("Pixel %5d, Fail. Your anwser is %4h, expect = %4h", golden_idx, pixel_out, golden[golden_idx]);
                    err++;
                    golden_idx++;
                end
            end
        end
    end

    if(err) begin
        $display("--------------------------------------------------");
        $display("        %-s", " Simulation Fail !!! ");
        $display("--------------------------------------------------");
    end
    else begin
        $display("--------------------------------------------------");
        $display("        %-s", " Simulation Pass !!! ");
        $display("--------------------------------------------------");
    end

    $finish;
end

endmodule