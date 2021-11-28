module CLK(sys_clk,reset,clk);
input sys_clk,reset;
output reg clk;
reg[31:0]sum;
always@(negedge sys_clk or posedge reset)
begin
	 if(reset)
	   begin
		  sum <= 1;
		  clk<=0;
		end
	 else
		  clk <= ~clk;
			
  end
endmodule