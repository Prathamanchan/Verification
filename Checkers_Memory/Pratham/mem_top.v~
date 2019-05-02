module mem_top(cen,clk,din,add,rst,rd,wr,dout);
 
 input [7:0]din;
 input [11:0]add;
 input clk,cen,rst,wr,rd;
 output reg [7:0]dout;   
 reg [1:0]bank;
 reg [7:0]wr_chk;
 reg [7:0]memory[0:3][0:1023]; 
 reg [11:0]temp_address;
 reg [7:0]temp_data;
 reg cenStatus,readStatus,writeStatus,li;
 real vdd,vss,freq;
 integer i,j,timevar;
 reg ck,cck,freqVar;

 initial
 begin
  readStatus=0;
  writeStatus=0;
  cenStatus=0;
  ck=0;
  cck=0;
  freqVar=0;
 end


 task read;
  input [11:0]address;
  begin
   temp_address=address;
   repeat(2)@(posedge clk);
   dout=(cenStatus==0)?memory[temp_address[11:10]][temp_address[9:0]]:8'bx;
   //#0 dout=(cenStatus==0)?dout:8'bx;
   cenStatus=0;
  end
 endtask

 task write;
  input [11:0]address;
  input [7:0]datain;
  begin 
   temp_address=address;
   temp_data=@(posedge clk)datain;
   memory[temp_address[11:10]][temp_address[9:0]]=(cenStatus==0)?temp_data:8'bx;
   wr_chk = memory[temp_address[11:10]][temp_address[9:0]];
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
 $display("Frequency=%d Hz",freq);
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
  ck=~ck;
  bank=add[11:10];
  if(vdd==1.8 && vss==0 && freqVar==0)// && timevar==1000)
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
     $display("Resets ");
     for(j=0;j<1024;j=j+1)
        memory[i][j]<=8'b0;
   end  //for
  end //if
  else
  dout=0;
  if(cen)
  dout=0;
 end
endmodule



