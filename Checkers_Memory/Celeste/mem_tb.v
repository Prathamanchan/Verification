`timescale 1ns/1ps
//`include "mem_top.v"
module memtb(cen,clk,rst,rd,wr,din,add,dout);
 output reg cen,clk,rst,rd,wr;
 output reg [7:0]din;
 output reg [11:0]add;
 input wire [7:0]dout;
 integer delay;
 real vdd,vss;
 //mem_top uut(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
 initial clk=1;
 always begin
 #delay clk=~clk;
 end

 initial begin
//$dumpfile("memory.vcd");
//$dumpvars(0,memtb);
 vdd=1.8;
 vss=0;
 cen=0;rst=1;delay=500;
 #2000;

rst=0;rd=0;wr=1;add=12'h3AA;din=8'hAA;
#2000 rd=1;wr=0;add=12'h3AB;
#2000 rd=1;wr=0;add=12'h3CD;
#2000 rd=0;wr=1;add=12'h3AB;din=8'hBB;
#2000 rd=1;wr=0;add=12'h3AA;
 /*#1000 rst=0;rd=0;wr=1;add=12'b001010101010;din=8'b10101010;
 #2000 rd=0;wr=1;add=12'b011011011010;din=8'b11111011;
 #2500 rd=0;wr=1;add=12'b101100001010;din=8'b00111010;
 #2000 rd=0;wr=1;add=12'b111010101111;din=8'b10111111;
 #2000 rd=1;wr=0;add=12'b001010101010;
 #2000 rd=1;wr=0;add=12'b011011011010;
 #2000 rd=1;wr=0;add=12'b101100001010;
 #2500 rd=1;wr=0;add=12'b111010101111;
 #2000 rd=0;wr=1;add=12'b111000111010;din=8'b11100000;
 #2000 rd=0;wr=1;add=12'b011111001110;din=8'b11111111;
 #1000 cen=1;
 #50   cen=0;
 #1000 rd=0;wr=1;add=12'b101100101010;din=8'b11101010;
 #2000 rd=0;wr=1;add=12'b111010101011;din=8'b10100011;
 #2000 rd=1;wr=0;add=12'b111000111010;
 #2000 rd=1;wr=0;add=12'b011111001110;
 #1000 cen=1;
 #80   cen=0;delay=300;
 #1000 rd=1;wr=0;add=12'b101100101010;
 #2000 rd=1;wr=0;add=12'b111010101011;    */
 #5000 $finish;
 end
 endmodule

