`timescale 1ns/1ps
`include "OutputRegister.v"

module tb;


    reg[7:0]BusIn;
    reg clk,rst,OutLoad;
    wire [7:0]Out;

OutputReg dut(BusIn,clk,rst,OutLoad,Out);

always #5 clk = ~clk ; 

initial begin
    {BusIn,clk,rst,OutLoad} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #100 $finish ; 

end

initial begin

    #2;
    rst <= 1;

    #4;
    rst <= 0;

    #1;
    BusIn <= 8'b0101_1100;

    #2;
    OutLoad <= 1;

    #7;
    BusIn <= 8'b0011_1100;

    #2;
    OutLoad <= 0;

    #6;
    OutLoad <= 1;

    #5;
    OutLoad <= 0;


end

endmodule 