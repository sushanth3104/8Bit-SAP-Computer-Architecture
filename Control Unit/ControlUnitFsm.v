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
`define LDI  4'b1010
`define OUT  4'b1011
`define HLT  4'b1100


module controlunit(
    input [3:0]opcode,
    input [1:0]flagReg,
    input clk,rst,
    output [16:0]ControlSignal
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
parameter jmpz2 = 21

// Jump if Carry States
parameter jmpc1 = 22;
parameter jmpc2 = 23;

// Load Immediate States
parameter ldi1 = 24;



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
    fetch1 : temp <= 17'b0_0000_0000_0100_1000;
    fetch2 : temp <= 17'b0_0000_0001_0001_0010;

    lda1   : temp <= 17'b0_0000_0000_1100_0000;
    lda2   : temp <= 17'b0_0001_0000_0000_0010;

    add1   : temp <= 17'b0_0000_0000_1100_0000;
    add2   : temp <= 17'b0_0000_0010_0000_0010;
    add3   : temp <= 17'b0_1001_0000_0000_0000;

    sub1   : temp <= 17'b0_0000_0000_1100_0000;
    sub2   : temp <= 17'b0_0010_0010_0000_0010;
    sub3   : temp <= 17'b0_1001_0000_0000_0000;

    out    : temp <= 17'b0_0000_0100_0010_0000;

    hlt1   : temp <= 17'b0_0000_0000_0000_0000;

    inc1   : temp <= 17'b0_0100_0000_0000_0000;
    inc2   : temp <= 17'b0_1001_0000_0000_0000;

    dec1   : temp <= 17'b0_0110_0000_0000_0000;
    dec2   : temp <= 17'b0_1001_0000_0000_0000;

    sta1   : temp <= 17'b0_0000_0000_1100_0000;
    sta2   : temp <= 17'b0_0000_0100_0000_0001;

    jmp1   : temp <= 17'b0_0000_0000_1000_0100;

    jmpz1  : temp <= 17'b1_0000_0000_0000_0000;
    jmpz2  : temp <= 17'b0_0000_0000_1000_0100;

    jmpc1  : temp <= 17'b1_0000_0000_0000_0000;
    jmpc2  : temp <= 17'b0_0000_0000_1000_0100;

    ldi1   : temp <= 17'b0_0000_1000_1000_0000;

    default : temp <= 0;

    endcase

end



always @(state,opcode)begin
    case(state)
    idle : begin
        nstate = fetch1 ;
    end
    fetch1 : begin
        nstate = fetch2 ;
    end
    fetch2 : begin
        case(opcode)
        `LDA : nstate = lda1 ;
        `ADD : nstate = add1 ;
        `SUB : nstate = sub1 ;
        `OUT : nstate = out ;
        `HLT : nstate = hlt ;
        `STA : nstate = sta1;
        `INCA: nstate = inc1;
        `DECR: nstate = dec1;
        `JMP : nstate = jmp1 ;
        `JMPZ: nstate = jmpz1;
        `JMPC: nstate = jmpc1;
        `NOP : nstate = fetch1;
        `LDI : nstate = ldi1 ;
        default: nstate = idle;
       endcase

    end
    lda1 : begin
        nstate = lda2 ;

    end
    lda2 : begin
        nstate = fetch1 ;
    end
    add1 : begin
        nstate = add2;

    end
    add2 : begin
        nstate = add3 ;

    end
    add3 : begin
        nstate = fetch1;
    end
    sub1 : begin
        nstate = sub2;
    end
    sub2 : begin
        nstate = sub3 ;
    end
    sub3 : begin
        nstate = fetch1;
    end

    out : begin
        nstate = fetch1;
    end

    hlt1 : begin
        nstate = hlt1 ;
    end

    sta1 : begin
        nstate = sta2;
    end
    sta2 : begin
        nstate = fetch1;
    end

    inc1 : begin 
        nstate = inc2 ;
    end
    inc2 : begin
        nstate = fetch1;
    end

    dec1 : begin
        nstate = dec2 ;
    end
    dec2 : begin
        nstate = fetch1;
    end

    jmp1 : begin
        nstate = fetch1 ;
    end
    jmpz1: begin
        if(flagReg[1] == 1'b1)
        nstate = jmpz2;
        else
        nstate = fetch1 ;
    end

    jmpz2 : begin
        nstate = fetch1;
    end
    jmpc1: begin
        if(flagReg[0] == 1'b1)
        nstate = jmpc2;
        else
        nstate = fetch1 ;
    end
    jmpc2 : begin
        nstate = fetch1;
    end
    
    ldi1 : begin
        nstate = fetch1;

    end

    default : nstate = idle ;

    endcase
    
end

assign ControlSignal = temp ;



endmodule
