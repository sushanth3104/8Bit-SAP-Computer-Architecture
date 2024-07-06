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

`define ALU_ADD 2'b00
`define ALU_SUB 2'b01
`define ALU_INC 2'b10
`define ALU_DCR 2'b11



module CPU(
    input rst,clk

);

wire [7:0]Bus,AccumulatorToAlu,BRegisterToALU,Finaloutput;
wire [3:0]MarToRam,IrToCu;
wire [17:0]CS;
wire [1:0]FlagToCU,AluFlagToFlagReg;

PC dutPC(Bus[3:0], clk,rst,CS[4],CS[3],CS[2],Bus[3:0]);
Accumulator dutAcc(Bus,clk,rst,CS[12],CS[11],CS[10],Bus,AccumulatorToAlu);
MAR dutMar(Bus[3:0],clk,rst,CS[6],MarToRam);
ALU dutALU(AccumulatorToAlu,BRegisterToALU,{CS[14],CS[13]},CS[15],CS[17],Bus,AluFlagToFlagReg);
RAM dutRAM(Bus,MarToRam,clk,CS[1],CS[0],Bus);
BRegister dutBReg(Bus,clk,rst,CS[9],BRegisterToALU);
IR dutReg(Bus,clk,rst,CS[8],CS[7],Bus[3:0],IrToCu);
OutputReg dutOutputReg(Bus,clk,rst,CS[5],Finaloutput);
controlunit dutCU(IrToCu,FlagToCU,clk,rst,CS);
FlagRegister dutFlagReg(AluFlagToFlagReg,CS[17],CS[16],clk,FlagToCU);


endmodule



