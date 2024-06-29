`timescale 1ns/1ps
`include "RAM.v"

module tb;

reg [7:0]BusIn ;
reg [3:0]Addrs ;
reg clk,RAMOut,RAMIn ;
wire [7:0]BusOut ;
integer i;

RAM dut(BusIn,Addrs,clk,RAMOut,RAMIn,BusOut);

always #5 clk = ~clk ; 

initial begin
    {BusIn,Addrs,clk,RAMOut,RAMIn} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #200 $finish ; 

end

initial begin

// Read Every Memory Word

for(i = 0; i < 16; i ++) begin

    #3;
    RAMOut <= 1;
    Addrs <= i ;
    #3;
    RAMOut <= 0;

    #4;


end

// Write into Memory 

Addrs <= 2;
BusIn <= 9;

#3;
RAMIn <= 1;
#4;
RAMIn <= 0;

#6;
RAMOut <= 1;






end



endmodule