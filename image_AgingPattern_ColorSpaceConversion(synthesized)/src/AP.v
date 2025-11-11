`timescale 1ns/10ps
module AP(
    input clk,
    input rst_n,
    input [11:0] Tp_H,
    input [10:0] Tp_V,
    input enable,
    input [3:0] Mode,
    input [26:0] DPi,
    output reg [26:0] DPo
);
parameter IDLE = 3'b000;
parameter PASS = 3'b001;
parameter TEST = 3'b010;// REG ADDR
// parameter WRITE = 3'b011;
// parameter READ = 3'b100;
// parameter STOP = 3'b101;//FOR READ TO WAIT STOP

reg [2:0] state,n_state;
reg [11:0] h_ctr;
reg [10:0] Tp_V, v_ctr;
reg [7:0] data_R,data_G,data_B;
reg [3:0] color_region;
reg [7:0] grid_width;
reg finish;

wire D_ena = DPi[24];
wire [11:0] h_end = Tp_H - 1;
wire [10:0] v_end = Tp_V - 1;
wire [7:0] width_eighth = Tp_H/8;
wire [7:0] width_sixteenth = Tp_H/16;
wire grid_h = (h_ctr / grid_width)%2;
wire grid_v = (v_ctr / grid_width)%2;
wire grid_black = grid_h ^ grid_v;
wire next_pattern;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 0;
        h_ctr <= 0;
        v_ctr <= 0;
        finish <= 0;
    end else begin
        state <= n_state;
        // case (finish)
        //     2'b00:begin //vsyn == 0 jump
        //         if (DPi[26] == 0) finish <= 2'b01;
        //         else finish <= 2'b00;
        //     end
        //     2'b01:begin//vsyn == 1 jump
        //         if (DPi[26] == 1) finish <= 2'b10;
        //         else finish <= 2'b01;
        //     end
        //     2'b10: begin//represent finish
        //         if (state == IDLE) finish <= 2'b00;
        //         else finish <= 2'b10;
        //     end
        //     default: finish <= 0;
        // endcase
        if(D_ena) begin
            if(h_ctr == h_end)begin
                h_ctr <= 0;
                if (v_ctr == v_end) begin 
                    v_ctr <= 0;
                    finish <= 1;
                end
                else begin 
                    v_ctr <= v_ctr+1;
                    finish <= 0;
                end
            end
            else h_ctr <= h_ctr +1;
        end
        else begin
            h_ctr <= h_ctr;
            v_ctr <= v_ctr;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (!rst_n) begin
                n_state = IDLE;
            end else begin
                n_state = (enable)?TEST:PASS;     
            end
            DPo = DPi;
            grid_width = 1;
        end 
        PASS: begin
            DPo = DPi;
            grid_width = 1;
            if(finish) n_state = IDLE;
            else n_state = PASS;
        end
        TEST: begin
            if (D_ena) begin
                case (Mode)
                    4'd00: begin 
                        grid_width = 1;
                        data_R = h_ctr /5 *2;
                        data_G = h_ctr /5 *2;
                        data_B = h_ctr /5 *2;
                    end
                    4'd01: begin 
                        grid_width = 1;
                        color_region = h_ctr / width_eighth;
                        case (color_region)
                            4'd00:begin
                                data_R = 255;
                                data_G = 255;
                                data_B = 255;
                            end 
                            4'd01:begin
                                data_R = 0;
                                data_G = 255;
                                data_B = 255;
                            end
                            4'd02:begin
                                data_R = 255;
                                data_G = 255;
                                data_B = 0;
                            end
                            4'd03:begin
                                data_R = 0;
                                data_G = 255;
                                data_B = 0;
                            end
                            4'd04:begin
                                data_R = 255;
                                data_G = 0;
                                data_B = 255;
                            end
                            4'd05:begin
                                data_R = 0;
                                data_G = 0;
                                data_B = 255;
                            end
                            4'd06:begin
                                data_R = 255;
                                data_G = 0;
                                data_B = 0;
                            end
                            4'd07:begin
                                data_R = 0;
                                data_G = 0;
                                data_B = 0;
                            end
                            default: begin
                                data_R = 0;
                                data_G = 0;
                                data_B = 0;
                            end
                        endcase
                    end 
                    4'd02: begin 
                        grid_width = 1;
                        data_R = 0;
                        data_G = 0;
                        data_B = 0;
                    end
                    4'd03: begin 
                        grid_width = 1;
                        data_R = 255;
                        data_G = 0;
                        data_B = 0;
                    end
                    4'd04: begin 
                        grid_width = 1;
                        data_R = 0;
                        data_G = 255;
                        data_B = 0;
                    end
                    4'd05: begin 
                        grid_width = 1;
                        data_R = 0;
                        data_G = 0;
                        data_B = 255;
                    end
                    4'd06: begin 
                        grid_width = 1;
                        data_R = 255;
                        data_G = 255;
                        data_B = 255;
                    end
                    4'd07: begin 
                        grid_width = 40;
                        if(grid_black) begin
                            data_R = 0;
                            data_G = 0;
                            data_B = 0;
                        end else begin
                            data_R = 255;
                            data_G = 255;
                            data_B = 255;
                        end
                    end
                    4'd08: begin 
                        grid_width = 1;
                        data_R = h_ctr /width_sixteenth *17;
                        data_G = h_ctr /width_sixteenth *17;
                        data_B = h_ctr /width_sixteenth *17;
                    end
                    4'd09: begin 
                        grid_width = 1;
                        data_R = h_ctr /width_sixteenth *17;
                        data_G = 0;
                        data_B = 0;
                    end
                    4'd10: begin 
                        grid_width = 1;
                        data_R = 0;
                        data_G = h_ctr /width_sixteenth *17;
                        data_B = 0;
                    end
                    4'd11: begin 
                        grid_width = 1;
                        data_R = 0;
                        data_G = 0;
                        data_B = h_ctr /width_sixteenth *17;
                    end
                    4'd12: begin 
                        grid_width = 1;
                        if(grid_h) begin
                            data_R = 0;
                            data_G = 0;
                            data_B = 0;
                        end else begin
                            data_R = 255;
                            data_G = 255;
                            data_B = 255;
                        end
                    end
                    4'd13: begin 
                        grid_width = 2;
                        if(grid_h) begin
                            data_R = 0;
                            data_G = 0;
                            data_B = 0;
                        end else begin
                            data_R = 255;
                            data_G = 255;
                            data_B = 255;
                        end
                    end
                    4'd14: begin 
                        grid_width = 4;
                        if(grid_h) begin
                            data_R = 0;
                            data_G = 0;
                            data_B = 0;
                        end else begin
                            data_R = 255;
                            data_G = 255;
                            data_B = 255;
                        end
                    end
                    4'd15: begin 
                        grid_width = 1;
                        if(grid_black) begin
                            data_R = 0;
                            data_G = 0;
                            data_B = 0;
                        end else begin
                            data_R = 255;
                            data_G = 255;
                            data_B = 255;
                        end
                    end
                    default:begin
                        grid_width = 1;
                        data_R = DPi[23:16];
                        data_G = DPi[15:8];
                        data_B = DPi[7:0];    
                    end
                endcase
                DPo = {DPi[26:24],data_R,data_G,data_B};
            end
            else begin 
                DPo = DPi;
                grid_width = 1;
            end
            if(finish) n_state = IDLE;
            else n_state = TEST;
        end
        default:begin
            n_state = IDLE;
            DPo = DPi;
            grid_width = 1;
        end 
    endcase
end

endmodule