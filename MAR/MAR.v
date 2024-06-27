`timescale 1ns/1ps

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