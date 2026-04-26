`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 07:42:03 PM
// Design Name: 
// Module Name: syncs
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


module syncs(
    input [15:0] V,
    input [15:0] H,
    output Hsync,
    output Vsync
    );
    assign Hsync = (H<16'd655)|(H>16'd750);
    assign Vsync = (V<16'd489)|(V>16'd490);
endmodule
