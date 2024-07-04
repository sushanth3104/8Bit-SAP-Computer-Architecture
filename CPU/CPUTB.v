`timescale 1ns/1ps
`include "CPU.v"

module tb;

reg rst,clk;

CPU dut(rst,clk);

always #5 clk = ~clk ; 

initial begin
    {rst,clk} <= 0; 
    $dumpfile("output.vcd");
    $dumpvars(0,tb);
    #400 $finish ; 
end

initial begin

rst <= 1 ; 
#10;
rst <= 0 ;

end


endmodule