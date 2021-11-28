`timescale 1ns/1ps
module Mod (
    clk, reset, in, encoder_en, en, outx, outy
);
    input clk;
    input reset;
    input in;
    input encoder_en;

    output reg en;
    output reg signed [15:0] outx;
    output reg signed [15:0] outy;

    reg [1:0] in_data;
    reg esig;
    reg cnt;
    reg[1:0] data_cache;

    always @(posedge clk) begin
        if(reset) begin
            in_data <= 0;
            cnt <= 0;
            esig <= 0;
        end
        else if(encoder_en)
        begin
            if(cnt == 1'b1)
            begin
                data_cache <= {in, in_data[1]};
                cnt <= 0;
                esig <= 1;
            end
            else
            begin
                en <= 0;
                esig <= 0;
                in_data <= {in, in_data[1]};
                cnt <= 1;
            end
        end
        else
        begin
            en <= 0;
            esig <= 0;
        end
    end

    always @(*) begin
        if(esig)
        begin
            case (data_cache)
                2'b00: begin outx <= 1'b1; outy <= 1; end
                2'b01: begin outx <= -1'b1; outy <= 1; end
                2'b10: begin outx <= -1'b1; outy <= -1'b1; end
                2'b11: begin outx <= 1'b1; outy <= -1'b1; end
                default: begin outx <= 0; outy <= 0; end
            endcase
            en <= 1;
        end
    end
endmodule