module geofence (clk,reset,X,Y,valid,is_inside);
input			clk;
input			reset;
input	[10:0]	X;
input	[10:0]	Y;
output	reg		valid;
output	reg		is_inside;

reg signed [10:0] data_x [0:4];
reg signed [10:0] data_y [0:4];
reg signed [10:0] target_x,target_y;
reg [2:0] i,j;
reg [2:0] cstage;
reg sign_ref;   // 1 if > 0, 0 if < 0
reg mismatch;

wire signed [12:0] dxs1, dys1, dxs2, dys2;
wire signed [22:0] cross1;
wire signed [12:0] dx1, dy1, dx2, dy2;
wire signed [22:0] cross2;

wire signed [12:0]cx = (data_x[0]+data_x[1]+data_x[2]+data_x[3]+data_x[4])/5;
wire signed [12:0]cy = (data_y[0]+data_y[1]+data_y[2]+data_y[3]+data_y[4])/5;
wire [1:0]dim1 = (dxs1 >= 0 && dys1 >=0)? 0:
                    (dxs1 <= 0 && dys1 >= 0)? 1:
                    (dxs1 <= 0 && dys1 <=0)? 2:3;
wire [1:0]dim2 = (dxs2 >= 0 && dys2 >=0)? 0:
                    (dxs2 <= 0 && dys2 >= 0)? 1:
                    (dxs2 <= 0 && dys2 <=0)? 2:3;
                    
assign dxs1 = data_x[j] - cx;
assign dys1 = data_y[j] - cy;
assign dxs2 = data_x[j+1] - cx;
assign dys2 = data_y[j+1] - cy;
assign cross1 = dys2 * dxs1 - dys1 * dxs2;
assign dx1 = data_x[(i+1)%5] - data_x[i];
assign dy1 = data_y[(i+1)%5] - data_y[i];
assign dx2 = target_x - data_x[i];
assign dy2 = target_y - data_y[i];
assign cross2 = dx1 * dy2 - dy1 * dx2;



    always @(posedge clk or posedge reset) begin
        if(reset)begin
            cstage <= 3'b000;    
            valid <= 0;
            is_inside <= 0;
            mismatch <= 0;
            i <= 0;
            j <= 0;
        end
        else begin
            case (cstage)
            3'b000:begin//input data 
                if(i == 0) begin
                    target_x <= X;
                    target_y <= Y;
                    i <= i + 1;
                end else if (i == 6)begin
                    cstage <= 3'b001;
                    i <= 0;
                    j <= 0;
                end
                else begin
                    cstage <= 3'b000;
                    data_x[i-1] <= X;
                    data_y[i-1] <= Y;
                    i <= i + 1;
                end 
            end
            3'b001:begin//sort polygon
                if (dim1 > dim2 || (dim1 == dim2 && cross1 < 0))begin
                    data_x[j] <= data_x[j+1];
                    data_x[j+1] <= data_x[j];
                    data_y[j] <= data_y[j+1];
                    data_y[j+1] <= data_y[j];
                    if (j)
                        j <= j - 1;
                    else begin
                        if(i == 4)begin
                            cstage <= 3'b010;
                            i <= 0;
                            j <= 0;
                        end else begin
                            j <= i;
                            i <= i + 1;
                        end
                    end
                end else begin
                    if(i == 4)begin
                        cstage <= 3'b010;
                        i <= 0;
                        j <= 0;
                    end else begin
                        j <= i;
                        i <= i + 1;
                    end
                end    
            end
            3'b010:begin//cal
                if (i < 5) begin
                    cstage = 3'b010;
                    i <= i + 1;
                    if (i == 0) sign_ref <= (cross2 > 0);
                    else begin
                        if ((cross2 > 0) != sign_ref && cross2 != 0) begin
                            mismatch <= 1; // 發現不同方向
                        end
                    end
                end else begin
                    // 全部邊完成，給輸出
                    is_inside <= ~mismatch;
                    mismatch <= 0; 
                    valid <= 1;
                    cstage <= 3'b011;
                    i <= 0;
                end
            end
            3'b011:begin
                valid <= 0;
                cstage <= 3'b000;
            end
            default: begin
                is_inside <= 0;
                valid <= 0;
            end
    
        endcase
        end
    end


endmodule