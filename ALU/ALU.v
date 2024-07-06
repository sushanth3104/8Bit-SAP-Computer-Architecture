`timescale 1ns/1ps

`define ALU_ADD 2'b00
`define ALU_SUB 2'b01
`define ALU_INC 2'b10
`define ALU_DCR 2'b11


module ALU(
    input [7:0]Accumulator,BRegister,
    input [1:0]Operation,
    input ALUOut,AluStart
    output [7:0]BusOut,
    output [1:0]Flags
);

reg [8:0]result;

always@(*) begin
    if(AluStart == 1'b1) begin
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