`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 09:12:08 PM
// Design Name: 
// Module Name: AddSub8
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


module AddSub4(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] S,
    output ovfl
    );
    wire [3:0] sub4 = {8{sub}};
    wire [3:0] C = B ^ sub4;
    wire carry, over;
    adder4 adder (.A(A), .B(C), .Cin(sub), .S(S), .ovfl(ovfl), .Cout(carry));
endmodule
