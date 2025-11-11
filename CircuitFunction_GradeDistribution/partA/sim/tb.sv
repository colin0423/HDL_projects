`timescale 1ns/10ps
`define CYCLE 10.0
/*====================== Please Include Your Circuit ============================*/
`include "./HDL.v"
/*===============================================================================*/
module tb;

logic clk,rst,in_valid;
logic [1:0]Din;
logic ready,out_valid,out_valid_SecondStage;
logic [1:0]Max;
reg [4:0]in_cnt,out_cnt;
reg [7:0]User_Out;
logic [7:0]A,B,A_in,B_in; 
real Maxium_real;
logic [7:0]Maxium;
logic check;
logic [4:0]close_in_valid_cnt,C;
logic state;
logic TB_ready;

integer i, err_cmp, err_cent, err_longest, err_angle, err_4p, grade;
logic [1:0] TriangleType,ForthPoint;
logic [7:0] Center_of_MassX,Center_of_MassY;
logic [2:0] check_cnt;

string path;
string correct, false;
string rslt_cmp, rslt_cent, rslt_longest, rslt_angle, rslt_4p;

logic [8:0] LongestSide;
initial begin
    $value$plusargs("path=%s", path);
	$readmemb({path, "/ANS.txt"},Answer);
	$readmemb({path, "/Input_XY.txt"},inputXY);
end

HDL HDL(.clk(clk),.rst(rst),.Din(Din),.in_valid(in_valid),.ready(ready),.Max(Max),.out_valid(out_valid),.out_valid_SecondStage(out_valid_SecondStage), .Center_of_MassX(Center_of_MassX), .Center_of_MassY(Center_of_MassY), .LongestSide(LongestSide), .TriangleType(TriangleType), .ForthPoint(ForthPoint));
//DUT DUT(.clk(clk),.rst(rst),.d_in(Din),.input_valid(in_valid),.ready(ready),.bigger_NUM(Max),.output_valid(out_valid));

initial begin
	clk = 1;
end
always #(`CYCLE/2) clk = ~clk;

logic [15:0]inputXY[399:0];
logic [28:0]Answer[99:0];
logic [28:0]Tri_Answer;

initial begin
/*=================== Please Export Your FSDB/VCD File ==========================*/
	$fsdbDumpfile("top.fsdb");
	$fsdbDumpvars;
	$fsdbDumpMDA;
/*===============================================================================*/
	correct = "Pass";
	false = "Fail";
	err_cent = 0;
	err_longest = 0;
	err_angle = 0;
	err_4p = 0;
	err_cmp = 0;
	rst = 1;
	grade = 0;
	repeat (2) @(negedge clk);
	rst =0;
	$display("\n\n======================%-20s======================\n", " Simulation  Start ");
	for(i=0;i<20;i=i+1)begin
		$display("\n\n====================== Case %-3d, Input XY ======================\n", i+1);
		TB_ready = 1;
		A = inputXY[4*i][15:8];
		B = inputXY[4*i][ 7:0];
		state = 0;
		C = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+1][15:8];
		B = inputXY[4*i+1][ 7:0];
		state = 0;
		C = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+2][15:8];
		B = inputXY[4*i+2][ 7:0];
		state = 0;
		C = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+3][15:8];
		B = inputXY[4*i+3][ 7:0];
		state = 0;
		C = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		Tri_Answer = Answer[i];
		@(out_valid_SecondStage) TRI_ANSWER_SHOW;
		repeat (5) @(negedge clk);
		@(negedge clk) rst = 1;
		@(negedge clk) rst = 0;
	end
	$display("\n\n======================    %s    ======================\n", " 20 Finish ");
	repeat (20) @(negedge clk) $display;
	for(i=20;i<100;i=i+1)begin
		$display("\n\n====================== Case %-3d, Input XY ======================\n", i+1);
		TB_ready = 1;
		A = inputXY[4*i][15:8];
		B = inputXY[4*i][ 7:0];
		C = {$random()}%8+1;
		state = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+1][15:8];
		B = inputXY[4*i+1][ 7:0];
		C = {$random()}%8+1;
		state = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+2][15:8];
		B = inputXY[4*i+2][ 7:0];
		C = {$random()}%8+1;
		state = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		repeat (5) @(negedge clk);
		TB_ready = 1;
		A = inputXY[4*i+3][15:8];
		B = inputXY[4*i+3][ 7:0];
		C = {$random()}%8+1;
		state = 1;
		A_in = A;
		B_in = B;
		//ANSWER_SHOW;
		@(check) ANSWER_SHOW;
		TB_ready = 0;
		Tri_Answer = Answer[i];
		@(out_valid_SecondStage) TRI_ANSWER_SHOW;
		repeat (5) @(negedge clk);
		@(negedge clk) rst = 1;
		@(negedge clk) rst = 0;
	end
	$display("\n\n======================    %s    ======================\n", " 100 Finish ");
	if(!err_cmp && !err_cent && !err_longest && !err_angle && !err_4p)
		all_pass_chiikawa;
	$display("\n\n======================%-21s======================\n", " Simulation  Finish ");
	final_cmp;
	
	#100 $finish;
