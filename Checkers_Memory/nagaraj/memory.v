`timescale 1ns/1ps
module memory (cen,clk,din,address,rst,rd,wr,dout);
  input [7:0]din;
  reg [1:0]bank;
  input [11:0]address;
  input clk,cen,rst,wr,rd;
  output reg [7:0]dout;   
  real vdd,vss;
  reg [7:0]memory[3:0][1023:0];
  reg  [7:0]wr_chk;
  integer i,j;
  reg [11:0]temp_address;
  reg [7:0]temp_data;
  reg status;
  reg rbit,wbit;
  integer timep1,timep2,t,freq;
  reg bit;

 initial 
  begin
   status=0;
   rbit=0;
   wbit=0;

  end
 always@(posedge clk)
  begin
   timep1=$time;
    @(posedge clk)
    timep2=$time;
     t=timep2-timep1;
     freq=1000000000/t;
   end

 always@(posedge cen)
  begin
  status=1;
  end   

 always@(rbit)
  begin
//@(posedge clk)
   read(address);
  end

 always@(wbit)
  begin
//@(posedge clk)
   write(address,din); 
  end

  task write;
     input [11:0]address;
     input [7:0]din;
       begin
         //@(posedge clk)
         temp_address=address;
         temp_data=din;
         @(posedge clk)
         memory[temp_address[11:10]][temp_address[9:0]]=(status==0)?temp_data:8'bxx;//whenever cen is high it will shows xx
         wr_chk =memory[temp_address[11:10]][temp_address[9:0]];
         status=0;      
        end
  endtask

  task read;
    input [11:0]address;
      begin
      temp_address=address;
      repeat(2)@(posedge clk);
      dout=(status==0)?memory[temp_address[11:10]][temp_address[9:0]]:8'bx;
      status=0;
      end
  endtask

always@(posedge clk)
begin
if (freq==1000000)
 bit=1;
else bit=0;
end

 always@(posedge clk)
  begin
   
   $display("%d",$time);
    if((vdd-vss)==1.8 && bit==1)
     begin
      $display("device is working fine");
    if(!cen && !rst && !rd && wr)
     begin 
       wbit=~wbit;//it will go to always wbit block
       
     end
  //write(address,din); 
    if(!cen && !rst && rd && !wr) 
      begin  
      rbit=~rbit;//it will go to always rbit block
      repeat(1)@(posedge clk);
      end
    if(rst)
     begin
      for(i=0;i<4;i=i+1) 
       begin
        for(j=0;j<1024;j=j+1)
          memory[i][j]<=8'b0;
      end //for
     end //if
    end //if
     else 
      $display("device is nt working");
 end
endmodule




