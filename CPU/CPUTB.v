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
    #100000 $finish ;     // Change According to the needs
end

initial begin

rst <= 1 ; 
#17;
rst <= 0 ;

end


endmodule