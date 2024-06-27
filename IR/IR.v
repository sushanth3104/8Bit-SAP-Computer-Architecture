`timescale 1ns/1ps

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