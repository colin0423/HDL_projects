
`include "../src/MEM1024X24.v"

module NR(
    input clk,
    input rst_n,
    input [26:0] DPi,
    input A_M,
    output reg [23:0] DPo
);

parameter divide_nine = 12'h072;//Q2,10
parameter h_size = 12'd640;
parameter v_size = 11'd480;

parameter IDLE = 3'b000;
parameter LOAD = 3'b001;
parameter AVG = 3'b010;// REG ADDR
parameter MED = 3'b011;
// parameter PAD = 3'b100;
// parameter STOP = 3'b101;//FOR READ TO WAIT STOP

reg WEB_A,WEB_B;
reg [23:0]DOUT_A,DOUT_B;

reg [2:0] state,n_state;
reg current_SRAM;
reg [11:0] h_cnt;
reg [10:0] v_cnt;
reg [23:0] pattern [0:8];

reg [19:0] avg_R,avg_G,avg_B;
reg [7:0] sorted_R [0:8];
reg [7:0] sorted_G [0:8];
reg [7:0] sorted_B [0:8];
reg [7:0] temp_R,temp_G,temp_B;
reg [23:0] Din_buff;
reg start;
reg [9:0] sync_ctr;

integer i,j;
wire [11:0] sum_R = pattern[0][23:16] + pattern[1][23:16] + pattern[2][23:16] + pattern[3][23:16] +
                    pattern[4][23:16] + pattern[5][23:16] + pattern[6][23:16] + pattern[7][23:16] + pattern[8][23:16];
wire [11:0] sum_G = pattern[0][15:8] + pattern[1][15:8] + pattern[2][15:8] + pattern[3][15:8] +
                    pattern[4][15:8] + pattern[5][15:8] + pattern[6][15:8] + pattern[7][15:8] + pattern[8][15:8];
wire [11:0] sum_B = pattern[0][7:0] + pattern[1][7:0] + pattern[2][7:0] + pattern[3][7:0] +
                    pattern[4][7:0] + pattern[5][7:0] + pattern[6][7:0] + pattern[7][7:0] + pattern[8][7:0];
wire D_en = DPi[24];
wire [23:0]DIN = DPi[23:0];
wire last_row = (sync_ctr==126);


MEM1024X24 SRAM_A(
    .CK(clk),
    .CS(1'b1),
    .WEB(WEB_A),
    .RE(1'b1),
    .R_ADDR(h_cnt),
    .W_ADDR(h_cnt),
    .D_IN(DIN),
    .D_OUT(DOUT_A)
);
MEM1024X24 SRAM_B(
    .CK(clk),
    .CS(1'b1),
    .WEB(WEB_B),
    .RE(1'b1),
    .R_ADDR(h_cnt),
    .W_ADDR(h_cnt),
    .D_IN(DIN),
    .D_OUT(DOUT_B)
);



always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        h_cnt <= 0;
        v_cnt <= 0;
        current_SRAM <= 0;
        start <= 0;
        sync_ctr <= 0;
    end
    else begin
        state <= n_state;
        Din_buff <= DPi[23:0];

        if(v_cnt == v_size && sync_ctr<126) sync_ctr <= sync_ctr + 1;//last row no Den
        else if (state == IDLE) sync_ctr <= 0;
        else sync_ctr <= sync_ctr;

        if(state == IDLE) begin
            h_cnt <= 0;
            v_cnt <= 0;
            current_SRAM <= 0;
        end else begin
            if(D_en ||last_row) begin
                h_cnt <= h_cnt + 1;
            end
            else if(h_cnt >= h_size)begin
                if (h_cnt == h_size + 1) begin
                    h_cnt <= 0;
                    v_cnt <= v_cnt + 1;
                    current_SRAM <= ~current_SRAM;
                end
                else h_cnt <= h_cnt + 1;
            end
            else begin
                h_cnt <= h_cnt;
            end 
        end
        
        if(D_en||last_row)begin
            // pattern input 
            if(v_cnt == 1)begin//top
                pattern[0] <= 0;
                pattern[1] <= 0;
                pattern[2] <= 0;
                if(h_cnt == 2)begin
                    pattern[3] <= 0;
                    pattern[6] <= 0;
                    pattern[5] <= DOUT_A;
                    pattern[8] <= Din_buff;
                end else if (h_cnt == h_size+1)begin
                    pattern[3] <= pattern[4];
                    pattern[6] <= pattern[7];
                    pattern[5] <= 0;
                    pattern[8] <= 0;
                end else begin
                    pattern[3] <= pattern[4];
                    pattern[6] <= pattern[7];
                    pattern[5] <= DOUT_A;
                    pattern[8] <= Din_buff;
                end
                pattern[4] <= pattern[5];
                pattern[7] <= pattern[8];
                
            end else if (v_cnt == v_size)begin//bot
                pattern[6] <= 0;
                pattern[7] <= 0;
                pattern[8] <= 0;
                if(h_cnt == 2)begin 
                    pattern[0] <= 0;
                    pattern[3] <= 0;
                    pattern[2] <= (current_SRAM)? DOUT_B :DOUT_A;
                    pattern[5] <= (current_SRAM)? DOUT_A :DOUT_B;
                end else if(h_cnt == h_size+1)begin
                    pattern[0] <= pattern[1];
                    pattern[3] <= pattern[4];
                    pattern[2] <= 0;
                    pattern[5] <= 0;
                end else begin
                    pattern[0] <= pattern[1];
                    pattern[3] <= pattern[4];
                    pattern[2] <= (current_SRAM)? DOUT_B :DOUT_A;
                    pattern[5] <= (current_SRAM)? DOUT_A :DOUT_B;
                end
                pattern[1] <= pattern[2];
                pattern[4] <= pattern[5];
            end else begin
                if(h_cnt == 2)begin //cal 639
                    pattern[0] <= 0;
                    pattern[3] <= 0;
                    pattern[6] <= 0;
                    pattern[2] <= (current_SRAM)? DOUT_B :DOUT_A;
                    pattern[5] <= (current_SRAM)? DOUT_A :DOUT_B;
                    pattern[8] <= Din_buff;
                end else if(h_cnt == h_size+1)begin
                    pattern[0] <= pattern[1];
                    pattern[3] <= pattern[4];
                    pattern[6] <= pattern[7];
                    pattern[2] <= 0;
                    pattern[5] <= 0;
                    pattern[8] <= 0;
                end else begin
                    pattern[0] <= pattern[1];
                    pattern[3] <= pattern[4];
                    pattern[6] <= pattern[7];
                    pattern[2] <= (current_SRAM)? DOUT_B :DOUT_A;
                    pattern[5] <= (current_SRAM)? DOUT_A :DOUT_B;
                    pattern[8] <= Din_buff;
                end
                pattern[1] <= pattern[2];
                pattern[4] <= pattern[5];
                pattern[7] <= pattern[8];
            end
        end
        
    end
end

always @(*) begin
    case (state)
        IDLE:begin
            if(!rst_n)begin
                n_state = IDLE;
            end
            else begin
                n_state = LOAD; 
            end
            WEB_A = 0;
            WEB_B = 0;
        end
        LOAD:begin
            WEB_A = 1;
            WEB_B = 0;
            if(D_en)begin
                if(h_cnt == h_size -1) n_state = (A_M)? MED:AVG;
                else n_state = LOAD;
            end
            else begin 
                n_state = LOAD;
            end
        end

        AVG:begin
            //read & write
            WEB_A = ~current_SRAM;
            WEB_B = current_SRAM;
            //cal
            avg_R = sum_R * divide_nine ;
            avg_G = sum_G * divide_nine ;
            avg_B = sum_B * divide_nine ;
            DPo = {avg_R[17:10],avg_G[17:10],avg_B[17:10]} ;
            if(A_M) n_state = IDLE;
            else n_state = AVG;
        end
        MED:begin
            //read & write
            WEB_A = ~current_SRAM;
            WEB_B = current_SRAM;
            //cal
            for (i = 0; i < 9; i = i + 1)begin
                sorted_R[i] = pattern[i][23:16];
                sorted_G[i] = pattern[i][15:8];
                sorted_B[i] = pattern[i][7:0];
            end
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 8 - i; j = j + 1) begin
                    if (sorted_R[j] > sorted_R[j+1]) begin
                        temp_R = sorted_R[j];
                        sorted_R[j] = sorted_R[j+1];
                        sorted_R[j+1] = temp_R;
                    end
                    if (sorted_G[j] > sorted_G[j+1]) begin
                        temp_G = sorted_G[j];
                        sorted_G[j] = sorted_G[j+1];
                        sorted_G[j+1] = temp_G;
                    end
                    if (sorted_B[j] > sorted_B[j+1]) begin
                        temp_B = sorted_B[j];
                        sorted_B[j] = sorted_B[j+1];
                        sorted_B[j+1] = temp_B;
                    end
                end
            end
            DPo = {sorted_R[4],sorted_G[4],sorted_B[4]} ;
            if(A_M) n_state = MED;
            else n_state = IDLE;
        end
        default: begin
            WEB_A = 0;
            WEB_B = 0;
            n_state = IDLE;
        end
    endcase
end
endmodule