`timescale 1ns/1ps
`include "ALU.v"

module tb;

    reg [7:0]Accumulator,BRegister;
    reg [1:0]Operation;
    reg ALUOut;
    wire [7:0]BusOut;
    wire [1:0]Flags;

    ALU dut(Accumulator,BRegister,Operation,ALUOut,BusOut,Flags);

    initial begin
        {Accumulator,BRegister,Operation,ALUOut} <= 0;
        $dumpfile("output.vcd");
        $dumpvars(0,tb);
        #100 $finish ; 

    end


    initial begin
    #5;
    Accumulator <= 6;
    BRegister   <= 2;
    Operation <= 0;
    #2;
    ALUOut    <= 1;
    #2
    ALUOut   <= 0;
    #2;
    Operation <= 1;
        #2;
    ALUOut    <= 1;
    #2
    ALUOut   <= 0;
    #2;
    Operation <= 2;
        #2;
    ALUOut    <= 1;
    #2
    ALUOut   <= 0;
    #2;
    Operation <= 3;
    ALUOut    <= 1;
    #2
    ALUOut   <= 0;
    
end



endmodule