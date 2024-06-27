`timescale 1ns/1ps
`include "Accumulator.v"

module tb;

reg [7:0]BusIn;
reg clk,rst,Ain,ALowerIn,Aout;
wire [7:0] BusOut, ALUIn ;

Accumulator dut(BusIn,clk,rst,Ain,ALowerIn,Aout,BusOut,ALUIn);

always #5 clk = ~clk ; 

initial begin

{BusIn,clk,Ain,Aout,rst} = 0;
$dumpfile("output.vcd");
$dumpvars(0,tb);

#100 $finish ; 

end

initial begin

    #12 ;
    rst <= 1;

    #5;
    rst <= 0;

    #2;
    BusIn <= 8'b0101_1100;

    #3;
    Ain <= 1;

    #10;
    Ain <= 0;

    #2;
    Aout <= 1;
    
    #5;
    Aout <= 0;

    #5;
    rst <= 1;

    #3;
    rst <= 0;

    #3;
    BusIn <= 8'b1101_1110;

    #2;
    ALowerIn <= 1;

    #10;
    ALowerIn <= 0;

    #2;
    Aout <= 1;


end



endmodule