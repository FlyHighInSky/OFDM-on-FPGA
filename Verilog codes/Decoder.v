`timescale 1ns/1ps
module Decoder (clk, reset, in, demod_en, out);
    input clk;
    input reset;
    input [1:0] in;
    input demod_en;
    output reg [3:0] out;


    reg [2:0] in_count;
    reg [7:0] matrix[0:2];
    reg [7:0] in_data;
    reg [2:0] e;
    reg [7:0] data_cache;

    reg sig;

    integer i,j;


    always @(posedge clk) begin
        if (reset)
        begin
            matrix[0] <= 8'b00111010;
            matrix[1] <= 8'b01001110;
            matrix[2] <= 8'b10011100;
            sig <= 0;
            e <= 0;
            in_count <= 0;
        end
        else if (demod_en)
        begin
            if (in_count < 3'b011)
            begin
                in_data <= {in, in_data[7:2]};
                in_count <= in_count + 1;
            end
            else if (in_count == 3'b011)
            begin
                data_cache <= {in, in_data[7:2]};
                sig <= 1;
                in_count <= 0;
                e <= 0;
            end
        end
    end

    always @(posedge clk) begin
        if (sig)
        begin
            for (i = 0;i<3 ;i=i+1 ) begin
                for (j = 0;j < 8 ;j=j+1 ) begin
                    e[i] = e[i] + matrix[i][j]*data_cache[j];
                end
            end

            

            sig <= 0;

        end

        case (e)
                3'b000: out <= {data_cache[1], data_cache[2], data_cache[3], data_cache[4]};
                3'b110: out <= {~data_cache[1], data_cache[2], data_cache[3], data_cache[4]};
                3'b011: out <= {data_cache[1], ~data_cache[2], data_cache[3], data_cache[4]};
                3'b111: out <= {data_cache[1], data_cache[2], ~data_cache[3], data_cache[4]};
                3'b101: out <= {data_cache[1], data_cache[2], data_cache[3], ~data_cache[4]};
                default: out <= 4'b0000;
        endcase

    end
    
endmodule