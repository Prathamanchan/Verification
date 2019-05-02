`timescale 1ns/1ps

module mem_chkr(dout,din,cen,clk,rst,add,rd,wr);
 input wire cen,clk,rst,rd,wr;
 input wire [7:0]din;
 input wire [11:0]add;
input [7:0]dout;
reg [7:0]data_out;
real vdd,vss;
reg [7:0]virtual_mem[0:3][0:1023];
integer i,j;
reg [11:0]tempadd;
reg [7:0]tempdata;
reg [7:0]wr_chk;
reg read;
reg write;
integer timep1,timep2,t;
//mem_top uut(.cen(cen),.clk(clk),.din(din),.add(add),.rst(rst),.rd(rd),.wr(wr),.dout(dout));

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
data_out=8'bxx;
end
if(rst)
	begin
		for(i=0;i<4;i=i+1)
		begin
		for(j=0;j<1024;j=j+1)
		begin
		  virtual_mem[i][j]=0;
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
virtual_mem[tempadd[11:10]][tempadd[9:0]]= @(posedge clk) din[7:0];
wr_chk[7:0]=virtual_mem[tempadd[11:10]][tempadd[9:0]];
$display("INFO:Time=%2d Address=%d Data=%d",$time,tempadd,tempdata);
$display("PASS:Time=%2d WRITE SUCCESSFUL",$time);
$display("------------------------------------");
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

	//tempdata[7:0]= @(posedge clk) mem[tempadd[11:10]][tempadd[9:0]];
	repeat(2) @(posedge clk);	
	data_out[7:0]=virtual_mem[tempadd[11:10]][tempadd[9:0]];
$display("INFO:Time=%2d Address=%d data_out=%d",$time,tempadd,data_out);
$display("------------------------------------------------------------");

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
$display("SUPPLY or clock is not fine");
$display("---------------------------");
end

always@(posedge clk)
begin
if(rd && !wr && !cen && !rst)
begin
if(dout==data_out)
$display("PASS: Time=%2d Read successful",$time);
$display("------------------------------------");
end
else
$display("FAIL: Time=%2d Read unsuccessful",$time);
$display("--------------------------------------");
end

endmodule
