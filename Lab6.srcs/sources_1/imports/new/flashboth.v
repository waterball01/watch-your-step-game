`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/01/2025 04:23:40 AM
// Design Name: 
// Module Name: flash
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


module flash(
    input in,
    input clk,
    input qsec,
    output out
    );
    FDRE #(.INIT(1'b0)) Q (.C(clk),.R(1'b0),.CE(qsec),.D(in),.Q(out));
endmodule
