`timescale 1ns/1ps
module De_Mod (
    clk, reset, inx, iny, fft_en, en, out
);
    input clk;
    input reset;
    input signed [15:0] inx;
    input signed [15:0] iny;
    input fft_en;


    output reg en;
    output reg[1:0] out;

    reg esig;
    reg cnt;

    always @(posedge clk) begin
        if (reset) 
        begin
            out <= 0;
            cnt <= 0;
            esig <= 0;
        end
        else if(fft_en)
        begin
            if (inx > 0)
                begin
                    if (iny > 0)
                        out <= 00;
                    else
                        out <= 11;
                end
            else
                begin
                    if (iny > 0)
                        out <= 01;
                    else
                        out <= 10;
                end
            en <= 1;
        end
        else
        begin
            en <= 0;
            out <= 0;
        end
    end
endmodule