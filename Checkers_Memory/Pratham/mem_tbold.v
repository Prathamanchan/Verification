`timescale 1ns/1ps
//`include "mem_top.v"
module memtb;
 reg cen,clk,rst,rd,wr;
 reg [7:0]din;
 reg [11:0]add;
 wire [7:0]dout;
 real delay=500;
 mem_top uut(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
 initial 
 clk=0;
 always begin
 #delay clk=~clk;
 end

initial 
fork
//#5000 cen=1;
//#5010 cen=0;
//#20000 cen=1;
#20010 cen=0;
join

initial begin
uut.vdd=1.8;
uut.vss=0;
//$dumpfile("memory.vcd");
//$dumpvars(0,memtb);
#800 cen=0;rst=1;
//Case1
#2000 rst=0;rd=0;wr=1;add=12'b001010101010; din=8'b10101010;  //write  AA
#2000 rd=0;wr=1;add=12'b011011001010;din=8'b11101010;  //write  EA
#2500 rd=0;wr=1;add=12'b101100101010;din=8'b10111010;  //write  BA
#2000 rd=0;wr=1;add=12'b101110111010;din=8'b11111010;  //write  FA
#1000 rd=0;wr=1;add=12'b111010101010;din=8'b11101110;  //write  EE
#2000 rd=0;wr=1;add=12'b111110101110;din=8'b11111110;  //write  FE
#1000  rd=0;wr=1;add=12'b111010101000;din=8'b10111011;  //write  BB    111110101110
#1200 rd=1;wr=0;add=12'b011011001010;din=8'bx;                   //read  EA
#2500 rd=1;wr=0;add=12'b101100101010;din=8'bx;                  //read  BA
#2000 rd=1;wr=0;add=12'b101110111010;din=8'bx;                  //read  FA
#2000 rd=1;wr=0;add=12'b111010101010;din=8'bx;                  //read  EE
#2000 rd=1;wr=0;add=12'b111110101110;din=8'bx;                  //read  FE
#2500 rd=1;wr=0;add=12'b111010101000;din=8'bx;                  //read  BB
#1000 rd=1;wr=0;add=12'b101100101010;din=8'bx;                  //read 8'bxx/00     
#1000 rd=1;wr=0;add=12'b111110101101;din=8'bx;                  //read 8'bxx/00   
#10;cen=1;
#2000 rd=0;wr=1;add=12'b111110101110;din=8'b11111110;  //00
#2000 rd=0;wr=1;add=12'b111010101000;din=8'b10111010;  //00
#2000 rd=1;wr=0;add=12'b111010101010;                  //00
#2000 rd=1;wr=0;add=12'b111110101110;                  //00
#10;cen=0;

//Case2
#100 rst=0;rd=0;wr=1;add=12'b001010101010; din=8'b10101010;  //write  AA
#200 rd=0;wr=1;add=12'b011011001010;din=8'b11101010;  //write  EA
#250 rd=0;wr=1;add=12'b101100101010;din=8'b10111010;  //write  BA
#200 rd=0;wr=1;add=12'b101110111010;din=8'b11111010;  //write  FA
#10  cen=1; #50 cen=0;
#100 rd=0;wr=1;add=12'b111010101010;din=8'b11101110;  //write  EE
#200 rd=0;wr=1;add=12'b111110101110;din=8'b11111110;  //write  FE
#40  rd=0;wr=1;add=12'b111010101000;din=8'b10111011;  //write  BB
#120 rd=1;wr=0;add=12'b011011001010;din=8'bx;                  //read  EA
#250 rd=1;wr=0;add=12'b101100101010;din=8'bx;                  //read  BA
#200 rd=1;wr=0;add=12'b101110111010;din=8'bx;                  //read  FA
#10  cen=1; #50 cen=0;
#200 rd=1;wr=0;add=12'b111010101010;din=8'bx;                  //read  EE
#200 rd=1;wr=0;add=12'b111110101110;din=8'bx;                  //read  FE
#250 rd=1;wr=0;add=12'b111010101000;din=8'bx;                  //read  BB
uut.vdd=1.7;
uut.vss=0;
#2000 rd=0;wr=1;add=12'b011011001010;din=8'b10101010;
#2500 rd=0;wr=1;add=12'b101100101010;din=8'b10111010;

//Case3

uut.vdd=1.8;
uut.vss=0;
#1200 rd=1;wr=0;add=12'b011011001010;din=8'bx;                   //read  EA
#2500 rd=1;wr=0;add=12'b101100101010;din=8'bx;                  //read  BA
#2000 rd=1;wr=0;add=12'b101110111010;din=8'bx;                  //read  FA
#2000;
delay=100;
#2000 rd=1;wr=0;add=12'b111010101010;din=8'bx;                  //read  EE
#2000 rd=1;wr=0;add=12'b111110101110;din=8'bx;                  //read  FE
#2500 rd=1;wr=0;add=12'b111010101000;din=8'bx;                  //read  BB
#2000 rst=0;rd=0;wr=1;add=12'b001010101010; din=8'b10101010;  //write  AA
#2000 rd=0;wr=1;add=12'b011011001010;din=8'b11101010;  //write  EA
#2500 rd=0;wr=1;add=12'b101100101010;din=8'b10111010;  //write  BA
#2000 rd=0;wr=1;add=12'b101110111010;din=8'b11111010;  //write  FA
#2000 $finish;
end
endmodule

