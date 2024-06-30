`timescale 1ns/1ps

`define LDA  4'b0000
`define STA  4'b0001
`define ADD  4'b0010
`define SUB  4'b0011
`define INCA 4'b0100
`define DECR 4'b0101
`define JMPZ 4'b0110
`define NOP  4'b0111
`define HLT  4'b1111

module controlunit(
    input [3:0]opcode,
    input [1:0]flagReg,
    input clk,rst,
    input [15:0]ControlSignal
);

// Micro Opertions 
parameter idle = 0 ;
parameter  fetch1 = 1;
parameter  fetch2 = 2;
parameter  lda1 = 3;
parameter  lda2 = 4;
parameter  add1 = 5;
parameter  add2 = 6;
parameter  add3 = 7;
parameter  sub1 = 8;
parameter  sub2 = 9;
parameter  sub3 = 10;
parameter  out  = 11;
parameter  hlt1  = 12;

// Add rest of the parameters for remaining instructions





endmodule
