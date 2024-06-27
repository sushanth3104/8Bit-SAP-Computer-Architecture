`timescale 1ns/1ps
`include "IR.v"

module tb;

    reg [7:0]BusIn;
    reg  clk,rst,IRIn,IROut;
    wire [3:0]BusOut,CUIn;

    IR dut(BusIn,clk,rst,IRIn,IROut,BusOut,CUIn);

always #5 clk = ~clk ; 

initial begin
    {BusIn,clk,rst,IRIn,IROut} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #100 $finish ; 

end

initial begin

    #7;
    rst <= 1;

    #5;
    rst <= 0;

    #1;
    BusIn <= 8'b0011_0101;
    
    #1;
    IRIn <= 1;
    
    #3;
    IRIn <= 0;

    #4;
    IROut <= 1;
    

end


endmodule

