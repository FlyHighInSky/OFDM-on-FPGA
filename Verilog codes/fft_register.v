`timescale 1ns/1ps
module FFT_Register (
    clk, reset, inx, iny, mod_en, out_en, outx, outy
);
    input clk;
    input reset;
    input signed [15:0] inx;
    input signed [15:0] iny;
    input mod_en;

    output reg out_en;
    // output reg out_sigl
    output reg signed [15:0] outx;
    output reg signed [15:0] outy;

    reg out_sig;
    reg [7:0] input_cnt;
    reg [7:0] output_cnt;
    reg signed [15:0] input_datax[0:63];
    reg signed [15:0] input_datay[0:63];
    reg signed [15:0] datax_cache[0:63];
    reg signed [15:0] datay_cache[0:63];
    
    integer i;

    always @(posedge clk) begin
        if(reset) begin
            for (i = 0;i < 64;i = i + 1) begin
                input_datax[i] <= 0;
                input_datay[i] <= 0;
                datax_cache[i] <= 0;
                datay_cache[i] <= 0;
            end
            input_cnt <= 0;
            output_cnt <= 0;
            out_sig <= 0;
            out_en <= 0;
            outx <= 0;
            outy <= 0;
        end
        else if(mod_en)
        begin
            input_datax[input_cnt] <= inx;
            input_datay[input_cnt] <= iny;
            if (input_cnt < 63) begin
                input_cnt <= input_cnt + 1;
            end
            else
            begin
                input_cnt <= 0;
                out_sig <= 1;
                // out_en <= 1;
                for(i = 0;i < 63;i = i + 1)
                begin
                    datax_cache[i] <= input_datax[i];
                    datay_cache[i] <= input_datay[i];
                end
                datax_cache[63] <= inx;
                datay_cache[63] <= iny;
            end
        end
        else
        begin
            
        end
    end

    always @(posedge clk) begin
        if(out_sig)
        begin
            if (output_cnt < 64) begin
                outx <= datax_cache[output_cnt];
                outy <= datay_cache[output_cnt];
                output_cnt <= output_cnt + 1;
                out_en <= 1;
            end
            else
            begin
                output_cnt <= 0;
                out_en <= 0;
                out_sig <= 0;
            end
        end
    end
endmodule