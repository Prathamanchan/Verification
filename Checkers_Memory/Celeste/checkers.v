 module check(cen,clk,din,add,rst,rd,wr,dout);
 input wire [7:0]din;
 input wire [7:0] dout;
 reg [7:0]dt;
 input wire [11:0]add;
 input wire clk,cen,rst,wr,rd;
 reg [7:0]out;   
 real vdd,vss;
 reg [7:0]temp_din;
 reg [11:0]temp_add;
 reg [7:0]vir_mem[0:3][0:1023]; 
 integer i,j;
 reg status,crk;
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
   out<=vir_mem[address[11:10]][address[9:0]];
   else
   begin
   out<=8'bxx;
   $display("FAIL: Time=%2d Address=%d Data=%d Read Failed", $time,address,out);
   end
   status=0;
   $display("");
 end
 endtask

 function [7:0] write;  //write
 input [11:0]address;
 input [7:0]datain;
 begin
   vir_mem[address[11:10]][address[9:0]] = datain;
   if(status==0)
   write<=vir_mem[address[11:10]][address[9:0]];
   else
   write<=8'bxx;
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
 dt<=write(temp_add,temp_din);
 else 
 dt<=write(temp_add,8'bx);
 $display("INFO:Time=%2d Address=%d Data=%d",$time,temp_add, temp_din);
 $display("");
 status=0;
 end

 always@(status_rd)//or negedge status_rd)
 begin
 if(status==0)
 begin
 temp_add=add;
 read(temp_add);

 $display("INFO:Time=%2d Address=%d Dout=%d Vout=%d",$time,temp_add,dout,out);
 $display("");
 if(dout==out)
 $display("PASS: Time=%2d Read Successful",$time);
 else
 $display("FAIL: Time=%2d Read not successful",$time);
 end
 else
 out=8'bxx;
 status=0;
 $display("");
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
       vir_mem[i][j]<=8'b0;
   end
  end
 end
 else
 out=0;
 //$display("the device is nt working");
 end
 //always@(posedge clk)
 //begin
 //if(!cen && !rst && rd && !wr)
 //if(dout==out)
 //$display("Read Successful");
 //else
 //$display("Read Failed");
 //end
 endmodule



