`timescale 1ns/1ps

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