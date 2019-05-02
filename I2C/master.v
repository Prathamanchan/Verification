`timescale 1ns/1ps

 module master(sda,scl);

 inout sda;
 output reg scl;

 reg [7:0]internalreg;
 reg sda_wr;
 reg [7:0]address;
 reg [6:0]slave_add=7'b1100110;
 reg [7:0]rxd_data;
 reg [7:0]iregl;
 reg ack;
 reg mcond=1'b0;
 integer i;
 reg rdw;
 parameter NACK=1'b1,ACK=1'b0,wr=1'b0,rd=1'b1;
 parameter tsu_sta=600,thd_sta=600,thd_dat=0,tsu_dat=100,tsu_sto=600,t_high=1200,t_low=1300;

 reg mcheck=1'b0;    //A Debug Variables
 reg mgetcheck=1'b0;
 
 initial    //TB
 begin
 sda_wr=1'b1;
 scl=1'b1;
 end


 always                                     //Standard Clock Generator
  begin:CLOCK
   #t_low scl=1'b1;
   #t_high scl=1'b0;
  end 

 always @(posedge mcond)   //Not For Read operation   //For ACK and Write Operation
 begin:MCOND
 if(rdw==1'b0)
  begin
  @(negedge scl)
  #(t_low/2) mcond=1'b0; 
  end
 end

 assign sda=(mcond==1'b0)?sda_wr:1'bz;
      
        //---------------------------------------------------------------------------------------------------//

 task addressTask;                          //Sends Device Address to sda_wr
   input rw;
   begin 
    mcond=1'b0;
    
    
    address={slave_add,rw};
    for(i=7;i>=0;i=i-1)
    begin
     @(negedge scl);
     
     #(t_low-tsu_dat);                     //1300-100=1200
     sda_wr=address[i];
    end
   end
 endtask



 task get_ack;                                     //Gets the ACK Bit
  begin     
   @(negedge scl)
   
    #(t_low/2);  //650
    sda_wr=1'b1;                                     
    #2 mcond=1'b1;                              //Release the sda_wr Line to Slave after 2ns
    mgetcheck=~mgetcheck;         
   @(posedge scl)               
    #thd_sta;                                //Read The SDA line
    ack=sda;
  end
  endtask

 task send_ack;                                     //Send the ACK Bit
  begin     
   @(negedge scl)
    
    #(t_low/2);      //650                           //Slave should release the line at t_low/2
    #2 mcond=1'b0;
    #20;                                              //Wait for a While :)
    sda_wr=1'b0;   //SEND ACK                        //Release the sda_wr Line to Master by Slave
  end
  endtask


              
 task write_task;                                  //The Ultimate Write Task
  input [7:0]iregl;
  input [7:0]data; 
  begin:WRITE   
   mcond=1'b0;
   rdw=1'b0;
   @(posedge scl)
   
   #(t_high-thd_sta);                               //1200-600=600
   sda_wr=1'b0;                                     //Start Write Operation
   addressTask(1'b0);                                //Coz Write operation
   get_ack;
  
  
   if(ack==NACK)
   begin
    disable WRITE;                                //STOP The Write TASK
   end

   for(i=7;i>=0;i=i-1)                             //Send Internal Register Address
   begin
    @(negedge scl);
    mcheck=~mcheck;
    
    #(t_low-tsu_dat);               //1300-100=1200
    sda_wr=iregl[i];
   end //for
    internalreg=iregl;
    get_ack;
    
   if(ack==NACK)
   begin
    disable WRITE;                                //STOP The Write TASK
   end

    for(i=7;i>=0;i=i-1)                             //Send Data to sda_wr
    begin
     @(negedge scl);
     #(t_low-tsu_sta);             //1300-100=1200
     mcheck=~mcheck;
     sda_wr=data[i];
    end  //for
    get_ack;

   if(ack==NACK)
   begin
    disable WRITE;                               
   end

    @(negedge scl);                             //STOP The Write TASK
    #(t_low-tsu_dat);        //1200
    sda_wr=1'b0;
    @(posedge scl)
    #tsu_sto;              //600
    sda_wr=1'b1; 
   end  //Write
 endtask



  task task_read;
  input [7:0]iregl;
  begin:READ
   mcond=1'b0;
   rdw=1'b1;
   sda_wr=1'b1; 
     
   @(posedge scl)
   #(t_high-thd_sta);
   sda_wr=1'b0;                                       //Start READ  Operation
   addressTask(wr);                                //Coz Write operation First  

   rdw=1'b0;
   get_ack;
   rdw=1'b1;
    
   if(ack==NACK)
   begin
    disable READ;                                //STOP The Write TASK
   end
    
   for(i=7;i>=0;i=i-1)                             //Send Internal Register Address
   begin
    @(negedge scl);
    #(t_low-tsu_dat);
    sda_wr=iregl[i];
   end //for

   rdw=1'b0;
   get_ack;
   rdw=1'b1;

   if(ack==NACK)
   begin
    disable READ;                                //STOP The Write TASK
   end


   @(negedge scl)
   #(t_low-tsu_dat);
    sda_wr=1'b1;
   @(posedge scl)
    #(t_high-thd_sta);
    sda_wr=1'b0;                                      //Repeat Start
   addressTask(1'b1);
   
   rdw=1'b0;
   get_ack;
   rdw=1'b1;
   
   if(ack==NACK)
   begin
    disable READ;                                //STOP The Write TASK
   end
   disable MCOND;
   mcond=1'b1;
   for(i=7;i>=0;i=i-1)                             //Receive Data from Slave
   begin
    @(posedge scl);
    mcond=1'b1;
    #thd_dat;
    rxd_data[i]=sda;
   end
   send_ack;

    @(negedge scl);
    #(t_low-tsu_dat);   //1200
    sda_wr=1'b0;
    @(posedge scl)
    #tsu_sto;            //600
    sda_wr=1'b1; 
   end  //Read
 endtask

endmodule












































