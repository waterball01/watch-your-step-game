`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2025 08:24:26 PM
// Design Name: 
// Module Name: rgb
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


module rgb(
    input btnD,
    input btnU,
    input btnL,
    input btnC,
    input [15:0] sw,
    input clk,
    output [3:0] R,
    output [3:0] G,
    output [3:0] B,
    input [15:0] H,
    input [15:0] V,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    input digsel
    );
    wire bU;
    FDRE #(.INIT(1'b0)) btnu (.C(clk),.R(1'b0),.CE(1'b1),.D(btnU),.Q(bU));
    wire [15:0] barHeight, playerHeight, holeL, holeR, ballL, ballHeight;
    wire load;
    FDRE #(.INIT(1'b1)) l (.C(clk),.R(1'b0),.CE(1'b1),.D(1'b0),.Q(load));
    bar bar (.btnU(bU), .clk(clk), .H(H), .V(V), .load(load), .holeL(holeL), .holeR(holeR), .Qbar(barHeight), .Qplayer(playerHeight), .sw(sw[15]));
    wire freeze, startin, startout, freezeC, freezein, zero;
    FDRE #(.INIT(1'b0)) st (.C(clk),.R(1'b0),.CE(1'b1),.D(startin|btnC),.Q(startout));
    assign startin = startout;
    holes hole (.clk(clk), .H(H), .V(V), .freeze(freeze), .start(~startout), .holeL(holeL), .holeR(holeR));
    assign freeze = (playerHeight==16'd152&holeL<=16'd64&holeR>16'd79&~sw[15])|(playerHeight<16'd152&holeL<=16'd64&holeR>16'd79);
    coin coins (.clk(clk), .H(H), .V(V), .start(~startout), .playerheight(playerHeight), .ballHeightout(ballHeight), .ballL(ballL), .freezein(freezein), .freezeout(freezeC), .freeze(freeze), .zero(zero));
    FDRE #(.INIT(1'b0)) freezez (.C(clk),.R(1'b0),.CE(1'b1),.D(freezeC),.Q(freezein));
    wire flashin, flashout, dtcF;
    wire [15:0] QF, DF;
    countUD16L timer (.clk(clk), .up_i((H==16'b0)&(V==16'b0)), .dw_i(1'b0), .ld_i(1'b0), .din_i(DF), .q_o(QF), .dtc(dtcF));
    assign DF = QF&{16{QF<=16'd20}};
    FDRE #(.INIT(1'b1)) Q (.C(clk),.R(1'b0),.CE(freeze&QF==16'd20&(H==16'b0)&(V==16'b0)),.D(flashin),.Q(flashout));
    assign flashin = ~flashout;
    wire flashinC, flashoutC, dtcC;
    wire [15:0] QC, DC;
    countUD16L timerC (.clk(clk), .up_i(freezeC&(H==16'b0)&(V==16'b0)), .dw_i(1'b0), .ld_i(1'b0), .din_i(DC), .q_o(QC), .dtc(dtcC));
    assign DC = QC&{16{QC<=16'd20&freezeC}};
    FDRE #(.INIT(1'b1)) Qcoin (.C(clk),.R(1'b0),.CE(freezeC&QC==16'd20&(H==16'b0)&(V==16'b0)),.D(flashinC),.Q(flashoutC));
    assign flashinC = ~flashoutC;
    wire add;
    wire [15:0] barBot, barTop, playerBot, playerTop, ballR, balluptop, scorein, scoreout;
    negedges neg (.btn(freezein), .clk(clk), .out(add));
    countUD16L scores (.clk(clk), .up_i(add), .dw_i(1'b0), .ld_i(1'b0), .din_i(scorein), .q_o(scoreout));
    assign scorein = scoreout;
    wire [3:0] sel;
    ringcounter ring (.adv(digsel),.clk(clk),.sel(sel));
    wire [3:0] out;
    selector select (.N(scoreout),.sel(sel),.H(out));
    wire [6:0] nums;
    hex7seg hexseg (.n(out),.seg(seg));
    wire color, enablein, enableout;
    edgedetect pos (.btn(freezein), .clk(clk), .out(color));
    FDRE #(.INIT(1'b0)) QE (.C(clk),.R(1'b0),.CE(color),.D(enablein),.Q(enableout));
    assign enablein = ~enableout;
    assign an[1] = ~sel[1];
    assign an[0] = ~sel[0];
    assign barBot = 16'd96;
    assign barTop = 16'd96 - barHeight;
    assign playerBot = 16'd471 - playerHeight;
    assign playerTop = playerBot - 16'd16;
    assign ballR = ballL + 16'd8;
    assign balluptop = ballHeight - 16'd8;
    assign led[15:0] = 16'd0;
    assign R =  4'b1111&{4{H>=16'd32&H<=16'd47&V<=barBot&V>barTop}}|
                4'b1111&({4{(H>=16'd0&H<=16'd7)|(H>=16'd632&H<=16'd640)}}|{4{(V>=16'd0&V<=16'd7)|(V>=16'd472&V<=16'd480)}})|
                4'b1111&{4{((H>=16'd64&H<=16'd79)&V<=playerBot&V>playerTop)&flashout&enableout}}|
                4'b1111&{4{(H>=ballL&H<=ballR&H<=16'd631)&(V<=ballHeight&V>=balluptop)&flashoutC}};
    assign G =  4'b1111&{4{((H>=16'd8&H<holeL&(holeL<=holeR))|(H>=holeR&H<=16'd631))&V>=16'd340&V<=16'd471}}|
                4'b1111&{4{H>=16'd32&H<=16'd47&V<=barBot&V>barTop}}|
                4'b1111&{4{((H>=16'd64&H<=16'd79)&V<=playerBot&V>playerTop)&flashout&~enableout}}|
                4'b1111&{4{(H>=ballL&H<=ballR&H<=16'd631)&(V<=ballHeight&V>=balluptop)&flashoutC}};
    assign B =  4'b1111&{4{((H>=16'd8&H<holeL&(holeL<=holeR))|(H>=holeR&H<=16'd631))&V>=16'd340&V<=16'd471}}|
                4'b1111&{4{H>=16'd32&H<=16'd47&V<=barBot&V>barTop}}|
                4'b1111&{4{((H>=16'd8&H<holeL&(holeL<=holeR))|(H>=holeR&H<=16'd631))&V>=16'd320&V<=16'd339}}|
                4'b1111&{4{((H>=16'd64&H<=16'd79)&V<=playerBot&V>playerTop)&flashout&enableout}};
endmodule
