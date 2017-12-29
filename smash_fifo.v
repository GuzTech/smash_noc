module smash_fifo #(
	parameter ADDR_SIZE = 1,
	parameter DATA_SIZE = 32
) (
	input i_clk, i_rst,

	input  [DATA_SIZE - 1:0] i_data,
	output [DATA_SIZE - 1:0] o_data,
	input                    i_read,
	input                    i_write,
	output                   o_full,
	output                   o_empty
);
	reg [DATA_SIZE - 1:0] mem[0:2 ** (ADDR_SIZE - 1)];
	reg [ADDR_SIZE - 1:0] read_ptr;
	reg [ADDR_SIZE - 1:0] write_ptr;
	reg empty;

	assign o_empty = empty;
	assign o_full  = !empty && (read_ptr == write_ptr);
	assign o_data  = mem[read_ptr];

	always @(posedge i_clk) begin
		if (i_rst) begin
			read_ptr  <= 1'd0;//ADDR_SIZE'd0;
			write_ptr <= 1'd0;//ADDR_SIZE'd0;
			empty     <= 1'b1;
		end else begin
			if (i_write && !o_full) begin
				if (i_read && !empty) begin
					mem[write_ptr] <= i_data;
				end else begin
					write_ptr      <= write_ptr + 1'd1;//ADDR_SIZE'd1;
					mem[write_ptr] <= i_data;
					empty          <= 1'b0;
				end
			end else if (i_read && !empty) begin
				read_ptr <= read_ptr + 1'd1;//ADDR_SIZE'd1;

				//if ((read_ptr + ADDR_SIZE'd1) == write_ptr) begin
				if ((read_ptr + 1'd1) == write_ptr) begin
					empty <= 1'b1;
				end
			end
		end
	end
endmodule
