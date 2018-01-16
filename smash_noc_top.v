`timescale 1 ns / 1 ps

module smash_noc #(
	parameter ADDR_SIZE       = 4,
	parameter DATA_SIZE       = 32,
	parameter NUM_ROWS        = 1,
	parameter NUM_COLUMNS     = 1,
	parameter ROUTER_ROW_ADDR = 0,
	parameter ROUTER_COL_ADDR = 0
) (
	input 					 i_clk, i_rst,

	// Upper NoC interface
	input 					 i_ready_up,
	input [ADDR_SIZE - 1:0]  i_addr_row_up,
	input [ADDR_SIZE - 1:0]  i_addr_col_up,
	input [DATA_SIZE - 1:0]  i_data_up,
	input 					 i_valid_up,
    output reg 				 o_ready_up,
	output 					 o_valid_up,
	output [ADDR_SIZE - 1:0] o_addr_row_up,
	output [ADDR_SIZE - 1:0] o_addr_col_up,
	output [DATA_SIZE - 1:0] o_data_up,

	// Down NoC interface
    input 					 i_ready_down,
	input [ADDR_SIZE - 1:0]  i_addr_row_down,
	input [ADDR_SIZE - 1:0]  i_addr_col_down,
	input [DATA_SIZE - 1:0]  i_data_down,
	input 					 i_valid_down,
    output reg 				 o_ready_down,
	output 					 o_valid_down,
	output [ADDR_SIZE - 1:0] o_addr_row_down,
	output [ADDR_SIZE - 1:0] o_addr_col_down,
	output [DATA_SIZE - 1:0] o_data_down,

	// Left NoC interface
    input 					 i_ready_left,
	input [ADDR_SIZE - 1:0]  i_addr_row_left,
	input [ADDR_SIZE - 1:0]  i_addr_col_left,
	input [DATA_SIZE - 1:0]  i_data_left,
	input 					 i_valid_left,
    output reg 				 o_ready_left,
	output 					 o_valid_left,
	output [ADDR_SIZE - 1:0] o_addr_row_left,
	output [ADDR_SIZE - 1:0] o_addr_col_left,
	output [DATA_SIZE - 1:0] o_data_left,

	// Right NoC interface
    input 					 i_ready_right,
	input [ADDR_SIZE - 1:0]  i_addr_row_right,
	input [ADDR_SIZE - 1:0]  i_addr_col_right,
	input [DATA_SIZE - 1:0]  i_data_right,
	input 					 i_valid_right,
    output reg 				 o_ready_right,
	output 					 o_valid_right,
	output [ADDR_SIZE - 1:0] o_addr_row_right,
	output [ADDR_SIZE - 1:0] o_addr_col_right,
	output [DATA_SIZE - 1:0] o_data_right,

	// Pico Co-Processor Interface (PCPI)
	input 					 pcpi_valid,
	input [31:0] 			 pcpi_insn,
	input [31:0] 			 pcpi_rs1,
	input [31:0] 			 pcpi_rs2,
	output reg 				 pcpi_wr,
	output [31:0] 			 pcpi_rd,
	output reg 				 pcpi_wait,
	output reg				 pcpi_ready
);
	localparam [2:0] DIR_UP     = 3'd0;
	localparam [2:0] DIR_RIGHT  = 3'd1;
	localparam [2:0] DIR_DOWN   = 3'd2;
	localparam [2:0] DIR_LEFT   = 3'd3;
	localparam [2:0] DIR_CENTER = 3'd4;

	reg  [2:0] lane_direction = DIR_UP;

	assign o_valid_up    = ~empty_up;
	assign o_valid_right = ~empty_right;
	assign o_valid_down  = ~empty_down;
	assign o_valid_left  = ~empty_left;

	assign o_data_up    = o_fifo_data_up[DATA_SIZE - 1:0];
	assign o_data_right = o_fifo_data_right[DATA_SIZE - 1:0];
	assign o_data_down  = o_fifo_data_down[DATA_SIZE - 1:0];
	assign o_data_left 	= o_fifo_data_left[DATA_SIZE - 1:0];
	assign pcpi_rd      = o_fifo_data_center[DATA_SIZE - 1:0];

	assign o_addr_row_up     = o_fifo_data_up[ADDR_SIZE + DATA_SIZE - 1:DATA_SIZE];
	assign o_addr_row_right  = o_fifo_data_right[ADDR_SIZE + DATA_SIZE - 1:DATA_SIZE];
	assign o_addr_row_down   = o_fifo_data_down[ADDR_SIZE + DATA_SIZE - 1:DATA_SIZE];
	assign o_addr_row_left 	 = o_fifo_data_left[ADDR_SIZE + DATA_SIZE - 1:DATA_SIZE];
	assign o_addr_row_center = pcpi_rs1[ADDR_SIZE - 1:0];

	assign o_addr_col_up     = o_fifo_data_up[(2 * ADDR_SIZE) + DATA_SIZE - 1:ADDR_SIZE + DATA_SIZE];
	assign o_addr_col_right  = o_fifo_data_right[(2 * ADDR_SIZE) + DATA_SIZE - 1:ADDR_SIZE + DATA_SIZE];
	assign o_addr_col_down   = o_fifo_data_down[(2 * ADDR_SIZE) + DATA_SIZE - 1:ADDR_SIZE + DATA_SIZE];
	assign o_addr_col_left 	 = o_fifo_data_left[(2 * ADDR_SIZE) + DATA_SIZE - 1:ADDR_SIZE + DATA_SIZE];
	assign o_addr_col_center = pcpi_rs2[ADDR_SIZE - 1:0];

	reg write_up, write_down, write_left, write_right, write_center;
	reg read_up, read_down, read_left, read_right, read_center;
	reg [2 * ADDR_SIZE + DATA_SIZE - 1:0] i_fifo_data_up;
	reg [2 * ADDR_SIZE + DATA_SIZE - 1:0] i_fifo_data_down;
	reg [2 * ADDR_SIZE + DATA_SIZE - 1:0] i_fifo_data_left;
	reg [2 * ADDR_SIZE + DATA_SIZE - 1:0] i_fifo_data_right;
	reg [2 * ADDR_SIZE + DATA_SIZE - 1:0] i_fifo_data_center;
	wire [2 * ADDR_SIZE + DATA_SIZE - 1:0] o_fifo_data_up;
	wire [2 * ADDR_SIZE + DATA_SIZE - 1:0] o_fifo_data_down;
	wire [2 * ADDR_SIZE + DATA_SIZE - 1:0] o_fifo_data_right;
	wire [2 * ADDR_SIZE + DATA_SIZE - 1:0] o_fifo_data_left;
	wire [2 * ADDR_SIZE + DATA_SIZE - 1:0] o_fifo_data_center;
	wire full_up, full_down, full_left, full_right, full_center;
	wire empty_up, empty_down, empty_left, empty_right, empty_center;

	wire [15:0] row_addr, col_addr;
	assign row_addr = pcpi_rs2[ADDR_SIZE / 2 - 1:0];
	assign col_addr = pcpi_rs2[ADDR_SIZE - 1:ADDR_SIZE / 2];

	// Direction process
	always @(posedge i_clk) begin
		case (lane_direction)
			DIR_UP: begin
				lane_direction <= DIR_RIGHT;
			end
			DIR_RIGHT: begin
				lane_direction <= DIR_DOWN;
			end
			DIR_DOWN: begin
				lane_direction <= DIR_LEFT;
			end
			DIR_LEFT: begin
				lane_direction <= DIR_CENTER;
			end
			DIR_CENTER: begin
				lane_direction <= DIR_UP;
			end
		endcase
	end

	// Decode the destination direction
	always @(*) begin
		//
		// SET EVERYTHING TO ZERO
		//
//		o_ready_up 	   = 1'b0;
//		o_ready_right  = 1'b0;
//		o_ready_down   = 1'b0;
//		o_ready_left   = 1'b0;
//		o_ready_center = 1'b0;

//		write_up 	 = 'b0;
//		write_left 	 = 'b0;
//		write_down 	 = 'b0;
//		write_left   = 'b0;
//		write_center = 'b0;

		case (lane_direction)
			DIR_UP: begin
				if (i_valid_up) begin
					if (i_addr_row_up == ROUTER_ROW_ADDR &&
						i_addr_col_up == ROUTER_COL_ADDR) begin
						//
						// WRITE TO THE FIFO OF THIS PROCESSOR
						//
						if (!full_center) begin
							write_center       = 'b1;
							i_fifo_data_center = {i_addr_col_up, i_addr_row_up, i_data_up};
							o_ready_up         = 'b1;
						end
					end else if (i_addr_row_up == ROUTER_ROW_ADDR) begin
						if (i_addr_col_up > ROUTER_COL_ADDR) begin
							//
							// GO TO THE RIGHT
							//
							if (!full_right) begin
								write_right 	  = 'b1;
								i_fifo_data_right = {i_addr_col_up, i_addr_row_up, i_data_up};
								o_ready_up        = 'b1;
							end
						end else begin
							//
							// GO TO THE LEFT
							//
							if (!full_left) begin
								write_left       = 'b1;
								i_fifo_data_left = {i_addr_col_up, i_addr_row_up, i_data_up};
								o_ready_up       = 'b1;
							end
						end
					end else if (i_addr_col_up == ROUTER_COL_ADDR) begin
						//
						// WE NEED TO GO DOWN
						//
						if (!full_down) begin
							write_down 	     = 'b1;
							i_fifo_data_down = {i_addr_col_up, i_addr_row_up, i_data_up};
							o_ready_up       = 'b1;
						end
					end
				end
			end
			DIR_RIGHT: begin
				if (i_valid_right) begin
					if (i_addr_row_right == ROUTER_ROW_ADDR &&
						i_addr_col_right == ROUTER_COL_ADDR) begin
						//
						// WRITE TO THE FIFO OF THIS PROCESSOR
						//
						if (!full_center) begin
							write_center 	   = 'b1;
							i_fifo_data_center = {i_addr_col_right, i_addr_row_right, i_data_right};
							o_ready_right 	   = 'b1;
						end
					end else if (i_addr_col_right == ROUTER_COL_ADDR) begin
						if (i_addr_row_right > ROUTER_ROW_ADDR) begin
							//
							// GO UP
							//
							if (!full_up) begin
								write_up 	   = 'b1;
								i_fifo_data_up = {i_addr_col_right, i_addr_row_right, i_data_right};
								o_ready_right  = 'b1;
							end
						end else begin
							//
							// GO DOWN
							//
							if (!full_down) begin
								write_down 		 = 'b1;
								i_fifo_data_down = {i_addr_col_right, i_addr_row_right, i_data_right};
								o_ready_right    = 'b1;
							end
						end
					end	else begin // if (i_addr_row_right > ROUTER_ROW_ADDR)
						//
						// GO LEFT
						//
						if (!full_left) begin
							write_left 		 = 'b1;
							i_fifo_data_left = {i_addr_col_right, i_addr_row_right, i_data_right};
							o_ready_right 	 = 'b1;
						end
					end
				end
			end
			DIR_DOWN: begin
				if (i_valid_down) begin
					if (i_addr_row_down == ROUTER_ROW_ADDR &&
						i_addr_col_down == ROUTER_COL_ADDR) begin
						//
						// WRITE TO THE FIFO OF THIS PROCESSOR
						//
						if (!full_center) begin
							write_center       = 'b1;
							i_fifo_data_center = {i_addr_col_down, i_addr_row_down, i_data_down};
							o_ready_down       = 'b1;
						end
					end else if (i_addr_row_down == ROUTER_ROW_ADDR) begin
						if (i_addr_col_down > ROUTER_COL_ADDR) begin
							//
							// GO TO THE RIGHT
							//
							if (!full_right) begin
								write_right 	  = 'b1;
								i_fifo_data_right = {i_addr_col_down, i_addr_row_down, i_data_down};
								o_ready_down      = 'b1;
							end
						end else begin
							//
							// GO TO THE LEFT
							//
							if (!full_left) begin
								write_left       = 'b1;
								i_fifo_data_left = {i_addr_col_down, i_addr_row_down, i_data_down};
								o_ready_down     = 'b1;
							end
						end
					end else if (i_addr_col_down == ROUTER_COL_ADDR) begin
						//
						// WE NEED TO GO UP
						//
						if (!full_up) begin
							write_up 	   = 'b1;
							i_fifo_data_up = {i_addr_col_down, i_addr_row_down, i_data_down};
							o_ready_down   = 'b1;
						end
					end
				end
			end
			DIR_LEFT: begin
				if (i_valid_left) begin
					if (i_addr_row_left == ROUTER_ROW_ADDR &&
						i_addr_col_left == ROUTER_COL_ADDR) begin
						//
						// WRITE TO THE FIFO OF THIS PROCESSOR
						//
						if (!full_center) begin
							write_center 	   = 'b1;
							i_fifo_data_center = {i_addr_col_left, i_addr_row_left, i_data_left};
							o_ready_left 	   = 'b1;
						end
					end else if (i_addr_col_left == ROUTER_COL_ADDR) begin
						if (i_addr_row_left > ROUTER_ROW_ADDR) begin
							//
							// GO UP
							//
							if (!full_up) begin
								write_up 	   = 'b1;
								i_fifo_data_up = {i_addr_col_left, i_addr_row_left, i_data_left};
								o_ready_left   = 'b1;
							end
						end else begin
							//
							// GO DOWN
							//
							if (!full_down) begin
								write_down 		 = 'b1;
								i_fifo_data_down = {i_addr_col_left, i_addr_row_left, i_data_left};
								o_ready_left     = 'b1;
							end
						end
					end	else begin
						//
						// GO RIGHT
						//
						if (!full_right) begin
							write_right		  = 'b1;
							i_fifo_data_right = {i_addr_col_left, i_addr_row_left, i_data_left};
							o_ready_left   	  = 1;
						end
					end
				end
			end
			DIR_CENTER: begin
				if (pcpi_valid) begin
				    //
				    // DECODE WHETHER WE WANT TO WRITE OR READ
				    //
				    if (pcpi_insn[31]) begin
                        if (col_addr == ROUTER_COL_ADDR &&
                            row_addr == ROUTER_ROW_ADDR) begin
                            //
                            // WRITE TO YOURSELF FOR WHATEVER REASON
                            //
                        end else if (col_addr == ROUTER_COL_ADDR) begin
                            if (row_addr > ROUTER_ROW_ADDR) begin
                                //
                                // GO UP
                                //
                                if (!full_up) begin
                                    write_up 	   = 'b1;
                                    i_fifo_data_up = {pcpi_rs2[ADDR_SIZE - 1:0], pcpi_rs1[ADDR_SIZE - 1:0], pcpi_rd};
                                    pcpi_ready     = 'b1;
                                end
                            end else begin
                                //
                                // GO DOWN
                                //
                                if (!full_down) begin
                                    write_down       = 'b1;
                                    i_fifo_data_down = {pcpi_rs2[ADDR_SIZE - 1:0], pcpi_rs1[ADDR_SIZE - 1:0], pcpi_rd};
                                    pcpi_ready       = 'b1;
                                end
                            end
                        end else if (row_addr == ROUTER_ROW_ADDR) begin
                            if (col_addr > ROUTER_COL_ADDR) begin
                                //
                                // GO RIGHT
                                //
                                if (!full_right) begin
                                    write_right 	  = 'b1;
                                    i_fifo_data_right = {pcpi_rs2[ADDR_SIZE - 1:0], pcpi_rs1[ADDR_SIZE - 1:0], pcpi_rd};
                                    pcpi_ready        = 'b1;
                                end
                            end else begin
                                //
                                // GO LEFT
                                //
                                if (!full_left) begin
                                    write_left 	     = 'b1;
                                    i_fifo_data_left = {pcpi_rs2[ADDR_SIZE - 1:0], pcpi_rs1[ADDR_SIZE - 1:0], pcpi_rd};
                                    pcpi_ready       = 'b1;
                                end
                            end
                        end else begin

                        end
                    end else begin
                        //
                        // READ
                        //
                    end
				end
			end
		endcase
	end

	// Lane write FIFOs
	smash_fifo #(1, (2 * ADDR_SIZE + DATA_SIZE)) lane_fifo_up (
		.i_clk   (i_clk),
		.i_rst   (i_rst),
		.i_write (write_up),
		.i_read  (read_up),
		.i_data  (i_fifo_data_up),
		.o_data  (o_fifo_data_up),
		.o_full  (full_up),
		.o_empty (empty_up)
	);
	smash_fifo #(1, (2 * ADDR_SIZE + DATA_SIZE)) lane_fifo_down (
		.i_clk   (i_clk),
		.i_rst   (i_rst),
		.i_write (write_down),
		.i_read  (read_down),
		.i_data  (i_fifo_data_down),
		.o_data  (o_fifo_data_down),
		.o_full  (full_down),
		.o_empty (empty_down)
	);
	smash_fifo #(1, (2 * ADDR_SIZE + DATA_SIZE)) lane_fifo_left (
		.i_clk   (i_clk),
		.i_rst   (i_rst),
		.i_write (write_left),
		.i_read  (read_left),
		.i_data  (i_fifo_data_left),
		.o_data  (o_fifo_data_left),
		.o_full  (full_left),
		.o_empty (empty_left)
	);
	smash_fifo #(1, (2 * ADDR_SIZE + DATA_SIZE)) lane_fifo_right (
		.i_clk   (i_clk),
		.i_rst   (i_rst),
		.i_write (write_right),
		.i_read  (read_right),
		.i_data  (i_fifo_data_right),
		.o_data  (o_fifo_data_right),
		.o_full  (full_right),
		.o_empty (empty_right)
	);
	smash_fifo #(1, (2 * ADDR_SIZE + DATA_SIZE)) lane_fifo_center (
		.i_clk   (i_clk),
		.i_rst   (i_rst),
		.i_write (write_center),
		.i_read  (read_center),
		.i_data  (i_fifo_data_center),
		.o_data  (o_fifo_data_center),
		.o_full  (full_center),
		.o_empty (empty_center)
	);
endmodule
