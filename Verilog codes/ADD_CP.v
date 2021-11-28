module ADD_CP(
	input 			CLK_I, CLK_II,RST_I,
	input [15:0] 	DAT_I_r,DAT_I_i,
	input			ACK_I,
	
	output  reg[15:0]	DAT_O_r,DAT_O_i,
	output	reg dout_r,dout_i,
	output  reg  delete_en
    );
parameter LCP  = 16;
parameter NFFT = 48;

reg [15:0] send1_r[64:0],send1_i[64:0];
reg [15:0] send2_r[64:0],send2_i[64:0];
reg [9:0] dat_cnt_r,dat_cnt_i;
reg [31:0] i;
wire  inCP_r  = dat_cnt_r <= NFFT;
wire  infrm_r = dat_cnt_r <= NFFT+LCP;
wire  inCP_i  = dat_cnt_i <= NFFT;
wire  infrm_i = dat_cnt_i <= NFFT+LCP;

reg ACK_en=0;
always @(*)begin
if (ACK_I)
    ACK_en<=1;
end
always @(posedge CLK_I or posedge RST_I)
begin
	if (RST_I) 	begin
		dat_cnt_r	<= 10'd0;
		dat_cnt_i	<= 10'd0;	
		 for(i=0;i<64;i=i+1)begin
                send1_r[i]<=0;
                send1_i[i]<=0;
                send2_r[i]<=0;
                send2_i[i]<=0;
             end
		send1_r[64]<=0;
		send2_r[64]<=32'hffffffff;
		send1_i[64]<=0;
		send2_i[64]<=32'hffffffff;
	end
	else if (ACK_en) begin
	//shibu	
	    delete_en<=ACK_I;
		if (inCP_r) begin
            if(send1_r[64])begin
                send1_r[dat_cnt_r]<=DAT_I_r;
				dat_cnt_r	<= dat_cnt_r + 1'b1;
			end
            else if(send2_r[64])begin
                send2_r[dat_cnt_r]<=DAT_I_r;
				dat_cnt_r	<= dat_cnt_r + 1'b1;
			end
			            
		end
		else if (infrm_r) begin	
		        if(dat_cnt_r <NFFT+LCP)begin
                    if(send1_r[64])begin
                        send1_r[dat_cnt_r]<=DAT_I_r;
                        dat_cnt_r<=dat_cnt_r+1;
                    end
                    else if(send2_r[64])begin
                        send2_r[dat_cnt_r]<=DAT_I_r;
                        dat_cnt_r<=dat_cnt_r+1;
                    end
                    if(dat_cnt_r == NFFT+LCP-1)begin
                        dat_cnt_r<=10'd0;
                        send1_r[64]<=~send1_r[64];
                        send2_r[64]<=~send2_r[64];
                    end
                end
		end
	//xubu
		if (inCP_i) begin
            if(send1_i[64])begin
                send1_i[dat_cnt_i]<=DAT_I_i;
				dat_cnt_i	<= dat_cnt_i + 1'b1;
			end
            else if(send2_i[64])begin
                send2_i[dat_cnt_i]<=DAT_I_i;
				dat_cnt_i	<= dat_cnt_i + 1'b1;
			end
		end
		else if (infrm_i) begin	
		    if(dat_cnt_i < NFFT+LCP) begin
                if(send1_i[64])begin
                        send1_i[dat_cnt_i]<=DAT_I_i;
                         dat_cnt_i<=dat_cnt_i+1;
                end
                else if(send2_i[64])begin
                        send2_i[dat_cnt_i]<=DAT_I_i;
                         dat_cnt_i<=dat_cnt_i+1;
                end            
                if(dat_cnt_i == NFFT+LCP-1)begin
                    dat_cnt_i<=10'd0;
                    send1_i[64]<=~send1_i[64];
                    send2_i[64]<=~send2_i[64];              
                 end
		    end
	    end
        else begin
            dat_cnt_r	<= 10'd0;
            dat_cnt_i	<= 10'd0;		
        end
   end
end

reg[31:0]word_cnt_r,word_cnt_i;
reg[31:0] sum_r,sum_i;
reg[31:0] sym_r,sym_i;
always@(posedge CLK_II or posedge RST_I)begin
    if(RST_I)begin
       		word_cnt_r<=0;
			word_cnt_i<=0;
            sum_r<=0;
            sum_i<=0;
            sym_r<=0;
            sym_i<=0;     
	end
    else begin
         if(dat_cnt_r==48)
            sym_r<=1;
         if((dat_cnt_r>48 & dat_cnt_r<64) || (dat_cnt_r==0&sym_r))begin          
                        if(sum_r==31)begin
                            sum_r<=0;
                            dout_r<=1;
                         end
                        else begin
                            DAT_O_r<=DAT_I_r;//shibu
                            sum_r<=sum_r+1;
                        end
                
         end
		if(dout_r) begin
			if(~send1_r[64])begin
				DAT_O_r<=send1_r[word_cnt_r];
				word_cnt_r<=word_cnt_r+1;
			end
			else if(~send2_r[64])begin
				DAT_O_r<=send2_r[word_cnt_r];
				word_cnt_r<=word_cnt_r+1;
			end
			
            if (word_cnt_r==LCP+NFFT-1) begin
                    word_cnt_r<=10'd0;
                    dout_r<=0;
            end
	
    	end
	//xubu
	    if(dat_cnt_i==48)
               sym_i<=1;
	    if((dat_cnt_i>48 & dat_cnt_i<64) || (dat_cnt_i==0&sym_i))begin
                   if(sum_i==31)begin
                       sum_i<=0;
                       dout_i<=1;
                    end
                   else begin
                       DAT_O_i<=DAT_I_i;//shibu
                       sum_i<=sum_i+1;
                   end
        end
		if(dout_i ) begin
			if(~send1_i[64])begin
				DAT_O_i<=send1_i[word_cnt_i];
				word_cnt_i<=word_cnt_i+1;
			end
			else if(~send2_i[64])begin
				DAT_O_i<=send2_i[word_cnt_i];
				word_cnt_i<=word_cnt_i+1;
			end
			
			if (word_cnt_i==LCP+NFFT-1) begin
				word_cnt_i<=10'd0;
				dout_i<=0;
			end
    	end
   end
end
endmodule