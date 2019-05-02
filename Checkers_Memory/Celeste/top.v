`timescale 1ns/1ps
module top;
wire cen,clk,rst,rd,wr;
wire [7:0]din;
wire [11:0]add;
wire [7:0]dout;

always@(posedge clk)
begin
uut.vdd=uut1.vdd;
uut2.vdd=uut1.vdd;
uut.vss=uut1.vss;
uut2.vss=uut1.vss;
end

mem_top uut(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
memtb uut1(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
check uut2(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
endmodule
