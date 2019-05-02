`timescale 1ns/1ps
//`include "mem_top.v"
module memorytb(cen,clk,din,address,rst,rd,wr);
 output reg cen,clk,rst,rd,wr;
 output reg [7:0]din;
 output reg [11:0]address;
 real vdd,vss;
 //input wire [7:0]dout;
 //memory uut(.cen(cen),.clk(clk),.din(din),.address(address),.rst(rst),.rd(rd),.wr(wr),.dout(dout));
 initial 
 clk=1;
 always begin
 #500 clk=~clk;
 end

/*initial 
fork
#20000 vdd=1.7;
#30000 vdd=1.8;
join*/

initial begin
vdd=1.8;
vss=0;
//$dumpfile("memory.vcd");
//$dumpvars(0,memtb);

//#1000 rst=1;
//#1000 cen=0;rst=0;
#2000 cen=0; rst=0;rd=0;wr=1;address=12'b001010101010; din=8'b10101010; //writing the data and addresses 
//rd=0;wr=1;add=12'b011011001010;din=8'b10101010;
#1500 rd=0;wr=1; address=12'b101100101010;din=8'b10111010;
#2000 rd=0;wr=1;address=12'b101110111010;din=8'b11111010;
#2500 rd=0;wr=1;address=12'b111010101010;din=8'b11101010;
#3000 rd=0;wr=1;address=12'b111010111010;din=8'b11111011; 

#4510 address=12'b001010101010;din=8'b11111111; 
#50 rst=0;rd=1;wr=0;address=12'b001010101010; 

#2000 rd=1;wr=0;address=12'b011011001010;
#2000 rd=1;wr=0;address=12'b101100101010;
#2500 rd=1;wr=0;address=12'b101110111010;
#3000 rd=1;wr=0;address=12'b111010101010;
#100 cen=1;
#35 cen=0;
#3000 rd=1;wr=0;address=12'b111010111010;
#15000 rd=1;wr=0;address=12'b011011001010;
#2000 rd=1;wr=0;address=12'b101100101010;
#2500 rd=1;wr=0;address=12'b101110111010;
#3000 rd=1;wr=0;address=12'b111010101010;
#2000 $finish;
end
endmodule
