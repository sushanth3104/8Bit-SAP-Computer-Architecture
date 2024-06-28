`timescale 1ns/1ps

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