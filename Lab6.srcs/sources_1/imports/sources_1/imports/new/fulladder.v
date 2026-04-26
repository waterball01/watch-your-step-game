`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/08/2025 08:38:47 PM
// Design Name: 
// Module Name: fulladder
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


module FA(
    input a_i,
    input b_i,
    input cin_i,
    output s_o,
    output cout_o
    );
    wire ha1_cout_w, ha1_s_w, ha2_cout_w;
    HA HA_1 (.a_i(a_i),.b_i(b_i),.c_o(ha1_cout_w),.s_o(ha1_s_w));
    HA HA_2 (.a_i(ha1_s_w),.b_i(cin_i),.c_o(ha2_cout_w),.s_o(s_o));
    assign cout_o = ha1_cout_w | ha2_cout_w;
endmodule