module controlunit(
    input [3:0]opcode,
    input [1:0]flagReg,
    input clk,rst,
    output [17:0]ControlSignal
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
parameter jmpz2 = 21;

// Jump if Carry States
parameter jmpc1 = 22;
parameter jmpc2 = 23;

// Load Immediate States
parameter ldi1 = 24;



reg [17:0]temp ;

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
    fetch1 : temp <= 18'h00048;
    fetch2 : temp <= 18'h00112;

    lda1   : temp <= 18'h000C0;
    lda2   : temp <= 18'h01002;

    add1   : temp <= 18'h000C0;
    add2   : temp <= 18'h20202;
    add3   : temp <= 18'h09000;

    sub1   : temp <= 18'h000C0;
    sub2   : temp <= 18'h22202;
    sub3   : temp <= 18'h09000;

    out    : temp <= 18'h00420;

    hlt1   : temp <= 18'h00000;

    inc1   : temp <= 18'h24000;
    inc2   : temp <= 18'h09000;

    dec1   : temp <= 18'h26000;
    dec2   : temp <= 18'h09000;

    sta1   : temp <= 18'h000C0;
    sta2   : temp <= 18'h00401;

    jmp1   : temp <= 18'h00084;

    jmpz1  : temp <= 18'h10000;
    jmpz2  : temp <= 18'h00084;

    jmpc1  : temp <= 18'h10000;
    jmpc2  : temp <= 18'h00084;

    ldi1   : temp <= 18'h00880;

    default : temp <= 0;

    endcase

end



always @(state,opcode,flagReg)begin
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
        `HLT : nstate = hlt1 ;
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
        if(rst == 1'b1)
        nstate = idle;
        else 
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



module FlagRegister(
    input [1:0]FlagsIn,
    input FlagEnable,
    input FlagOutEnable,
    input clk,
    output [1:0]FlagOut 
);

reg [1:0]temp;

always @(posedge clk ) begin
    if(FlagEnable ==1'b1)
    temp <= FlagsIn ;
end
assign FlagOut = FlagOutEnable ? temp: 2'bzz;


endmodule



module IR(
    input [7:0]BusIn,
    input clk,rst,IRIn,IROut,
    output [3:0]BusOut,CUIn
);

reg [7:0]temp;

always @(posedge clk or rst) begin

    if (rst == 1'b1)
    temp <= 8'b0000_0000;
    else if( IRIn == 1'b1)
    temp <= BusIn ;
end

assign CUIn = temp[7:4];
assign BusOut = IROut? temp[3:0] : 4'bzzzz ;


endmodule

module MAR(
    input [3:0]BusIn,
    input clk,rst,MARIn,
    output [3:0]RAMIn
);

reg [3:0]temp;

always @(posedge clk or rst ) begin

    if (rst == 1'b1)
    temp <= 4'b0000;
    else if (MARIn == 1'b1)
    temp <= BusIn ;
  
end


    assign RAMIn = temp ;

endmodule


module BRegister(
    input [7:0]BusIn,
    input clk,rst,Bin,
    output [7:0]ALUIn
);

reg [7:0]temp;

always @(posedge clk or rst) begin
    if (rst == 1'b1)
    temp <= 8'b0000_0000;
    else if( Bin == 1'b1)
    temp <= BusIn;
end

assign ALUIn = temp ;



endmodule

module Accumulator(
    input [7:0]BusIn,
    input clk,rst,Ain,ALowerIn,Aout,
    output [7:0]BusOut,ALUIn
);

reg [7:0]temp;
always @(posedge clk,rst) begin
    if(rst == 1'b1)
    temp <= 8'b0000_0000;
    else if (Ain == 1'b1)
    temp <= BusIn ;
    else if (ALowerIn == 1'b1)
    temp <= {4'b0000,BusIn[3:0]};

end

assign BusOut = Aout ? temp : 8'bzzzz_zzzz;
assign ALUIn  = temp ; 
    

endmodule




module RAM(
    input [7:0]BusIn,
    input [3:0]Addrs,
    input clk,RAMOut,RAMIn,
    output [7:0]BusOut
);

reg [7:0]temp[15:0];
reg [7:0]temp_out;

initial begin
    $readmemh("./Instructions.txt",temp,0,15);
end

always @(posedge clk or Addrs)
begin
    if (RAMIn == 1'b1)
    temp[Addrs] <= BusIn ;
    else 
    temp_out <= temp[Addrs];
end

assign BusOut = RAMOut ? temp_out : 8'bzzzz_zzzz ;


endmodule



module PC(
    input [3:0]BusIn,
    input clk,rst,PCInc,PCOut,PCIn,
    output [3:0]BusOut
);

reg [3:0]temp;

always @(posedge clk or rst) begin

    if(rst ==1'b1)
    temp <= 4'b0000;
    else if(PCInc == 1'b1)
    temp <= temp + 1;
    else if(PCIn == 1'b1)
    temp <= BusIn;

end

assign BusOut = PCOut ? temp : 4'bzzzz;



endmodule 





module ALU(
    input [7:0]Accumulator,BRegister,
    input [1:0]Operation,
    input ALUOut,AluStart,
    output [7:0]BusOut,
    output [1:0]Flags
);

reg [8:0]result;
 
always @(*)begin

    if(AluStart == 1'b1)
    begin
    case(Operation) 
    `ALU_ADD : result <= Accumulator + BRegister ;
    `ALU_SUB : result <= Accumulator - BRegister ;
    `ALU_INC : result <= Accumulator + 1 ;
    `ALU_DCR : result <= Accumulator - 1 ;
    default : result <= result ;

    endcase


    end

end


assign BusOut = ALUOut ? result[7:0] : 8'bzzzz_zzzz;
assign Flags = {~|result[7:0],result[8]};  // Zero,Carry


endmodule



module OutputReg(
    input [7:0]BusIn,
    input clk,rst,OutLoad,
    output [7:0]Out
);

reg [7:0]temp;

always @(posedge clk or rst) begin

    if( rst == 1'b1 )
    temp <= 8'b0000_0000;
    else if(OutLoad ==1'b1)
    temp <= BusIn ;
    
end

assign Out = temp ;


endmodule
