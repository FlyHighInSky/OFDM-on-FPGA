`timescale 1ns/1ps
`default_nettype none

module tb_ofdm();
reg clk;
reg reset;
reg [3:0] inputdata;
reg in;

reg [3:0] out_count;
wire esig;
wire [3:0] out;

reg eesig;

OFDM ofdm1(
    .reset (reset),
    .clk (clk),
    .x_in(in),
    .x_out(out)
    );

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

integer i;

initial begin
    reset = 1;
    clk = 1;
    i = 0;
    # 100 reset = 0;
end

always @(posedge clk)
if(reset)begin
    eesig <= 0;
    out_count <= 0;
    inputdata <= 4'b0110;
end
else
begin
    if(i < 4)
    begin
        in = inputdata[i];
        i = i + 1;
    end
    else
    begin
        in = inputdata[0];
        i = 1;
    end
end

endmodule
`default_nettype wire