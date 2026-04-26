`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 07:58:57 PM
// Design Name: 
// Module Name: edgedetect
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


module edgedetect(
    input btn,
    input clk,
    output out
    );
    wire press, held;
    FDRE #(.INIT(1'b0)) Q0 (.C(clk),.R(1'b0),.CE(1'b1),.D(btn),.Q(press));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk),.R(1'b0),.CE(1'b1),.D(press),.Q(held));
    assign out = press & ~held;
endmodule
