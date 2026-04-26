`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 07:44:13 PM
// Design Name: 
// Module Name: top
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


module top(
      input btnU,
      input btnC,
      input btnR,    
      input btnL,
      input btnD,
      input clkin, 
      output [6:0] seg, 
      output dp, 
      output [3:0] an,
      output [3:0] vgaBlue,
      output [3:0] vgaRed,
      output [3:0] vgaGreen,
      output Vsync, 
      output Hsync, 
      input [15:0] sw, 
      output [15:0] led
    );
    wire [15:0] H, V;
    wire hsync, vsync;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    pixeladdress pix (.clk(clk), .H(H), .V(V));
    syncs sync (.H(H), .V(V), .Hsync(hsync), .Vsync(vsync));
    FDRE #(.INIT(1'b1)) hsyncs (.C(clk),.R(1'b0),.CE(1'b1),.D(hsync),.Q(Hsync));
    FDRE #(.INIT(1'b1)) vsyncs (.C(clk),.R(1'b0),.CE(1'b1),.D(vsync),.Q(Vsync));
    rgb rgb (.btnD(btnD), .btnU(btnU), .btnL(btnL), .btnC(btnC), .sw(sw), .clk(clk), .R(vgaRed), .G(vgaGreen), .B(vgaBlue), .H(H), .V(V), .led(led), .seg(seg), .an(an), .digsel(digsel));
    assign dp = 1'b1;
endmodule
