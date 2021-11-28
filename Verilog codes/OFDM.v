module OFDM (
    input clk,
    input reset,
    input x_in,
    output [3:0] x_out
);


reg clk_half;

always@(negedge clk or posedge reset)
begin
	 if(reset)
	   begin
		  clk_half <= 1;
		end
	 else
		  clk_half <= ~clk_half;			
end


wire encoder_out;
wire encoder_esig;

Encoder encoder1(
    .clk(clk),
    .reset(reset),
    .in(x_in),
    .out(encoder_out),
    .out_esig(encoder_esig)
);

wire mod_en;
wire signed [15:0] mod_outx;
wire signed [15:0] mod_outy;

Mod mod1(
    .clk(clk),
    .reset(reset),
    .en(mod_en),
    .encoder_en(encoder_esig),
    .in(encoder_out),
    .outx(mod_outx),
    .outy(mod_outy)
);


wire ifft_en;
wire signed [15:0] ifft_out_re;
wire signed [15:0] ifft_out_im;

reg always_en;
always@(posedge clk)
begin
     if(reset)
       begin
          always_en <= 0;
        end
end

always @(*) begin
    if (mod_en == 1'b1)
    begin
        always_en <= 1'b1;
    end
end

wire reg_out_en;
wire signed [15:0] reg_out_x;
wire signed [15:0] reg_out_y;

FFT_Register fft_register1(
    .clk(clk), 
    .reset(reset), 
    .inx(mod_outx), 
    .iny(mod_outy), 
    .mod_en(mod_en), 
    .out_en(reg_out_en), 
    .outx(reg_out_x), 
    .outy(reg_out_y)
);


IFFT64 ifft1(
    .clock(clk),
    .reset(reset),
    .di_en(reg_out_en),
    .di_re(reg_out_x),
    .di_im(reg_out_y),
    .do_en(ifft_en),
    .do_re(ifft_out_re),
    .do_im(ifft_out_im)
);

// wire [15:0] cp_out_re,cp_out_im;
// wire cp_en;
// CP_test CP_test1(
//     .sysclk(clk),
//     .RST_I(reset),
//     .DAT1_I_r(ifft_out_re),
//     .DAT1_I_i(ifft_out_im),
//     .ACK_I(ifft_en),
//     .DAT2_O_r(cp_out_re),
//     .DAT2_O_i(cp_out_im),
//     .ACK_O(cp_en)
// );


// wire fft_en;
// wire [15:0] fft_out_re, fft_out_im;

// FFT64 fft1(
//     .clock(clk),
//     .reset(reset),
//     .di_en(cp_en),
//     .di_re(cp_out_re),
//     .di_im(cp_out_im),
//     .do_en(fft_en),
//     .do_re(fft_out_re),
//     .do_im(fft_out_im)
// );

wire fft_en;
wire [15:0] fft_out_re, fft_out_im;

FFT64 fft1(
    .clock(clk),
    .reset(reset),
    .di_en(ifft_en),
    .di_re(ifft_out_re),
    .di_im(ifft_out_im),
    .do_en(fft_en),
    .do_re(fft_out_re),
    .do_im(fft_out_im)
);



wire demod_en;
wire [1:0] demod_out;
De_Mod deMod1(
    .clk(clk),
    .reset(reset),
    .fft_en(fft_en),
    .inx(fft_out_im),
    .iny(fft_out_re),
    .out(demod_out),
    .en(demod_en)
);




Decoder decoder1(
    .clk(clk),
    .reset(reset),
    .in(demod_out),
    .demod_en(demod_en),
    .out(x_out)
);



endmodule
