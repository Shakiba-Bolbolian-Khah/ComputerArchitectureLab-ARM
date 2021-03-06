`timescale 1ns/1ns

module CONTROL_UNIT (
  input [1:0] mode,
  input S,
  input [3:0] opcode,
  output [8:0] out
  );
  //out[8:5] Execution Command | out[4] mem_read | out[3] mem_write
  //out[2] WB_Enable | out[1] B | out[0] status register
 	reg [3:0] cmd;
	reg mem_read, mem_write, WB_Enable, B, status_reg;
	
	always@(opcode, mode, S) begin
		cmd = 4'b0000;
		{mem_read, mem_write, WB_Enable, B} = 4'b0;
		status_reg = S;
		if (mode == 2'b00) begin
		  case(opcode)
		    4'b0000: begin //NOP & AND
				  mem_read = 1'b0;
				  mem_write = 1'b0;
				  WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0110;
			end
			4'b1101: begin //MOV
			    mem_read = 1'b0;
			    mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0001;
			end
			4'b1111: begin //MVN
			    mem_read = 1'b0;
			    mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b1001;
			end
			4'b0100: begin //ADD
				  mem_read = 1'b0;
				  mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0010;
			end
			4'b0101: begin //ADC
			    mem_read = 1'b0;
			    mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0011;
			end
			4'b0010: begin //SUB
				  mem_read = 1'b0;
				  mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0100;
			end
			4'b0110: begin //SBC
			    mem_read = 1'b0;
			    mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0101;
			end
			4'b1100: begin //ORR
				  mem_read = 1'b0;
				  mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b0111;
			end			
			4'b0001: begin //EOR
				  mem_read = 1'b0;
			    mem_write = 1'b0;
			    WB_Enable = 1'b1;
			    B = 1'b0;
			    cmd = 4'b1000;
			end
			4'b1010: begin //CMP
				if(S == 1'b1) begin 
				    mem_read = 1'b0;
				    mem_write = 1'b0;
				    WB_Enable = 1'b0;
				    B = 1'b0;
				    cmd = 4'b0100;
				end
			end
			4'b1000: begin //TST
				if(S == 1'b1) begin 
				    mem_read = 1'b0;
				    mem_write = 1'b0;
				    WB_Enable = 1'b0;
				    B = 1'b0;
				    cmd = 4'b0110;
				end
			end	
			default: begin
			    cmd = 4'b0000;
				{mem_read, mem_write, WB_Enable, B} = 4'b0;
		    end
		  endcase
		end
		if((opcode == 4'b0100) && (mode == 2'b01)) begin
			cmd = 4'b0010;
			if( S == 1) begin //LDR
			mem_read = 1'b1;
			mem_write = 1'b0;
			WB_Enable = 1'b1;
		    B = 1'b0;
	    end
	    else begin //STR
			mem_read = 1'b0;
			mem_write = 1'b1;
			WB_Enable = 1'b0;
			B = 1'b0;
			end
		end
		if((opcode[3] ==1'b0) && (mode == 2'b10)) begin //Branch
			mem_read = 1'b0;
			mem_write = 1'b0;
			WB_Enable = 1'b0;
			B = 1'b1;
			cmd = 4'b0000;
			status_reg = 1'b0;
		end
	end
	assign out = {cmd, mem_read, mem_write, WB_Enable, B, status_reg};
endmodule