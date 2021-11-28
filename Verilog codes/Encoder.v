`timescale 1ns / 1ps
module Encoder (clk, reset, in, out, out_esig);
    input in;
    input reset;
    input clk;
    output reg out;
    output reg out_esig;
    
    reg esig;
    reg [3:0] data;
    reg [7:0] out_data;

    reg [1:0] in_count;
    reg [3:0] out_count;
    
    reg sig;
    reg eesig;

    reg [3:0] matrix[0:7];
    
    always @(posedge clk) 
    begin
        if (reset)
        begin
            matrix[7] <= 4'b0000;
            matrix[6] <= 4'b1000;
            matrix[5] <= 4'b0100;
            matrix[4] <= 4'b0010;
            matrix[3] <= 4'b0001;
            matrix[2] <= 4'b1011;
            matrix[1] <= 4'b1110;
            matrix[0] <= 4'b0111;

        end
    end

    always @(posedge clk or posedge reset) 
    if(reset)begin
        data <= 4'b0;
        in_count <= 2'b0;
        sig <= 0;
        eesig <= 0;
    end
    else
    begin
        if (in_count == 2'b11) 
            begin
                in_count <= 2'b00;
                sig <= 1;
            end
        else
            begin
                in_count <= in_count + 1;
                data <= {data[2:0], in};
            end
    end
    
    integer i;
    
    always @(posedge clk)
    begin
    if(sig)
        eesig <= 1;
    end
    

    always @(posedge clk) 
    if (eesig)
    begin
        for (i = 0;i < 8 ;i = i + 1) 
        begin
            if (i == 7)
                out_data[i] <= data[0] * matrix[i][0] + 
                            data[1] * matrix[i][1] +
                            data[2] * matrix[i][2] + 
                            data[3] * matrix[i][3] + 1;
            else
                out_data[i] <= data[0] * matrix[i][0] + 
                            data[1] * matrix[i][1] +
                            data[2] * matrix[i][2] + 
                            data[3] * matrix[i][3];
        end
        esig <= 1;
        sig <= 0;
        eesig <= 0;
    end


    always @(posedge clk) begin
    if(reset)
        out_count <= 0;
    else begin
        if (esig && out_count < 8)
        begin
            out_esig <= 1;
            out <= out_data[7-out_count];
//            out_count <= out_count + 1;
            if(out_count == 7)
            begin
                esig <= 0;
                out_count <= 0;
            end
            else
                out_count <= out_count + 1;
        end
        if(!esig)
            out_esig <= 0;
    end
    end

endmodule