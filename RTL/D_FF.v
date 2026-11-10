
`timescale 10ns / 1ns

module D_FF (d, rstn, clk, q);

input d, rstn, clk;
output reg q;

always @(posedge clk or negedge rstn)
begin
    if (~rstn)
        q <= 0;
    else
        q <= d;
end

endmodule
