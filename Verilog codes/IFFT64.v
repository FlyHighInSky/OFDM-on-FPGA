//----------------------------------------------------------------------
//  FFT: 64-Point FFT Using Radix-2^2 Single-Path Delay Feedback
//----------------------------------------------------------------------
module IFFT64 #(parameter WIDTH = 16) (
		 input                clock,  //  Master Clock
		 input                reset,  //  Active High Asynchronous Reset
		 input                di_en,  //  Input Data Enable
		 input   [WIDTH-1:0]  di_re,  //  Input Data (Real)
		 input   [WIDTH-1:0]  di_im,  //  Input Data (Imag)
		 output               do_en,  //  Output Data Enable
		 output  [WIDTH-1:0]  do_re,  //  Output Data (Real)
		 output  [WIDTH-1:0]  do_im   //  Output Data (Imag)
	);
	//----------------------------------------------------------------------
	//  Data must be input consecutively in natural order.
	//  The result is scaled to 1/N and output in bit-reversed order.
	//  The output latency is 71 clock cycles.
	//----------------------------------------------------------------------

	wire   [WIDTH-1:0]  di_im_new;
    wire [WIDTH-1:0]  do_re_new;
    wire  [WIDTH-1:0]  do_im_new;
    assign di_im_new = -di_im;

	FFT64 FFT (
		.clock	(clock),	//	in
		.reset	(reset),	//	in
		.di_en	(di_en),	//	in
		.di_re	(di_re),	//	in
		.di_im	(di_im_new),	//	in
		.do_en	(do_en),	//	out
		.do_re	(do_re_new),	//	out
		.do_im	(do_im_new)	//	out
	);

    assign do_re = do_re_new / 64;
    assign do_im = -do_im_new / 64;

endmodule
