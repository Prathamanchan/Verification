`timescale 1ns/1ps

module mastertb;

wire scl;
wire sda;

master  master_uut(.sda(sda),.scl(scl));
slave slave_uut(.sda(sda),.scl(scl));


initial 
begin
$display("Hello TESTBENCH");
master_uut.write_task(8'b11001001,8'b11011011);  
#100000;
master_uut.task_read(8'b11001001);
#100000;
master_uut.write_task(8'b11101001,8'b10010011);  
#100000;
master_uut.task_read(8'b11101001);

#200000 $finish;
end
endmodule
 
