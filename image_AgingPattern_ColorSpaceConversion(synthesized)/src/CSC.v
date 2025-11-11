`timescale 1ns/10ps
module CSC(
    input clk,
    input rst_n,
    input [1:0] Mode,
    input [26:0] DPi,
    output reg[26:0] DPo
);

parameter IDLE = 3'b000;
parameter R2Y = 3'b001;
parameter Y2R = 3'b010;// REG ADDR
parameter R2Y2R = 3'b011;

parameter PY_a = 11'h04d;//0.299 Q2,10 or 4d
parameter PY_b = 11'h096;//0.587 Q2,10
parameter PY_c = 11'h01d;//0.114 Q2,10
parameter PU_a = 11'h02b;//0.169 Q2,10
parameter PU_b = 11'h055;//0.331 Q2,10
parameter PU_c = 11'h080;//0.5 Q2,10
parameter PV_b = 11'h06b;//0.419 Q2,10
parameter PV_c = 11'h015;//0.081 Q2,10
parameter offset = 20'h8000;

parameter PR_a = 11'h124;//1.13983 Q2,10
parameter PG_a = 11'h065;//0.39465 Q2,10
parameter PG_b = 11'h095;//0.58060 Q2,10
parameter PB_a = 11'h208;//2.03211 Q2,10


reg [2:0] state,n_state;
reg [7:0] buf_A,buf_B,buf_C;
reg signed [19:0] data_A,data_B,data_C;

wire D_ena = DPi[24];
wire signed[19:0]in_a = {12'h000,DPi[23:16]};
wire signed[19:0]in_b = {12'h000,DPi[15:8]};
wire signed[19:0]in_c = {12'h000,DPi[7:0]};
reg [23:0] YUV,RGB;
always @(posedge clk) begin
    if (!rst_n) begin
        state <= 0;
    end else begin
        state <= n_state;
    end
end

always @(*) begin
    case (state)
        IDLE:begin
           if (!rst_n) begin
                n_state = IDLE;
            end else begin
                case (Mode)
                    2'b00: n_state = R2Y;
                    2'b01: n_state = Y2R;
                    2'b10: n_state = R2Y2R;
                    default: n_state = IDLE;
                endcase
            end 
            DPo = DPi;
        end 
        R2Y:begin
            if(D_ena) begin
                YUV = R2Y_result(in_a,in_b,in_c);
                DPo = {DPi[26:24],YUV};
            end
            else begin 
                DPo = DPi;
            end
            n_state = R2Y;
        end 
        Y2R:begin
            if(D_ena) begin
                RGB = Y2R_result(in_a,in_b,in_c);
                DPo = {DPi[26:24],RGB};
            end
            else begin 
                DPo = DPi;
            end
            n_state = Y2R;
        end 
        R2Y2R:begin
            if(D_ena) begin
                YUV = R2Y_result(in_a,in_b,in_c);
                RGB = Y2R_result({12'h000,YUV[23:16]},{12'h000,YUV[15:8]},{12'h000,YUV[7:0]});
                DPo = {DPi[26:24],RGB};
            end
            else begin 
                DPo = DPi;
            end
            n_state = R2Y2R;
        end
        default: begin
            n_state = IDLE; 
            DPo = DPi;
        end
    endcase
end

function  [23:0]R2Y_result;
    input [19:0]in_a,in_b,in_c;
    reg signed [19:0] data_A,data_B,data_C;
    reg [7:0] buf_A,buf_B,buf_C;
    begin
        data_A = PY_a*in_a + PY_b*in_b + PY_c*in_c; 
        data_B = -PU_a*in_a - PU_b*in_b + PU_c*in_c + offset; 
        data_C = PU_c*in_a - PV_b*in_b - PV_c*in_c + offset;
        buf_A = (!data_A[19]) ? (data_A[19:8] >= 255) ? 255 : (data_A[7] ? data_A[15:8]+1 : data_A[15:8]) : 0;
        buf_B = (!data_B[19]) ? (data_B[19:8] >= 255) ? 255 : (data_B[7] ? data_B[15:8]+1 : data_B[15:8]) : 0;
        buf_C = (!data_C[19]) ? (data_C[19:8] >= 255) ? 255 : (data_C[7] ? data_C[15:8]+1 : data_C[15:8]) : 0;
        R2Y_result = {buf_A,buf_B,buf_C};
    end
endfunction

function  [23:0]Y2R_result;
    input [19:0]in_a,in_b,in_c;
    reg signed [19:0] data_A,data_B,data_C;
    reg [7:0] buf_A,buf_B,buf_C;
    begin
        data_A = (in_a<<8) + PR_a*(in_c - 128); 
        data_B = (in_a<<8) -PG_a*(in_b - 128) - PG_b*(in_c -128); 
        data_C = (in_a<<8) + PB_a*(in_b - 128); 
        buf_A = (!data_A[19]) ? (data_A[19:8] >= 255) ? 255 : (data_A[7] ? data_A[15:8]+1 : data_A[15:8]) : 0;
        buf_B = (!data_B[19]) ? (data_B[19:8] >= 255) ? 255 : (data_B[7] ? data_B[15:8]+1 : data_B[15:8]) : 0;
        buf_C = (!data_C[19]) ? (data_C[19:8] >= 255) ? 255 : (data_C[7] ? data_C[15:8]+1 : data_C[15:8]) : 0;
        Y2R_result = {buf_A,buf_B,buf_C};
    end
endfunction
endmodule

