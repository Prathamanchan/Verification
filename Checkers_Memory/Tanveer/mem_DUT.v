`timescale 1ns/1ps

module mem_dut(dout,din,cen,clk,rst,add,rd,wr);
input  [7:0]din;
input [11:0]add;
input cen,clk,rst,rd,wr;
output reg [7:0]dout;
real vdd,vss;
reg [7:0]mem[0:3][0:1023];
integer i,j;
reg [11:0]tempadd;
reg [7:0]tempdata;
reg [7:0]wr_chk;
reg read;
reg write;
integer timep1,timep2,t;

always@(posedge clk)
begin
timep1=$time;
@(posedge clk)
timep2=$time;
t=timep2-timep1;
end




initial
begin
read=0;
write=0;
end

always@(cen or rst)
begin
if(cen)
begin
dout=8'bxx;
end
if(rst)
	begin
		for(i=0;i<4;i=i+1)
		begin
		for(j=0;j<1024;j=j+1)
		begin
		  mem[i][j]=0;
		end
		end
	end
end





always@(write)
begin
//if(!rd && wr && !cen && !rst)
//begin

tempadd[11:0]=add[11:0];
tempdata[7:0]=din[7:0];	
mem[tempadd[11:10]][tempadd[9:0]]= @(posedge clk) din[7:0];
wr_chk[7:0]=mem[tempadd[11:10]][tempadd[9:0]];
//if(cen)
	//dout=8'bxx;
//end
end

always@(read)
begin
//if(rd && !wr && !cen && !rst)
//begin 
//@(posedge clk)
	tempadd[11:0]=add[11:0];
	@(posedge clk)
	//tempdata[7:0]= @(posedge clk) mem[tempadd[11:10]][tempadd[9:0]];
		
	dout[7:0]=@(posedge clk) mem[tempadd[11:10]][tempadd[9:0]];

end

always@(posedge clk)
begin
if((vdd-vss)==1.8 && t==1000)
begin
if(rd)
begin
read=~read;
//repeat(0) @(posedge clk);
end
if(wr)
begin
write=~write;
end
end
else
$display("NOT WORKING");
end

endmodule
