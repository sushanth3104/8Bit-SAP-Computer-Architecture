`timescale 1ns/1ps
`include "BRegister.v"

module tb;

    reg [7:0]BusIn ;
    reg clk,rst,Bin ;
    wire [7:0]ALUIn;

    BRegister dut(BusIn,clk,rst,Bin,ALUIn);

always #5 clk = ~clk ; 

initial begin

{BusIn,clk,Bin,rst} = 0;
$dumpfile("output.vcd");
$dumpvars(0,tb);

#100 $finish ; 

end

initial begin

    #12;
    rst <= 1;

    #7;
    rst <= 0;

    #1;
    BusIn <= 8'b0011_1010;
    
    #3;
    Bin <= 1;

    #11;
    rst <= 1;

    #4;
    rst <= 0;

end


endmodule