`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 07:27:39 PM
// Design Name: 
// Module Name: ringcounter
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


module ringcounter(
    input adv,
    input clk,
    output [3:0] sel
    );
    wire [3:0] q;
    FDRE #(.INIT(1'b1)) Q0 (.C(clk),.R(1'b0),.CE(adv),.D(q[3]),.Q(q[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk),.R(1'b0),.CE(adv),.D(q[0]),.Q(q[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk),.R(1'b0),.CE(adv),.D(q[1]),.Q(q[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk),.R(1'b0),.CE(adv),.D(q[2]),.Q(q[3]));
    assign sel = q;
endmodule
