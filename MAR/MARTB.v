`include "MAR.v"
`timescale 1ns/1ps

module tb;

reg [3:0]BusIn;
reg clk,rst,MARIn;
wire [3:0] RAMIn;

MAR dut(BusIn,clk,rst,MARIn,RAMIn);

always #5 clk = ~clk ; 

initial begin
    {BusIn,rst,clk} <= 0 ;
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #100 $finish ; 

end

initial begin

#12;
rst  <= 1;

#8 ;
rst <= 0;

#1;
BusIn <= 4'b0101;

#2;
MARIn <= 1;

#5;
MARIn <= 0;


end
 
endmodule