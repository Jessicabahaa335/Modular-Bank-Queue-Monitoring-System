
`timescale 10ns / 1ns

module waitTime_rom (addr, data);

input [4:0] addr;
output [7:0] data;

reg [7:0] arom [0:31];

initial
    $readmemb("waitTime_rom.txt", arom);

assign data = arom[addr];

endmodule
