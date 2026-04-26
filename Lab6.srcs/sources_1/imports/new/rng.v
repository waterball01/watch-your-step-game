`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 08:15:55 PM
// Design Name: 
// Module Name: rng
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


module rng(
    input clk,
    output [7:0] rnd
    );
    FDRE #(.INIT(1'b0)) Q0 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[0]^rnd[5]^rnd[6]^rnd[7]),.Q(rnd[0]));
    FDRE #(.INIT(1'b0)) Q1 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[0]),.Q(rnd[1]));
    FDRE #(.INIT(1'b0)) Q2 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[1]),.Q(rnd[2]));
    FDRE #(.INIT(1'b0)) Q3 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[2]),.Q(rnd[3]));
    FDRE #(.INIT(1'b0)) Q4 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[3]),.Q(rnd[4]));
    FDRE #(.INIT(1'b1)) Q5 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[4]),.Q(rnd[5]));
    FDRE #(.INIT(1'b0)) Q6 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[5]),.Q(rnd[6]));
    FDRE #(.INIT(1'b0)) Q7 (.C(clk),.R(1'b0),.CE(1'b1),.D(rnd[6]),.Q(rnd[7]));
endmodule