end

initial begin
	#100000000 $finish;
end

always@(negedge clk)begin 
    if(rst)begin
	check <= 1'b0;
	out_cnt <= 5'd0;
	User_Out <= 8'd0;
    end else begin
	if(out_valid)begin
		if(out_cnt>5'd3)begin 
			$display("\n\n===============  ERROR : Your Output Exceed 8 Bits  ===============\n");
			$finish;
		end
		out_cnt <= out_cnt + 5'd1;
		if(out_cnt==5'd3) begin
			check <= 1'b1;
			User_Out <= {Max,User_Out[7:2]};
		end else User_Out <= {Max,User_Out[7:2]};
	end else begin
		check <= 1'b0;
		out_cnt <= 5'd0;
		User_Out <= 8'd0;
	end
    end
end
initial close_in_valid_cnt <=  5'd0; 
always@(negedge clk)begin
	if(state)begin
		if(close_in_valid_cnt==C) close_in_valid_cnt <=  5'd0;
		else close_in_valid_cnt <= close_in_valid_cnt + 5'd1;
	end else begin
		close_in_valid_cnt <= close_in_valid_cnt + 5'd1;
	end
end

always@(negedge clk)begin
    if(rst)begin
	check_cnt <= 3'd0;
    end else begin
	if(check)begin 
		if(check_cnt == 3'd3) check_cnt <= check_cnt + 3'd1;
		else check_cnt <= check_cnt + 3'd1;
	end else check_cnt <= check_cnt;
    end
end
always@(negedge clk)begin 
    if(rst)begin
	in_valid <= 1'b0;
	in_cnt <= 5'd0;
	Din <= 2'd0;
    end else begin
	if(ready && TB_ready)begin
		if(in_cnt>5'd8)begin 
			$display("\n\n===============  ERROR: You Should set ready Signal 0 if you Get A B Data  ===============\n");
			$finish;
		end
		if((close_in_valid_cnt==C) && state)begin
			in_valid <= 1'b0;
			in_cnt <= in_cnt;
			if(in_cnt<5'd4)begin
				Din <= 2'd0;
				A_in <= A_in;
			end else begin
				Din <= 2'd0;
				B_in <= B_in;
			end
		end else begin
			in_valid <= 1'b1;
			in_cnt <= in_cnt + 5'b1;
			if(in_cnt<5'd4)begin
				Din <= A_in[1:0];
				A_in <= A_in>>2;
			end else begin
				Din <= B_in[1:0];
				B_in <= B_in>>2;
			end
		end
	end else begin
		in_valid <= 1'b0;
		in_cnt <= 5'd0;
		Din <= 2'd0;
	end
    end
end

task ANSWER_SHOW;
begin
	if(A>B) Maxium = A;
	else Maxium = B;
	if(Maxium == User_Out)begin
		$display("\n\n---  Output :  X is  %d ;  Y is %d    , %-7s ✔️:  Your ANS is  %d ;  The Real ANS is %d", A, B, "Success", User_Out,Maxium);
	end else begin 
		err_cmp++;
		$display("\n\n---  Output :  X is  %d ;  Y is %d    , %-7s ❌:  Your ANS is  %d ;  The Real ANS is %d", A, B, "Failed", User_Out,Maxium);
		$finish;
	end
end
endtask
task TRI_ANSWER_SHOW;
begin
	if({Center_of_MassX,Center_of_MassY,LongestSide,TriangleType,ForthPoint} == Tri_Answer)begin
		$display("\n\n======================%-23s======================\n", " Success Triangle Part ");
		$display("\n\n---  %-15s %-7s :  Your ANS is  %-3d,%-3d ;  The Real ANS is %-3d,%-3d   ","Center_of_Mass", "Success ✔️",  Center_of_MassX,Center_of_MassY,Tri_Answer[28:21],Tri_Answer[20:13]);
		$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ","LongestSide", "Success ✔️", LongestSide,Tri_Answer[12:4]);
		$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ","TriangleType", "Success ✔️", TriangleType,Tri_Answer[3:2]);
		$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ","ForthPoint", "Success ✔️", ForthPoint,Tri_Answer[1:0]);
	end else begin
		$display("\n\n======================%-23s======================\n", " Failed Triangle Part ");
		if({Center_of_MassX,Center_of_MassY}== Tri_Answer[28:13])
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-3d,%-3d ;  The Real ANS is %-3d,%-3d   ","Center_of_Mass", "Success ✔️", Center_of_MassX,Center_of_MassY,Tri_Answer[28:21],Tri_Answer[20:13]);
		else begin
			err_cent++;
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-3d,%-3d ;  The Real ANS is %-3d,%-3d   ","Center_of_Mass", " ❌", Center_of_MassX,Center_of_MassY,Tri_Answer[28:21],Tri_Answer[20:13]);
		end
		if(LongestSide==Tri_Answer[12:4])
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "LongestSide", "Success ✔️", LongestSide,Tri_Answer[12:4]);
		else begin
			err_longest++;
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "LongestSide", "Failed ❌", LongestSide,Tri_Answer[12:4]);
		end
		if(TriangleType==Tri_Answer[3:2])
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "TriangleType", "Success ✔️", TriangleType, Tri_Answer[3:2]);
		else begin
			err_angle++;
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "TriangleType", "Failed ❌", TriangleType, Tri_Answer[3:2]);
		end
		if(ForthPoint==Tri_Answer[1:0])
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "ForthPoint", "Success ✔️", ForthPoint,Tri_Answer[1:0]);
		else begin
			err_4p++;
			$display("\n\n---  %-15s %-7s :  Your ANS is  %-7d ;  The Real ANS is %-7d   ", "ForthPoint", "Failed ❌", ForthPoint,Tri_Answer[1:0]);
		end
		// $finish;
	end
end 
endtask

task final_cmp;
begin
	if(!err_cmp) begin
		rslt_cmp = correct;
		grade+=15;
	end
	else
		rslt_cmp = false;
	
	if(!err_cent) begin
		rslt_cent = correct;
		grade+=10;
	end
	else
		rslt_cent = false;
	
	if(!err_longest) begin
		grade+=15;
		rslt_longest = correct;
	end
	else
		rslt_longest = false;
	
	if(!err_angle) begin
		rslt_angle = correct;
		grade+=15;
	end
	else
		rslt_angle = false;
	
	if(!err_4p) begin
		rslt_4p = correct;
		grade+=15;
	end
	else
		rslt_4p = false;


$display("┌────────────────────┬────────────────────┬────────────────────┬────────────────────┬────────────────────┬────────────────────┐");
$display("│%-16s    │%-16s    │%-16s    │%-16s    │%-16s    │%-16s    │", 
			"", "Compare", "Center_of_Mass", "LongestSide", "TriangleType", "ForthPoint");
$display("├────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┤");
$display("│%-16s    │%-16s    │%-16s    │%-16s    │%-16s    │%-16s    │", 
         "Results",rslt_cmp, rslt_cent, rslt_longest, rslt_angle, rslt_4p);
$display("├────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┤");
$display("│%-16s    │%-16d    │%-16d    │%-16d    │%-16d    │%-16d    │", 
         "Error Count", err_cmp, err_cent, err_longest, err_angle, err_4p);
$display("├────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┼────────────────────┤");
$display("│%-16s    │%-16d    │%-16d    │%-16d    │%-16d    │%-16d    │", 
         "Partial Score", 15, 10, 15, 15, 15);
$display("└────────────────────┴────────────────────┴────────────────────┴────────────────────┴────────────────────┴────────────────────┘");

$display("\n====================== Your Score is %0d/70 ======================\n", grade);

end
endtask

task all_pass_chiikawa;
begin
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░█▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░▒▓▓▓██▓▓▓▒░░░░░░░░░░░░░░░░░░░▓█░▒█▓░░░░▒▒▒█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░█▒░░░░░░░░▒░░░░░░░░░░░░▓▓██▓▒▒▓▒░░░░▒▒████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░▒▓▓██▒░░░░░█▓░░░░█▓░░░░░░▓█▒▓█▒░░░░░░▒▓███▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░▓▓░░░░░▓█▓░░░▒█░░░░░░░░░░█▓░░░░░░░░█▓░░▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░▒▒█▒░░░░░░░░░░░░░░░░░░░░░▓█▒░░░░░░░░░█▓░░█▒░░░░░░░░░░░░░░░░▒▓██▓▒░░░▒██▓▒░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░▒▓▓░░▓▓▒░▒█▒░▓█▒░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓░▒▒█▓░██░░▒█▓░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓░▒▒█▓▒█▒░▒▒█▓░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░▒▓██▓▒░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▒░▒█▓▒█▒░▒▒█▓░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░▒█▓▒▒▓█▒░░░░░░░░░░░░░░░▒▓██▓██▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░▒█▒▓█░░▒▓█▒░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░▒▓▓▒▒▒▒▓██▒▒▒▒▒▒▒▒▒░░▒▒███▒▒▒▒██▒░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░▒▓▓█▒░▒▒▓▒░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░▒▓█▓▒▒▒▒▒▒▓█▓▓▓▓████████▓▒▒▒▒▒▒▓█▓░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▒▒▓█▓▓░▒▒▓█▒░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░▒█▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█▓▒░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓░▒█▓▒░░▒▒█▒░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░▒▓█▓▒▒▒▒▒▒▒▒▒▒▒▒▓██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▒░░░░░░░░░░░░░░░░▒▓▓██▓▒▒░░░░▒░░░░▒▓▒▒▒░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░▒▒█▓▒██▓▓▒▒▒▒▒▒▒▓▓██▒▒██▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░▒▓█▓▒░░░░░░░░░░░░░░░░░░▒▒▓██▓▒░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░▒▓▓░░░░░░▒███████▓░░░░░░▒███▓▒▒▒▒▒▒▒▒▒▓██▓▒░░░░░░░░▒▒██▒░░░░░░░▒██▓░░░░░░░░░░░░░░░▒██▓▒░░░░░░░░░░░░░");
	$display("░░░░░░░░░▒█▓░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓███████▓▒░░██▒░░░░░░▒▓█▒░░░░░░░▓█▒░░░░░░░░░░░░░▒▓█▒░░░▒██▒▒░░░░░░░░░░░");
	$display("░░░░░░░░▒█▓░░░░░░░░░░░░░░▒▓▒░░░░░░░░░▒▒░░░░░░░░░░░░░▓█▓▒░░░▒██▒░░░░░░░▓▓░░░░░░░░░░░░░░░░░░▓█▒░░░▓█▓▒░░░░░░░░░░");
	$display("░░░░░░░▒▓█░░░░░░░░░░░░░▒▓▒░░░░░░░░░░▒▒░░░░░░░░░░░░░░░▓█▒▒░▒█▓▒░░░░░░░▒▓▒░░░░░░░░░░░░░░░░░░░▓▓▒░░░▒█▓▒░░░░░░░░░");
	$display("░░░░░░░▒▓▓░░░░░░░░░░░▒█▓░▒█▓░░░░░░░░░▒▓▓▒░░░░░░░░░░░░░██▒░▓█▒░░░░░░░░▒▒░░░▓█▓▒░░░░░░░░▒▓▓░░░▒░░░░░▓█▓░░░░░░░░░");
	$display("░░░░░░░▒█▒░░░░░░░▒▒▒▒▓██████░░░░░░░░██░░▓▓░░░░░░░░░░░░▓█▒▒█▓░░░░░░░░░░░░░▓█▒▓█▒░░░░░░▒█▒▒█▒░░░░░░░▒██▒░░░░░░░░");
	$display("░░░░░░░▒█▒░░░░░▒█▒▓▓▒▒▓████░░░░░░░░░█████▓░░░░░░░░░░░░▓█▒▒█▓░░░░░░░░░▒▒▒▒▓█▓▓█░░░░░░░▒█▓▒█▒░░░░░░░░██▒░░░░░░░░");
	$display("░░░░░░░▒█▒░░░░░░▒▒▓▓▓▒▓▒░░░░░░▒░░░░░▒▓█▓▓▒▒▒▒▒░░░░░░░░▓█▒▒█▒░░░░░░░▒█▒▓▒▓▒▒▒▒░░░░░▒▒░░▒▒▒▓▓▓▒▒▒▒░░░██▒░░░░░░░░");
	$display("░░░░░░░▒▓▒░░░░░░░░░░░░░░░░░▓▓░█▓░░░░░░░▒▓▒▒█▓█▓▒░░░░░░█▓▒▒█▒░░░░░░░▓▒▒▓▓▓▒▓░░░░▒▒░▓█▒▒▒▒▒█▒▓▓▓▒▒░░░██▒░░░░░░░░");
	$display("░░░░░░░░▒█▒░░░░▒▓▒░░░░░░░░░░▒▒▒██▓▒░░░░▒▒▒▓▒▓▓▓░░░░░░▒█▒░▒█▓░░░░░░░░▒▓███▓▒░░░░▒▓▓▓▒██▒░░▒▒▒▒▒░▒░░▒█▓░░░░░░░░░");
	$display("░░░░░░░░▒▒█▓░░▓▓░▒█▒░░░░░░░░░▒█▓░░░░░░▒▓█▓▓██▒░░░░░▒▒██▓▓▓██▓▒▒░░░░▒█▓░░░▓█▒░░░░░░░▒▓▒░░░░░░░▒█▒▒███▒░░░░░░░░░");
	$display("░░░░░░░░░░▒██▓█░░▒█▒░░░░░░░░░░░░░░░░░░█▓░░░░▓█▓███▓▒▒░░░░░░░░▒▒▓█████▒░░░░█▓░░░░░░░░░░░░░░░░░▓█░░▒█▒░░░░░░░░░░");
	$display("░░░░░░░░░░░▓█▓▓▒░▒█▒░░░░░░░░░░░░░░░░░░▓▓▒░░░▒▓▒░░░░░░░░░░░░░░░░░░░░░▒░░░░▓█▒░░░░░░░░░░░░░░░░░▒█▒░▒█▓▒▒░░░░░░░░");
	$display("░░░░░░░░░░▒█▒░░░░░▒▓▓░░░░░░░░░░░░░░░░░▒▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▒░░░░░░░░░░░░░░░░░▒▓▓█▒░░░░▓█▒▒░░░░░░");
	$display("░░░░░░░░░░▒█▓░░░░░░░░░░░░░░░░░░░░░░░▒█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒█▓▒░░░░░░░░░░░░░░░░░░░░░░░░▓▓▒░░░░░░");
	$display("░░░░░░░░░░░▒▓█▓▓████▓░░░░░░░░░░░░░▒▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██░░░░░░░░░░░░░░░░▒░░░░░▒█▒▒░░░░░░");
	$display("░░░░░░░░░░░░░░░░▓▓░░░░░░░░░░░░░░░▒█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█▓░░░░░░░░░░░░▒▒▒█▓▒▓█▓▒░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░▒▓▓▒░░░░░░░░░░░░▒█▒░░░░░░░░░░░░░░▒▓▓▒░░░░░░░░░▒▓█▒░░░░░░░░░░░░▓█▓░░░░░░░░░░▒▒▒░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░▒▒█▓▒░░░░░░░░░░█▓░░░░░░░░░░░░░░░░▒░▒░░░░░░░░▒▒▒░░░░░░░░░░░░░░░▒█▓░░░░░░░░▒█▓▒░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░▒▒▓█▓▒░░░░░░▓█░░░░░░░░░░░░░░▒▓▓▓█▓░░░░░░░░░▓█▓█▓░░░░░░░░░░░░░▓█▒░░░░░░▒█▓▒░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░▒▒▓██▓▓▓▒█▓░░░░░░░░░░░░░▒██▓▓██▒░░░░░░░▓██▓██▒░░░░░░░░░░░░▒█▒░░░░▒▓█▒▒░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒█▒▓█▒░░░░░░░░░▒▒▒▒▒▓█▓▓█▓░░░░░░░░▒█▓▒▓█▒▒▒▒▒░░░░░░░░▒█▒░▒▓█▓▒▒░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒███░░░░░░░░▒█▒▓▓▓▒▒▒░░░░░░░░░░░░░░░░░▒█▓▓▓▒▓▒▒░░░░░▒███▓▒░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█▒░░░░░░░▓▒▒▓▓▓▒▓▒░░░░▒░░▓█░░░░░░░░▓▓▒█▒▓▓█▒░░░░░▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒█▓░░░░░░░░░░▒▒▒░░░░░░░▒███▓██▓░░░░░░░▒▒▒▒▒░░░░░░░██▒░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██▒░░░░░░░░░░░░░░░░░░░░░░▒▓▓░░░░░░░░░░░░░░░░░░░░▒█▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░░░░░░░░░█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░░░░▓█░▒█▓░░░░░░░░░░░░░░░░░░░▓▓░░▒█▒░░░░░░██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██░░░▓█░▒▓██▓▒░░░░░░░░░░░░░░░▒█▒░░▓▓░░░░░▒█▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█░░▒▓█░░░░░▓█▒░░░░░░░░░░░░░░▒██░░▒█▓▒▒░░▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓░░░░░░░░░░░█▓░░░░░░░░░░░░░░█▓░░░░░░▒▒░▒█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒█▓░░░░▒▓▒░░▓█▒░░░░░░░░░░░░░░▓▓▒░░░▓▒▒▓▓█▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒████▓▒▓██▓░░░░░░░░░░░░░░░░░▒█████▓█▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██▒░░░░░░░░░░░░░░░░░░░░░░▓█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓█▓▒░░░░░░░░░░░░░░░░░▓█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓▓████▒░▓▒░░▓▓▓▓██▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██▒▒██░▒██▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒██▓██▒█▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░");
	$display("░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░");
end
endtask

endmodule