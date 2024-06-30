`timescale 1ns/1ps

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
`define HLT  4'b1111


module controlunit(
    input [3:0]opcode,
    input [1:0]flagReg,
    input clk,rst,
    input [16:0]ControlSignal
);

// Micro Opertions 
parameter idle = 0 ;
// Fetch States
parameter  fetch1 = 1;
parameter  fetch2 = 2; // Internall this state also performs Instruction Decode
                       // Because of Common Bus Architecture
// Load States
parameter  lda1 = 3;
parameter  lda2 = 4;
// Add States
parameter  add1 = 5;
parameter  add2 = 6;
parameter  add3 = 7;
// Subtract States
parameter  sub1 = 8;
parameter  sub2 = 9;
parameter  sub3 = 10;
// Output State
parameter  out  = 11;
// Halt State
parameter  hlt1  = 12;
// Increment States
parameter inc1 = 13;
parameter inc2 = 14;
// Decrement States
parameter dec1 = 15;
parameter dec2 = 16;
// No-Operation State : No additional State is Required : Fetch 1 & 2 are enough

// Store States
parameter sta1 = 17;
parameter sta2 = 18;

// Jump States
parameter jmp1 = 19;

// Jump if Zero States
parameter jmpz1 = 20;

// Jump if Carry States
parameter jmpc1 = 21;


reg [16:0]temp ;

reg [4:0]state,nstate;

always @(negedge clk ) begin
    if(rst == 1'b1)
    state <= idle;
    else
    state <= nstate;
end

always@(state) begin
    case(state)
    idle :   temp <= 0 ;
    fetch1 : temp <= 14'b01000000000001;
    fetch2 : temp <= 14'b00010100000010;
    lda1   : temp <= 14'b01001000000000;
    lda2   : temp <= 14'b00010010000000;
    add1   : temp <= 14'b01001000000000;
    add2   : temp <= 14'b00010000001000;
    add3   : temp <= 14'b00000010100000;
    sub1   : temp <= 14'b01001000000000;
    sub2   : temp <= 14'b00010000011000;
    sub3   : temp <= 14'b00000010100000;
    out    : temp <= 14'b00000001000100;
    hlt1    : temp <= 14'b10000000000000;

    default : temp <= 0;

    endcase

end





endmodule
