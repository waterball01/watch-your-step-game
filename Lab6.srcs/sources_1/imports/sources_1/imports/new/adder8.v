`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 08:54:23 PM
// Design Name: 
// Module Name: adder8
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


module adder4(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output ovfl,
    output Cout
    );
    wire [2:0] fa_cout_w;
    FA FA_1 (.a_i(A[0]),.b_i(B[0]),.cin_i(Cin),.cout_o(fa_cout_w[0]),.s_o(S[0]));
    FA FA_2 (.a_i(A[1]),.b_i(B[1]),.cin_i(fa_cout_w[0]),.cout_o(fa_cout_w[1]),.s_o(S[1]));
    FA FA_3 (.a_i(A[2]),.b_i(B[2]),.cin_i(fa_cout_w[1]),.cout_o(fa_cout_w[2]),.s_o(S[2]));
    FA FA_4 (.a_i(A[3]),.b_i(B[3]),.cin_i(fa_cout_w[2]),.cout_o(Cout),.s_o(S[3]));
    assign ovfl = A[3]&B[3]&~S[3] | ~A[3]&~B[3]&S[3];
endmodule
