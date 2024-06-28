`timescale 1ns/1ps

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
