`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 08:07:13 PM
// Design Name: 
// Module Name: countUD16L
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


module countUD16L(
    input clk,
    input up_i,
    input dw_i,
    input ld_i,
    input [15:0] din_i,
    output [15:0] q_o,
    output utc,
    output dtc
    );
    wire [3:0] utc_o,dtc_o,up,dw;
    assign up[0] = up_i;
    assign up[1] = up_i & utc_o[0];
    assign up[2] = up_i & utc_o[1] & utc_o[0];
    assign up[3] = up_i & utc_o[2] & utc_o[1] & utc_o[0];
    assign dw[0] = dw_i;
    assign dw[1] = dw_i & dtc_o[0];
    assign dw[2] = dw_i & dtc_o[1] & dtc_o[0];
    assign dw[3] = dw_i & dtc_o[2] & dtc_o[1] & dtc_o[0];
    countUD4L c1 (.clk(clk),.up_i(up[0]),.dw_i(dw[0]),.ld_i(ld_i),.din_i(din_i[3:0]),.q_o(q_o[3:0]),.utc_o(utc_o[0]),.dtc_o(dtc_o[0]));
    countUD4L c2 (.clk(clk),.up_i(up[1]),.dw_i(dw[1]),.ld_i(ld_i),.din_i(din_i[7:4]),.q_o(q_o[7:4]),.utc_o(utc_o[1]),.dtc_o(dtc_o[1]));
    countUD4L c3 (.clk(clk),.up_i(up[2]),.dw_i(dw[2]),.ld_i(ld_i),.din_i(din_i[11:8]),.q_o(q_o[11:8]),.utc_o(utc_o[2]),.dtc_o(dtc_o[2]));
    countUD4L c4 (.clk(clk),.up_i(up[3]),.dw_i(dw[3]),.ld_i(ld_i),.din_i(din_i[15:12]),.q_o(q_o[15:12]),.utc_o(utc_o[3]),.dtc_o(dtc_o[3]));
    assign utc = &utc_o;
    assign dtc = &dtc_o;
endmodule
