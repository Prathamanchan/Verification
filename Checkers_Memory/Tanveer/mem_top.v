`timescale 1ns/1ps

module mem_top;


 wire cen,clk,rst,rd,wr;
 wire [7:0]din;
 wire [11:0]add;
 wire [7:0]dout;
  

always @(posedge clk)
begin
  dut.vdd=tc.vdd;
  chkr.vdd=tc.vdd;
  dut.vss= tc.vss;
  chkr.vss=tc.vss;
end

mem_tc tc(.cen(cen),.clk(clk),.rst(rst),.rd(rd),.wr(wr),.din(din),.add(add));
mem_dut dut(.cen(cen),.clk(clk),.rst(rst),.rd(rd),.wr(wr),.din(din),.dout(dout),.add(add));
mem_chkr chkr(.cen(cen),.clk(clk),.rst(rst),.rd(rd),.wr(wr),.din(din),.dout(dout),.add(add));

endmodule
