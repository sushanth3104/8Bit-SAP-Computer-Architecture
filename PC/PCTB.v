`timescale 1ns/1ps
`include "PC.v"

module tb;

reg [3:0]BusIn;
reg clk,rst,PCInc,PCOut,PCIn;
wire [3:0]BusOut;

PC dut( BusIn, clk,rst,PCInc,PCOut,PCIn,BusOut);

always #5 clk = ~clk ; 

initial
begin
    {clk,rst,PCInc,PCIn,BusIn} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);

    #200 $finish ;

end

initial begin

    #2;
    rst <= 1;

    #5;
    rst <= 0 ;

    #2;
    BusIn <= 4'b0101;

    #3;
    PCIn <= 1;

    #5;
    PCIn <= 0;

    #2;
    PCInc <= 1 ;

    #20;
    PCInc <= 0 ;

    #2;
    PCOut <= 1;

end

endmodule 