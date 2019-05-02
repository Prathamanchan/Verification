`timescale 1ns/1ps

module i2c_top;
 wire sda;
 wire scl;

mastertb uut2(.sda(sda),.scl(scl));
master uut(.sda(sda),.scl(scl));
slave  uut1(.sda(sda),.scl(scl));

endmodule
