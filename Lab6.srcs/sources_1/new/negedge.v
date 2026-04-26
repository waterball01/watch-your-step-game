`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 05:04:50 PM
// Design Name: 
// Module Name: negedge
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


module negedges(
    input btn,
    input clk,
    output out
    );
    wire press, held;
    FDRE #(.INIT(1'b0)) Q0 (.C(clk),.R(1'b0),.CE(1'b1),.D(btn),.Q(press));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk),.R(1'b0),.CE(1'b1),.D(press),.Q(held));
    assign out = ~press & held;
endmodule
