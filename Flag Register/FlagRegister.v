`timescale 1ns/1ps

module FlagRegister(
    input [1:0]FlagsIn,
    input clk,
    output [1:0]FlagOut 
);

reg [1:0]temp;

always @(posedge clk ) begin
    temp <= FlagsIn ;
end
assign FlagOut = temp;


endmodule