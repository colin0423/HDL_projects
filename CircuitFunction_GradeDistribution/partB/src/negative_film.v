module negative_film(
    input clk,
    input rst,
    input [23:0] pixel_in,
    output reg [23:0] pixel_out,
    output reg valid
);
    wire [17:0] ctr_num = 65536;
    reg [1:0] state, n_state;
    reg [23:0] Din_buff;
    reg [17:0] ctr;

    wire [7:0] neg_R = 255 - Din_buff[23:16];
    wire [7:0] neg_G = 255 - Din_buff[15:8];
    wire [7:0] neg_B = 255 - Din_buff[7:0];

    always @(posedge clk) begin
        if(rst)begin
            ctr <= 0;
            state <= 0;
            valid <= 0;
        end
        else begin
            state <= n_state;
            Din_buff <= pixel_in;
            if(state != n_state) ctr <= 0;
            else ctr <= ctr +1; 
        end
    end
    always @(*) begin
        case (state)
            2'b00:begin
                if (!rst) begin
                    n_state = 2'b01; 
                end
                else begin
                    n_state = 2'b00;
                end
            end 
            2'b01:begin
                if (ctr == ctr_num) begin
                    n_state = 2'b00;
                    valid = 0;
                end
                else begin
                    valid = 1;
                    pixel_out = {neg_R,neg_G,neg_B}; 
                    n_state = 2'b01;
                end
            end
            default: valid = 0;
        endcase
    end
endmodule