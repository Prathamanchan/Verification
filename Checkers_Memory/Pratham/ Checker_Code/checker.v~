module checker(cen,clk,din,add,rst,rd,wr,dout);
 
 input [7:0]din;
 input [11:0]add;
 input wire clk,cen,rst,wr,rd;
 input [7:0]dout;   
 reg [1:0]bank;
 reg [7:0]wr_chk;
 reg [7:0]vmem[0:3][0:1023]; 
 reg [11:0]temp_address;
 reg [7:0]temp_data;
 reg cenStatus,readStatus,writeStatus,li;
 real vdd,vss,freq;
 integer i,j,timevar;
 reg ck,cck,freqVar;
 reg [7:0]vdout;

 initial
 begin
  readStatus=0;
  writeStatus=0;
  cenStatus=0;
  ck=0;
  cck=0;
  freqVar=0;
  $monitor("INFO: Frequency=%d Hz",freq);
  $monitor("INFO: Cen=%b",cen);
 end


 task read;
  input [11:0]address;
  begin
   ck=1;
   temp_address=address;
   repeat(2)@(posedge clk);
   //vdout=vmem[temp_address[11:10]][temp_address[9:0]];
   vdout<=(cenStatus==0)?vmem[temp_address[11:10]][temp_address[9:0]]:8'bx;
   $display("INFO: Time=%d Address=%d Dout=%d VDout=%d",$time,temp_address,dout,vdout);
   if(dout==vdout)
   $display("PASS:Write Successful");
   else
   $display("FAIL:Write Failed");
   $display("------------------------------------------------------------------------");
   cenStatus=0;
   ck=0;
  end
 endtask

 task write;
  input [11:0]address;
  input [7:0]datain;
  begin 
   temp_address=address;
   temp_data=@(posedge clk)datain;
   vmem[temp_address[11:10]][temp_address[9:0]]=(cenStatus==0)?temp_data:8'bx;
   wr_chk = vmem[temp_address[11:10]][temp_address[9:0]];
   $display("INFO: Time = %d Writing_Data = %d Address = %d",$time,wr_chk,temp_address);
   cenStatus=0;
  end
 endtask

 always@(posedge clk)   //Frequency_Always
 begin
 timevar=$time;
 @(posedge clk)
 timevar=$time-timevar;
 freq=1000000000/(timevar);
 freqVar=(timevar==1000)?1'b0:1'b1;
 //$display("Frequency=%d Hz",freq);
 end

 always@(readStatus)  //Read_Always
 begin   
 read(add);
 end

 always@(writeStatus)  //Write_Always
 begin   
 write(add,din);
 end
 
 always@(posedge cen)
 begin
 cenStatus=(cen==1)?1:0;
 end

 always@(posedge clk)
 begin
  bank=add[11:10];
  if(vdd==1.8 && vss==0 && freqVar==0)
  begin
  if(!cen && !rst && rd && !wr)
  begin
  cck=~cck;
  readStatus=~readStatus;
  @(posedge clk)
  li=0;
  end
  if(!cen && !rst && !rd && wr)
  begin
  writeStatus=~writeStatus;
  end

  if(rst)                        //Reset
  for(i=0;i<4;i=i+1)
   begin
     //$display("Resets ");
     for(j=0;j<1024;j=j+1)
        vmem[i][j]<=8'b0;
   end  //for
  end //if
//  else
//  vdout=0;
  if(cen && ck==0)
  vdout=0;
  if(cen && ck==1)
  vdout=8'bx;
 end
endmodule



