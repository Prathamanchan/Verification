module test_top;

wire cen,clk,rst;
wire rd,wr;
wire [7:0]din;
wire [11:0]add;
wire [7:0]dout;

memtb test(cen,clk,din,add,rst,rd,wr);
mem_top uut(cen,clk,din,add,rst,rd,wr,dout);
checker chk(cen,clk,din,add,rst,rd,wr,dout);

//initial $display("Hello From Top");

always@(posedge clk)
begin
uut.vdd=test.vdd;
uut.vss=test.vss;
chk.vdd=test.vdd;
chk.vss=test.vss;
end

endmodule
