`timescale 1ns/1ps

module slave(sda,scl);
 input scl;
 inout sda;

 parameter start=3'b000,addr=3'b001,iaddr=3'b010,write=3'b011,read=3'b100,nack=3'b101;
 parameter tsu_sta=600,thd_sta=600,thd_dat=0,tsu_dat=100,tsu_sto=600,t_high=1200,t_low=1300;

 reg [7:0]internalreg;
 reg [7:0]address;
 reg [7:0]iregl;
 reg [7:0]data;
 reg [7:0]mem[0:255];
 reg [2:0] state=start;
 reg [2:0] nxt_state=start;
 reg [6:0]slave_add=7'b1100110;
 reg ack; 
 reg temp1,temp2;
 reg [7:0]mempointer;
 reg [7:0]temp_data;
 reg sda_wr;
 reg scond;
 reg debug;
 reg rdw;                 //Read or Write
 reg [7:0]temp_add;
 reg rs;
 reg scheck=1'b0;
  
 integer a,i,j,k;
 

initial
 begin 
 sda_wr=1'b1; 
 scond=1'b0;
 end

assign sda=(scond==1'b1)?sda_wr:1'bz;

always@(posedge scl)    //START and STOP Analyzer
 begin
  #1 temp1=sda;
  #(t_high-thd_sta); 
  #2 temp2=sda;

  if(temp1!=temp2)
  begin
  if(temp1==1'b1)
  begin
  state=addr;
  nxt_state=addr;
  scheck=~scheck;
  end
  if(temp1==1'b1 && rs==1'b1)
  begin
  nxt_state=addr;
  state=addr; 
  disable MAIN; 
  scheck=~scheck;
  end
  if(temp1==1'b0)
  state=start;
 end
 end

always@(posedge scond)
 begin:SCOND
  if(rdw==1'b0)
  begin
  @(negedge scl);
  #(t_low/2) scond=1'b0;
  end 
 end



always @(posedge scl) 
 begin:MAIN
  state=nxt_state;
  
  case(state)
 start:begin
       rs=0;
       address=0;
       #thd_sta;
       #10;
     
         if(sda==1'b0)
         nxt_state=addr;
       end
      

  addr:  begin                 //address of slave is compared and next state is transmitted
         address[7]=sda; 
         for(a=6;a>=0;a=a-1)
         begin
          @(posedge scl);
          #thd_sta;         //600   
          address[a]=sda;         
         end
         
         if(slave_add[6:0]==address[7:1])
         begin
          @(negedge scl)
          #(t_low/2);      //1300/2=650 
          #2 scond=1'b1;                                                       
          #20 sda_wr=1'b0;  //ACK

          if(rs==1'b0)
          begin
           nxt_state=iaddr;
           @(negedge scl)
           #(t_low/2) scond=1'b0;
          end
          else
           nxt_state=read;                            
         end
         else
         nxt_state=nack;
         end

iaddr:   begin                    //internal address is accepted and read or write is checked
          
          #thd_sta mempointer[7]=sda;                              
          for(i=6;i>=0;i=i-1)                     
          begin
          @(posedge scl); 
          #thd_sta mempointer[i]=sda;           
          end
        
         if(mempointer<=8'b11111111)                     
         begin
         @(negedge scl)
         #(t_low/2);     //ACK
         #2 scond=1'b1;
         #20;
         sda_wr=1'b0; 
         internalreg=mempointer;
	 
          if(address[0]==1'b1)               
	  begin
          nxt_state=read; 
	  end
         
         else  
          begin
          nxt_state=write;
         @(negedge scl)
         #(t_low/2) scond=1'b0; 
          end
         end

         else
          nxt_state=nack;
         end
       

write:   begin                               //data is accepted 
         rdw=1'b0;
         rs=1'b1;
         #thd_sta temp_data[7]=sda; 
         
         for(j=6;j>=0;j=j-1)
         begin
         @(posedge scl);
         rs=1'b0;
         #thd_sta temp_data[j]=sda; 							 
         end
         mem[mempointer]=temp_data;
         @(negedge scl)
         #(t_low/2);
         #2 scond=1'b1;     
         #20 ack=1'b0;   
         @(negedge scl)
         #(t_low/2) scond=1'b0;           							
         sda_wr=ack; 
         nxt_state=start;             					
         end


read:    begin                                   //data is being transmitted
         rdw=1'b1;
         disable SCOND;
         scond=1'b1;
         
         for(k=7;k>=0;k=k-1)
         begin
         @(negedge scl);
         scond=1'b1;
         #(t_low-tsu_sta);  
         sda_wr=mem[mempointer][k];  
      	 end
         
         @(negedge scl)
         #(t_low/2);   
         sda_wr=1'b1;              //release sda_wr
         scond=1'b0;
         nxt_state=start;
         if(sda==1'b0)
         begin
         nxt_state=nack;
         end
         end

nack:    begin
         sda_wr=1'b1;
        
         end


										
default:
begin 

sda_wr=1'b1;
end

endcase

end
endmodule




