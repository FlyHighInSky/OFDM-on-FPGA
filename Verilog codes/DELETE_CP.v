module DELETE_CP(
	input 			CLK_I, CLK_II,RST_I,
	input [15:0] 	DAT_I_r,DAT_I_i,
	input			din_r,din_i,
	
	output reg [15:0]	DAT_O_r,DAT_O_i,
	output reg 			ACK_O
    );

parameter LCP  = 16;
parameter NFFT = 48;

reg [9:0] dat_cnt_r,dat_cnt_i;
wire	inCP_r  = dat_cnt_r < LCP;
wire    infrm_r = dat_cnt_r < NFFT+LCP;

wire	inCP_i  = dat_cnt_i < LCP;
wire    infrm_i = dat_cnt_i < NFFT+LCP;
reg [31:0]ACK_cnt_r;
reg [15:0] send1_r[65:0],send1_i[65:0];
reg [15:0] send2_r[65:0],send2_i[65:0];
reg[31:0] i;
reg dvalid_r,dvalid_i;
always @(posedge CLK_II or posedge RST_I)
begin
	if (RST_I) 	begin
		dat_cnt_r	<= 10'd0;	
		dat_cnt_i	<= 10'd0;	
		 for(i=0;i<65;i=i+1)begin
           send1_r[i]<=0;
           send1_i[i]<=0;
           send2_r[i]<=0;
           send2_i[i]<=0;
        end
        send1_r[65]<=0;
        send2_r[65]<=32'hffffffff;
        send1_i[65]<=0;
        send2_i[65]<=32'hffffffff;
        ACK_cnt_r<=0;
        ACK_O<=0;
//        ACK_cnt_i<=0;
	end
	else begin
	//shibu
		if (din_r) begin
		      
		       
		       if(send1_r[65])begin
                   send1_r[dat_cnt_r]<=DAT_I_r;
                   dat_cnt_r    <= dat_cnt_r + 1'b1;
               end
               else if(send2_r[65])begin
                   send2_r[dat_cnt_r]<=DAT_I_r;
                   dat_cnt_r    <= dat_cnt_r + 1'b1;
               end
			 if(dat_cnt_r == NFFT+LCP-1)begin
                        dat_cnt_r<=10'd0;
                        dvalid_r<=1;
                        send1_r[64]<=send1_r[0];
                        send2_r[64]<=send2_r[0];                 
                        send1_r[65]<=~send1_r[65];
                        send2_r[65]<=~send2_r[65];
                       
               end
		end		

	
    //xubu
		if(din_i)begin
		      if(send1_i[65])begin
                   send1_i[dat_cnt_i]<=DAT_I_i;
                   dat_cnt_i   <= dat_cnt_i + 1'b1;
               end
               else if(send2_i[65])begin
                   send2_i[dat_cnt_i]<=DAT_I_i;
                   dat_cnt_i   <= dat_cnt_i+ 1'b1;
               end
             if(dat_cnt_i == NFFT+LCP-1)begin
                        dat_cnt_i<=10'd0;
                        dvalid_i<=1;
                        send1_i[64]<=send1_i[0];
                        send2_i[64]<=send2_i[0];                 
                        send1_i[65]<=~send1_i[65];
                        send2_i[65]<=~send2_i[65];
                       
               end
		end
	end
end

reg[31:0] word_cnt_r, word_cnt_i;
always@(posedge CLK_I or posedge RST_I)begin
    if(RST_I)begin
        word_cnt_r<=1;
        word_cnt_i<=1;
	end
    else begin
    //shibu
        if(dvalid_r)begin
              if(ACK_cnt_r==0)begin
                 ACK_cnt_r<=ACK_cnt_r+1;
                 ACK_O<=1;
                 end
              else if(ACK_cnt_r==64)begin
                     ACK_O<=0;
                     ACK_cnt_r<=ACK_cnt_r+1;
                     end
              else if(ACK_cnt_r==191)
                   ACK_cnt_r<=0;
              else
                 ACK_cnt_r<=ACK_cnt_r+1;
                         
            if(~send1_r[65])begin
                        
                DAT_O_r<=send1_r[word_cnt_r];
                word_cnt_r<=word_cnt_r+1;
            end
            else if(~send2_r[65])begin
                
                DAT_O_r<=send2_r[word_cnt_r];
                word_cnt_r<=word_cnt_r+1;
            end
                    
            if (word_cnt_r==LCP+NFFT) begin
                    word_cnt_r<=10'd1;
                   // dvalid_r<=0;
            end
          end
    //xubu
         if(dvalid_i)begin
               
            if(~send1_i[65])begin           
                DAT_O_i<=send1_i[word_cnt_i];
                word_cnt_i<=word_cnt_i+1;
            end
            else if(~send2_i[65])begin
                DAT_O_i<=send2_i[word_cnt_i];
                word_cnt_i<=word_cnt_i+1;
            end
                
            if (word_cnt_i==LCP+NFFT) begin
                    word_cnt_i<=10'd1;
                    //dvalid_i<=0;
            end
         end
    end
    
end
//always@(negedge CLK_II)begin
//         if(DAT_O_i)
//               ACK_O<=0;
//           else
//               ACK_O<=1;   
//end

endmodule