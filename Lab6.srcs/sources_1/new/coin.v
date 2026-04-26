`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2025 04:27:55 PM
// Design Name: 
// Module Name: coin
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


module coin(
    input clk,
    input [15:0] H,
    input [15:0] V,
    input [15:0] playerheight,
    input start,
    input freeze,
    input freezein,
    output [15:0] ballHeightout,
    output [15:0] ballL,
    output freezeout,
    output zero
    );
    wire [7:0] rnd;
    wire [5:0] out, outs;
    wire [15:0] thick, ballHeightin;
    rng wid (.clk(clk), .rnd(rnd));
    assign out = rnd[5:0];
    assign outs = out&{6{out<6'd61}}|6'd30&{6{out>=6'd61}};
    assign thick = {10'b0, outs};
    wire dtcF;
    FDRE #(.INIT(16'b0)) Q[15:0] (.C(clk),.R(16'b0),.CE({16{1'b1}}),.D(ballHeightin),.Q(ballHeightout));
    assign ballHeightin = ((thick + 15'd192)&{16{dtcF&~start&~freeze}})|(ballHeightout&{16{~dtcF|start|freeze}});
    wire [15:0] DF, QF;
    countUD16L left (.clk(clk), .up_i(~freezein&~start&((H==16'b0)&(V==16'b0)|(H==16'd1)&(V==16'b0)|(H==16'd2)&(V==16'b0)|(H==16'd3)&(V==16'b0))), .dw_i(1'b0), .ld_i(1'b0), .din_i(DF), .q_o(QF), .dtc(dtcF));
    wire dtcC, flashin;
    wire [15:0] QC, DC;
    assign DF = QF&{16{(QF<=16'd623)}}&{16{QC!=16'd170}};
    wire [15:0] playerbot, playertop, balluptop, ballR;
    assign ballL = 16'd632 - QF;
    assign playerbot = 16'd471 - playerheight;
    assign playertop = playerbot - 16'd16;
    assign balluptop = ballHeightout - 16'd8;
    assign ballR = 16'd8 + ballL;
    assign freezeout = ((ballHeightout>=playertop&ballHeightout<=playerbot)|(balluptop<=playerbot&balluptop>=playertop)|freezein)&
    ((16'd79>=ballL&ballL>=16'd64)|(16'd64<=ballR&ballR<=16'd79));
    countUD16L timer (.clk(clk), .up_i(freezeout&(H==16'b0)&(V==16'b0)), .dw_i(1'b0), .ld_i(1'b0), .din_i(DC), .q_o(QC), .dtc(dtcC));
    assign DC = QC&{16{QC<=16'd169}};
    assign zero = (QC!=16'd170);
endmodule
