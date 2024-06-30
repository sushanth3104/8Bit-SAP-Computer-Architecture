`timescale 1ns/1ps

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