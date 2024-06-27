`timescale 1ns/1ps

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