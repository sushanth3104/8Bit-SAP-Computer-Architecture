`timescale 1ns/1ps
`include "ControlUnitFsm.v"

`define LDA  4'b0000
`define STA  4'b0001
`define ADD  4'b0010
`define SUB  4'b0011
`define INCA 4'b0100
`define DECR 4'b0101
`define JMPZ 4'b0110
`define NOP  4'b0111
`define JMP  4'b1000
`define JMPC 4'b1001
`define LDI  4'b1010
`define OUT  4'b1011
`define HLT  4'b1100

module tb;

reg [3:0]opcode;
reg [1:0]flagReg;
reg clk,rst;
wire [17:0]ControlSignal;


controlunit dut(opcode,flagReg,clk,rst,ControlSignal);

always #5 clk = ~clk ; 

initial begin
    {opcode,flagReg,clk,rst} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #1000 $finish ; 

end


initial begin

// Reset Logic : Reset signal High : 3 <= t <= 12
// This Resets all the Registers on posedge clk and CU on negedge clk

#3;
rst = 1;
#9;
rst = 0;

end

initial begin

// Opcode Logic : Opcode may change on positive edge of clk in decode/f2 phase of every instruction

#20; // Reset and Idle State
#15; // Fetch1 and Fetch2(Half) states

opcode = `LDA;

#5;  // Fetch2 Completed

#20 // LDA : 2 States 


#15; // Fetch1 and Fetch2(Half) states

opcode = `STA;

#5;  // Fetch2 Completed

#20 // STA : 2 States 

#15; // Fetch1 and Fetch2(Half) states

opcode = `ADD;

#5;  // Fetch2 Completed

#30 // ADD : 3 States

#15; // Fetch1 and Fetch2(Half) states

opcode = `SUB;

#5;  // Fetch2 Completed

#30 // SUB : 3 States

#15; // Fetch1 and Fetch2(Half) states

opcode = `INCA;

#5;  // Fetch2 Completed

#20 // INCA : 2 States 

#15; // Fetch1 and Fetch2(Half) states

opcode = `DECR;

#5;  // Fetch2 Completed

#20 // DECR : 2 States 

// JMPZ : Conditional Jump : Based on Flag Zero
// Testbench : First Without Jump and then With Jump 

#15; // Fetch1 and Fetch2(Half) states

opcode = `JMPZ;

#5;  // Fetch2 Completed

// Flag Zero = 0 : No Jump

#10 // JMPZ : 1 States : No Jump

#15; // Fetch1 and Fetch2(Half) states

opcode = `JMPZ;

#5;  // Fetch2 Completed

#5;  // Flag Out & Flag High

flagReg = 2'b10;

#5; // Decision made : Jumpz to be performed

#10 ; // JMPZ : 1 States : Jump

#15; // Fetch1 and Fetch2(Half) states

opcode = `NOP;

#5;  // Fetch2 Completed

// No Additional State in NOP : Perform next fetch

// JMP : Unconditional Jump 

#15; // Fetch1 and Fetch2(Half) states

opcode = `JMP;

#5;  // Fetch2 Completed

#10 //  JMP : 1-State





// JMPC : Conditional Jump : Based on Flag Carry
// Testbench : First Without Jump and then With Jump 

#15; // Fetch1 and Fetch2(Half) states

opcode = `JMPC;

#5;  // Fetch2 Completed

// Flag Carry = 0 : No Jump

#10 // JMPC : 1 States : No Jump

#15; // Fetch1 and Fetch2(Half) states

opcode = `JMPC;

#5;  // Fetch2 Completed

#5;  // Flag Out & Flag High

flagReg = 2'b11;

#5; // Decision made : Jumpc to be performed

#10 ; // JMPC : 1 States : Jump



#15; // Fetch1 and Fetch2(Half) states

opcode = `LDI;

#5;  // Fetch2 Completed

#10; // LDI : 1-State


#15; // Fetch1 and Fetch2(Half) states

opcode = `OUT;

#5;  // Fetch2 Completed

#10; // OUT : 1-State


#15; // Fetch1 and Fetch2(Half) states

opcode = `HLT;

#5;  // Fetch2 Completed

#10; //  


#20; 
rst <= 1;

#10;
rst <= 0;











end




endmodule