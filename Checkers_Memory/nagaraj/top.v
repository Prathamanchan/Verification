module top();
wire cen,clk,rst,rd,wr;
wire [7:0]din;
wire [11:0]address;
wire [7:0]dout;
always @(posedge clk)
begin
uut.vdd=uut1.vdd;
uut2.vdd=uut1.vdd;
uut.vss=uut1.vss;
uut2.vss=uut1.vss;
end

memory uut(.cen(cen),.clk(clk),.din(din),.address(address),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
memorytb uut1(.cen(cen),.clk(clk),.din(din),.address(address),.rst(rst),.rd(rd),.wr(wr));
checker uut2(.cen(cen),.clk(clk),.din(din),.address(address),.rst(rst),.rd(rd),.wr(wr),.dout(dout));


//#500 $finish();

endmodule
