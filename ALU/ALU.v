`timescale 1ns/1ps

`define ADD 2'b00
`define SUB 2'b01
`define INC 2'b10
`define DCR 2'b11


module ALU(
    input [7:0]Accumulator,BRegister,
    input [1:0]Operation,
    input ALUOut,
    output [7:0]BusOut,
    output [1:0]Flags
);

reg [8:0]result;

always@(*) begin

    case(Operation) 
    `ADD : result <= Accumulator + BRegister ;
    `SUB : result <= Accumulator - BRegister ;
    `INC : result <= Accumulator + 1 ;
    `DCR : result <= Accumulator - 1 ;
    default : result <= result ;

    endcase

end

assign BusOut = ALUOut ? result[7:0] : 8'bzzzz_zzzz;
assign Flags = {~|result[7:0],result[8]};  // Zero,Carry


endmodule