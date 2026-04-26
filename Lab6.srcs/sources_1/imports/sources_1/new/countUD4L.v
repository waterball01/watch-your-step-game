`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 07:41:35 PM
// Design Name: 
// Module Name: countUD4L
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module countUD4L(
    input clk,
    input up_i,
    input dw_i,
    input ld_i,
    input [3:0] din_i,
    output [3:0] q_o,
    output utc_o,
    output dtc_o
    );
    wire [3:0] Dout;
    wire ovfl;
    wire [3:0] B;
    assign B[3:1] = 3'b0;
    wire up = up_i & ~dw_i & ~ld_i;
    wire dw = ~up_i & dw_i & ~ld_i;
    assign sub = ~up & dw;
    assign B[0] = ~ld_i & (up ^ dw);
    AddSub4 counter (.A(din_i), .B(B), .sub(sub), .S(Dout), .ovfl(ovfl));
    assign dtc_o = &(~q_o);
    assign utc_o = &(q_o);
    FDRE #(.INIT(1'b0)) Q0 (.C(clk),.R(1'b0),.CE(1'b1),.D(Dout[0]),.Q(q_o[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk),.R(1'b0),.CE(1'b1),.D(Dout[1]),.Q(q_o[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk),.R(1'b0),.CE(1'b1),.D(Dout[2]),.Q(q_o[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk),.R(1'b0),.CE(1'b1),.D(Dout[3]),.Q(q_o[3]));
endmodule
