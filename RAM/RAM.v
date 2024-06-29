`timescale 1ns/1ps

module RAM(
    input [7:0]BusIn,
    input [3:0]Addrs,
    input clk,RAMOut,RAMIn,
    output [7:0]BusOut
);

reg [7:0]temp[15:0];
reg [7:0]temp_out;

initial begin
    $readmemh("./Instructions.txt",temp,0,15);
end

always @(posedge clk or Addrs)
begin
    if (RAMIn == 1'b1)
    temp[Addrs] <= BusIn ;
    else 
    temp_out <= temp[Addrs];
end

assign BusOut = RAMOut ? temp_out : 8'bzzzz_zzzz ;


endmodule