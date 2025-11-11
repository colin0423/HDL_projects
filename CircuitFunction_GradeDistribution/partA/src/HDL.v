module HDL(
    input clk,
    input rst,
    input [1:0] Din,
    input in_valid,
    output reg ready,
    output reg [1:0] Max,
    output reg out_valid,
    output reg out_valid_SecondStage,
    output [7:0] Center_of_MassX,
    output [7:0] Center_of_MassY,
    output reg [8:0] LongestSide,
    output reg [1:0] TriangleType,
    output reg [1:0] ForthPoint
);

    parameter IDLE = 3'b000;
    parameter IN = 3'b001;
    parameter OUTF = 3'b010;
    parameter CAL = 3'b011;
    parameter DET = 3'b100;
    parameter OUTS = 3'b101;

    reg [2:0] state,next_state;
    reg [1:0] array_ctr,next_arrayctr,Din_buff;
    reg [3:0] ctr,next_ctr;
    reg [7:0] X,Y;
    reg [7:0] X_array [0:3];
    reg [7:0] Y_array [0:3];
    reg in_valid_buff,online,sign_ref,mismatch;

    wire [17:0] abs_A = (X_array[0] - X_array[1])*(X_array[0] - X_array[1]) + (Y_array[0] - Y_array[1])*(Y_array[0] - Y_array[1]);
    wire [17:0] abs_B = (X_array[0] - X_array[2])*(X_array[0] - X_array[2]) + (Y_array[0] - Y_array[2])*(Y_array[0] - Y_array[2]);
    wire [17:0] abs_C = (X_array[2] - X_array[1])*(X_array[2] - X_array[1]) + (Y_array[2] - Y_array[1])*(Y_array[2] - Y_array[1]);
    reg [17:0] abs_Longest,two_short,length_det;
    reg [8:0] length,next_length;

    reg signed [9:0] dx1, dy1, dx2, dy2;
    reg signed [19:0] cross_data ;

    wire [17:0] abs_length = length*length;
    assign Center_of_MassX = (X_array[0]+X_array[1]+X_array[2])/3;
    assign Center_of_MassY = (Y_array[0]+Y_array[1]+Y_array[2])/3;

    always @(posedge clk) begin
        if(rst)begin
            array_ctr <= 0;
            state <= 0;
            ctr <= 0;
        end
        else begin
            state <= next_state;
            ctr <= next_ctr;
            Din_buff <= Din;
            in_valid_buff <= in_valid;
            array_ctr <= next_arrayctr;
            length <= next_length;
        end
    end

    always @(*) begin
        case (state)
            IDLE:begin
                if(!rst)begin
                    next_state = IN;
                    next_ctr = 0;
                    ready = 1;
                    next_arrayctr = 0;
                end else begin
                    next_state = IDLE;
                    next_ctr = 0;
                    next_length = 0;
                    ready = 0;
                    out_valid = 0;
                    out_valid_SecondStage = 0;
                end
            end 
            IN:begin
                if (in_valid_buff) begin
                    if (ctr == 7) begin
                        ready = 0;
                        next_state = OUTF;
                        next_ctr = 0;
                        Y[7:6] = Din_buff;
                    end else begin
                        if (ctr < 4) begin
                            X[ctr*2+:2] =Din_buff;
                        end
                        else begin
                            Y[ctr*2-8+:2] =Din_buff;
                        end
                        next_state = IN;
                        next_ctr = ctr +1;
                    end 
                end
                else begin
                    next_state = IN;
                    next_ctr = ctr;
                end     
            end
            OUTF:begin
                if (ctr == 4) begin
                    X_array[array_ctr] = X;
                    Y_array[array_ctr] = Y;
                    next_ctr = 0;
                    out_valid = 0;
                    if(array_ctr == 3)begin
                        next_state = CAL;
                    end
                    else begin
                        next_state = IN;
                        ready = 1;
                    end
                    next_arrayctr = array_ctr + 1;
                end else begin
                    if (X >= Y) Max = X[ctr*2+:2]; 
                    else Max = Y[ctr*2+:2];
                    next_state = OUTF;
                    next_ctr = ctr + 1;
                    out_valid = 1;
                end
            end
            CAL:begin
                if(ctr == 0)begin
                    if(abs_A >= abs_B && abs_A >= abs_C)begin
                        abs_Longest = abs_A;
                        two_short = abs_B + abs_C;
                    end 
                    else if (abs_B >= abs_A && abs_B >= abs_C) begin
                        abs_Longest = abs_B;
                        two_short = abs_A + abs_C;
                    end
                    else begin 
                        abs_Longest = abs_C;
                        two_short = abs_B + abs_A;
                    end

                    if(abs_Longest == two_short)begin
                        TriangleType = 2'b00;
                    end 
                    else if (abs_Longest < two_short) begin
                        TriangleType = 2'b01;
                    end
                    else begin 
                        TriangleType = 2'b10;
                    end
                    next_state = CAL;
                    next_ctr = ctr +1;
                    length_det = 0;
                end
                else begin
                    length_det= (length+(10'h200 >> ctr))*(length+(10'h200 >> ctr));
                    if(abs_Longest == abs_length || ctr == 10)begin
                        next_ctr = 0;
                        next_state = DET;
                        LongestSide = length;
                        online = 0;
                    end
                    else begin 
                        if (abs_Longest >= length_det) begin
                            next_length = length + (10'h200 >> ctr);
                        end
                        else begin
                            next_length = length;
                        end 
                        next_ctr = ctr + 1;
                        next_state = CAL;
                    end
                end
            end
            DET:begin
                if (ctr == 3) begin
                    if(online)begin
                        ForthPoint = 2'b00;
                    end
                    else begin
                        if(mismatch) ForthPoint = 2'b10;
                        else ForthPoint = 2'b01;
                    end
                    next_state = OUTS;
                    next_ctr = 0;
                end
                else begin
                    dx1 = X_array[(ctr+1)%3] - X_array[ctr];
                    dy1 = Y_array[(ctr+1)%3] - Y_array[ctr];
                    dx2 = X_array[3] - X_array[ctr];
                    dy2 = Y_array[3] - Y_array[ctr];
                    cross_data = dx1 * dy2 - dy1 * dx2;
                    if(cross_data == 0) online = 1;
                    else if(ctr==0) begin
                        sign_ref = (cross_data>0);
                    end
                    else begin
                        if ((cross_data > 0) != sign_ref) begin
                            mismatch = 1; // 發現不同方向
                        end
                    end
                    next_state = DET;
                    next_ctr = ctr + 1;
                end
            end
            OUTS:begin
                if (ctr) begin
                    next_state = IN;
                    next_ctr = 0;
                    out_valid_SecondStage = 0;
                    mismatch = 0;
                end
                else begin
                    next_state = OUTS;
                    next_ctr = ctr +1;
                    out_valid_SecondStage = 1;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule
