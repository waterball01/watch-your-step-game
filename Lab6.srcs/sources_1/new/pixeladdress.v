`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 07:19:30 PM
// Design Name: 
// Module Name: pixeladdress
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


module pixeladdress(
    input clk,
    output [15:0] V,
    output [15:0] H
    );
    wire [15:0] dH, dV;
    wire dtcH;
    countUD16L h (.clk(clk), .up_i(1'b1), .dw_i(1'b0), .ld_i(H==16'd799), .din_i(dH), .q_o(H), .dtc(dtcH));
    countUD16L v (.clk(clk), .up_i(H==16'd799), .dw_i(1'b0), .ld_i(V==16'd524&H==16'd799), .din_i(dV), .q_o(V));
    assign dH = H&{16{H!=16'd799}};
    assign dV = V&{16{!((V==16'd524)&(H==16'd799))}};
endmodule
