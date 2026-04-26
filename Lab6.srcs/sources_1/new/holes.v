`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2025 07:20:29 PM
// Design Name: 
// Module Name: holes
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


module holes(
    input clk,
    input [15:0] H,
    input [15:0] V,
    input freeze,
    input start,
    output [15:0] holeL,
    output [15:0] holeR
    );
    wire [7:0] rnd;
    wire [4:0] out, outs;
    wire [15:0] widthin, widthout, thick;
    rng wid (.clk(clk), .rnd(rnd));
    assign out = rnd[4:0];
    assign outs = out&{5{out<5'd31}}|5'd30&{5{out==5'd31}};
    assign thick = {11'b0, outs};
    FDRE #(.INIT(16'b0)) Q[15:0] (.C(clk),.R(16'b0),.CE({16{1'b1}}),.D(widthin),.Q(widthout));
    wire dtcF, dtcB;
    assign widthin = (thick + 6'd41)&{16{dtcF&dtcB}}|(widthout)&{16{~(dtcF&dtcB)}};
    wire [15:0] DF, QF, DB, QB;
    countUD16L front (.clk(clk), .up_i(~freeze&~start&(H==16'b0)&(V==16'b0)&(~dtcF|QB==16'd0)), .dw_i(1'b0), .ld_i(1'b0), .din_i(DF), .q_o(QF), .dtc(dtcF));
    countUD16L back (.clk(clk), .up_i(~freeze&~start&(H==16'b0)&(V==16'b0)&(~dtcB|QF==widthout)), .dw_i(1'b0), .ld_i(1'b0), .din_i(DB), .q_o(QB), .dtc(dtcB));
    assign DF = QF&{16{(QF<=16'd622)}};
    assign DB = QB&{16{(QB<=16'd622)}};
    assign holeL = 16'd630 - QF;
    assign holeR = 16'd630 - QB;
endmodule
