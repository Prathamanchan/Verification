 module mem_top(cen,clk,din,add,rst,rd,wr,dout);
 input [7:0]din;
 reg [7:0]dt;
 input [11:0]add;
 input clk,cen,rst,wr,rd;
 output reg [7:0]dout;   
 real vdd,vss;
 reg [7:0]temp_din;
 reg [11:0]temp_add;
 reg [7:0]memory[0:3][0:1023]; 
 integer i,j;
 reg status;
 reg status_wr;
 reg status_rd;
 integer t1,t2,t,freq;
 reg bit;

 initial begin  //status_check
 status=0;
 status_wr=0;
 status_rd=0;
 end 

 task read; //read
 input [11:0]address;
 begin
   repeat(2)@(posedge clk);
   if(status==0)
   dout=memory[address[11:10]][address[9:0]];
   else
   dout=8'bxx;
   status=0;
 end
 endtask

 function [7:0] write;  //write
 input [11:0]address;
 input [7:0]datain;
 begin
   memory[address[11:10]][address[9:0]] = datain;
   if(status==0)
   write=memory[address[11:10]][address[9:0]];
   else
   write=8'bxx;
   status=0;
 end
 endfunction
 
 always@(posedge cen)  //chip_enable
 begin
 status=1;
 end

 always@(posedge clk) //frequency
 begin
 t1=$time;
 @(posedge clk)
 t2=$time;
 t=t2-t1;
 freq=1000000000/t;
 end
 
 always@(posedge clk)
 begin
 if(freq==1000000) 
 bit=1;
 else
 bit=0;
 end
 
 always@(posedge status_wr or negedge status_wr)
 begin
 temp_din=din;
 temp_add=add;
 @(posedge clk)
 if(status==0)
 dt=write(temp_add,temp_din);
 else 
 dt=write(temp_add,8'bx);
 status=0;
 end

 always@(status_rd)//or negedge status_rd)
 begin
 if(status==0)
 begin
 temp_add=add;
 read(temp_add);
 end
 else 
 dout=8'bxx;
 status=0;
 end
  
 always@(posedge clk)
 begin
 if(vdd==1.8 && vss==0 && bit==1)
 begin
 if(!cen && !rst && rd && !wr)
 begin
   status_rd=~status_rd;
   repeat(1) @(posedge clk);
 end
  if(!cen && !rst && !rd && wr)
 begin
   status_wr=~status_wr;
 end
 if(rst)
 begin
 for(i=0;i<4;i=i+1) 
  begin
   for(j=0;j<1024;j=j+1)
       memory[i][j]<=8'b0;
   end
  end
 end
 else
 begin
 dout=0;
 end
 end
 endmodule



