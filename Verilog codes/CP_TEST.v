module CP_test(
    input sysclk,RST_I,
    input [15:0] 	DAT1_I_r,
    input [15:0] 	DAT1_I_i,
    input	ACK_I,
    output [15:0]    DAT2_O_r,
    output [15:0]    DAT2_O_i,
    output ACK_O	);


wire [15:0]	DAT1_O_r;
wire [15:0]DAT1_O_i;
wire clk1;
reg ACK1_O;
wire dout_i,dout_r;
wire delete_en;
//reg ACK_en=0;
//always @(*)
//begin
//    if(ACK_I)
//        ACK_en<=1;
//end
CLK clk(sysclk,RST_I,clk1);
ADD_CP  add_cp_r(	.CLK_I(clk1),.CLK_II(sysclk), .RST_I(RST_I),.DAT_I_r(DAT1_I_r),.DAT_I_i(DAT1_I_i),
.ACK_I(ACK_I),.DAT_O_r(DAT1_O_r),.DAT_O_i(DAT1_O_i),.dout_r(dout_r),.dout_i(dout_i),.delete_en(delete_en));

DELETE_CP delete_cp_r(.CLK_I(clk1),.CLK_II(sysclk) ,.RST_I(RST_I),.DAT_I_r(DAT1_O_r),.DAT_I_i(DAT1_O_i),
.din_r(dout_r),.din_i(dout_i),.DAT_O_r(DAT2_O_r),.DAT_O_i(DAT2_O_i),.ACK_O(ACK_O));

endmodule