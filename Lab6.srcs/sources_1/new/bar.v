`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2025 06:19:54 PM
// Design Name: 
// Module Name: bar
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


module bar(
    input btnU,
    input clk,
    input [15:0] H,
    input [15:0] V,
    input load,
    input [15:0] holeL,
    input [15:0] holeR,
    output [15:0] Qbar,
    output [15:0] Qplayer,
    input sw
    );
    wire zero,border;
    wire [15:0] Dbar, Dplayer;
    FDRE #(.INIT(1'b1)) btnu (.C(clk),.R(1'b0),.CE(~btnU|zero),.D((Qplayer==16'd152)&zero),.Q(enable));
    wire up;
    countUD16L bar (.clk(clk), .up_i(up), .dw_i(~enable&~zero&(H==16'b0)&(V==16'b0)), .ld_i(1'b0), .din_i(Dbar), .q_o(Qbar), .dtc(zero));
    countUD16L playB (.clk(clk), .up_i(~((Qplayer==16'd152&holeL<=16'd64&holeR>16'd79&~sw)|(Qplayer<16'd152&holeL<=16'd64&holeR>16'd79))&~enable&~zero&((H==16'b0)&(V==16'b0)|(H==16'b1)&(V==16'b0))), .dw_i(((H==16'b0)&(V==16'b0)|(H==16'b1)&(V==16'b0))&(~border)&((Qplayer>16'd152&zero)|(Qplayer==16'd152&holeL<=16'd64&holeR>16'd79&~sw)|(Qplayer<16'd152&holeL<=16'd64&holeR>16'd79))), .ld_i(load), .din_i(Dplayer), .q_o(Qplayer), .dtc(border));
    assign up = (Qplayer>=16'd152)&btnU&enable&(Qbar<=16'd64)&(H==16'b0)&(V==16'b0);
    assign Dbar = Qbar;
    assign Dplayer = {16{~load}}&Qplayer|{16{load}}&16'd152;
endmodule
