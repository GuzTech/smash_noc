`timescale 1ns / 1ps

module smash_noc_top_tb;
    parameter ADDR_SIZE   = 2;
    parameter DATA_SIZE   = 32;
	parameter NUM_ROWS 	  = 2;
	parameter NUM_COLUMNS = 2;

    reg i_clk, i_rst;

	// Up
	wire i_ready_up_0_0, i_ready_up_0_1, i_ready_up_1_0, i_ready_up_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_row_up_0_0, i_addr_row_up_0_1, i_addr_row_up_1_0, i_addr_row_up_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_col_up_0_0, i_addr_col_up_0_1, i_addr_col_up_1_0, i_addr_col_up_1_1;
	wire [DATA_SIZE - 1:0] i_data_up_0_0, i_data_up_0_1, i_data_up_1_0, i_data_up_1_1;
	wire i_valid_up_0_0, i_valid_up_0_1, i_valid_up_1_0, i_valid_up_1_1;
	wire o_ready_up_0_0, o_ready_up_0_1, o_ready_up_1_0, o_ready_up_1_1;
	wire o_valid_up_0_0, o_valid_up_0_1, o_valid_up_1_0, o_valid_up_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_row_up_0_0, o_addr_row_up_0_1, o_addr_row_up_1_0, o_addr_row_up_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_col_up_0_0, o_addr_col_up_0_1, o_addr_col_up_1_0, o_addr_col_up_1_1;
	wire [DATA_SIZE - 1:0] o_data_up_0_0, o_data_up_0_1, o_data_up_1_0, o_data_up_1_1;

	// Down
	wire i_ready_down_0_0, i_ready_down_0_1, i_ready_down_1_0, i_ready_down_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_row_down_0_0, i_addr_row_down_0_1, i_addr_row_down_1_0, i_addr_row_down_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_col_down_0_0, i_addr_col_down_0_1, i_addr_col_down_1_0, i_addr_col_down_1_1;
	wire [DATA_SIZE - 1:0] i_data_down_0_0, i_data_down_0_1, i_data_down_1_0, i_data_down_1_1;
	wire i_valid_down_0_0, i_valid_down_0_1, i_valid_down_1_0, i_valid_down_1_1;
	wire o_ready_down_0_0, o_ready_down_0_1, o_ready_down_1_0, o_ready_down_1_1;
	wire o_valid_down_0_0, o_valid_down_0_1, o_valid_down_1_0, o_valid_down_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_row_down_0_0, o_addr_row_down_0_1, o_addr_row_down_1_0, o_addr_row_down_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_col_down_0_0, o_addr_col_down_0_1, o_addr_col_down_1_0, o_addr_col_down_1_1;
	wire [DATA_SIZE - 1:0] o_data_down_0_0, o_data_down_0_1, o_data_down_1_0, o_data_down_1_1;

	// Right
	wire i_ready_right_0_0, i_ready_right_0_1, i_ready_right_1_0, i_ready_right_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_row_right_0_0, i_addr_row_right_0_1, i_addr_row_right_1_0, i_addr_row_right_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_col_right_0_0, i_addr_col_right_0_1, i_addr_col_right_1_0, i_addr_col_right_1_1;
	wire [DATA_SIZE - 1:0] i_data_right_0_0, i_data_right_0_1, i_data_right_1_0, i_data_right_1_1;
	wire i_valid_right_0_0, i_valid_right_0_1, i_valid_right_1_0, i_valid_right_1_1;
	wire o_ready_right_0_0, o_ready_right_0_1, o_ready_right_1_0, o_ready_right_1_1;
	wire o_valid_right_0_0, o_valid_right_0_1, o_valid_right_1_0, o_valid_right_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_row_right_0_0, o_addr_row_right_0_1, o_addr_row_right_1_0, o_addr_row_right_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_col_right_0_0, o_addr_col_right_0_1, o_addr_col_right_1_0, o_addr_col_right_1_1;
	wire [DATA_SIZE - 1:0] o_data_right_0_0, o_data_right_0_1, o_data_right_1_0, o_data_right_1_1;

	// Left
	wire i_ready_left_0_0, i_ready_left_0_1, i_ready_left_1_0, i_ready_left_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_row_left_0_0, i_addr_row_left_0_1, i_addr_row_left_1_0, i_addr_row_left_1_1;
	wire [ADDR_SIZE - 1:0] i_addr_col_left_0_0, i_addr_col_left_0_1, i_addr_col_left_1_0, i_addr_col_left_1_1;
	wire [DATA_SIZE - 1:0] i_data_left_0_0, i_data_left_0_1, i_data_left_1_0, i_data_left_1_1;
	wire i_valid_left_0_0, i_valid_left_0_1, i_valid_left_1_0, i_valid_left_1_1;
	wire o_ready_left_0_0, o_ready_left_0_1, o_ready_left_1_0, o_ready_left_1_1;
	wire o_valid_left_0_0, o_valid_left_0_1, o_valid_left_1_0, o_valid_left_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_row_left_0_0, o_addr_row_left_0_1, o_addr_row_left_1_0, o_addr_row_left_1_1;
	wire [ADDR_SIZE - 1:0] o_addr_col_left_0_0, o_addr_col_left_0_1, o_addr_col_left_1_0, o_addr_col_left_1_1;
	wire [DATA_SIZE - 1:0] o_data_left_0_0, o_data_left_0_1, o_data_left_1_0, o_data_left_1_1;

	// Center
	

	smash_noc
		#(
		  .ADDR_SIZE       (ADDR_SIZE),
		  .DATA_SIZE       (DATA_SIZE),
		  .NUM_ROWS        (NUM_ROWS),
		  .NUM_COLUMNS     (NUM_COLUMNS),
		  .ROUTER_ROW_ADDR (0),
		  .ROUTER_COL_ADDR (0))
	NOC_0_0 (
	    .i_clk (i_clk),
		.i_rst (i_rst),
		.i_ready_up (i_ready_up_0_0),
		.i_addr_row_up (i_addr_row_up_0_0),
	    .i_addr_col_up (i_addr_col_up_0_0),
		.i_data_up (i_data_up_0_0),
		.i_valid_up (i_valid_up_0_0),
		.o_ready_up (o_ready_up_0_0),
	    .o_valid_up (o_valid_up_0_0),
		.o_addr_row_up (o_addr_row_up_0_0),
		.o_addr_col_up (o_addr_col_up_0_0),
		.o_data_up (o_data_up_0_0),
		.i_ready_down (i_ready_down_0_0),
		.i_addr_row_down (i_addr_row_down_0_0),
	    .i_addr_col_down (i_addr_col_down_0_0),
		.i_data_down (i_data_down_0_0),
		.i_valid_down (i_valid_down_0_0),
		.o_ready_down (o_ready_down_0_0),
	    .o_valid_down (o_valid_down_0_0),
		.o_addr_row_down (o_addr_row_down_0_0),
		.o_addr_col_down (o_addr_col_down_0_0),
		.o_data_down (o_data_down_0_0),
		.i_ready_left (i_ready_left_0_0),
		.i_addr_row_left (i_addr_row_left_0_0),
	    .i_addr_col_left (i_addr_col_left_0_0),
		.i_data_left (i_data_left_0_0),
		.i_valid_left (i_valid_left_0_0),
		.o_ready_left (o_ready_left_0_0),
	    .o_valid_left (o_valid_left_0_0),
		.o_addr_row_left (o_addr_row_left_0_0),
		.o_addr_col_left (o_addr_col_left_0_0),
		.o_data_left (o_data_left_0_0),
		.i_ready_right (i_ready_right_0_0),
		.i_addr_row_right (i_addr_row_right_0_0),
	    .i_addr_col_right (i_addr_col_right_0_0),
		.i_data_right (i_data_right_0_0),
		.i_valid_right (i_valid_right_0_0),
		.o_ready_right (o_ready_right_0_0),
	    .o_valid_right (o_valid_right_0_0),
		.o_addr_row_right (o_addr_row_right_0_0),
		.o_addr_col_right (o_addr_col_right_0_0),
		.o_data_right (o_data_right_0_0)
    );

	smash_noc
		#(
		  .ADDR_SIZE       (ADDR_SIZE),
		  .DATA_SIZE       (DATA_SIZE),
		  .NUM_ROWS        (NUM_ROWS),
		  .NUM_COLUMNS     (NUM_COLUMNS),
		  .ROUTER_ROW_ADDR (0),
		  .ROUTER_COL_ADDR (1))
	NOC_0_1 (
	    .i_clk (i_clk),
		.i_rst (i_rst),
		.i_ready_up (i_ready_up_0_1),
		.i_addr_row_up (i_addr_row_up_0_1),
	    .i_addr_col_up (i_addr_col_up_0_1),
		.i_data_up (i_data_up_0_1),
		.i_valid_up (i_valid_up_0_1),
		.o_ready_up (o_ready_up_0_1),
	    .o_valid_up (o_valid_up_0_1),
		.o_addr_row_up (o_addr_row_up_0_1),
		.o_addr_col_up (o_addr_col_up_0_1),
		.o_data_up (o_data_up_0_1),
		.i_ready_down (i_ready_down_0_1),
		.i_addr_row_down (i_addr_row_down_0_1),
	    .i_addr_col_down (i_addr_col_down_0_1),
		.i_data_down (i_data_down_0_1),
		.i_valid_down (i_valid_down_0_1),
		.o_ready_down (o_ready_down_0_1),
	    .o_valid_down (o_valid_down_0_1),
		.o_addr_row_down (o_addr_row_down_0_1),
		.o_addr_col_down (o_addr_col_down_0_1),
		.o_data_down (o_data_down_0_1),
		.i_ready_left (i_ready_left_0_1),
		.i_addr_row_left (i_addr_row_left_0_1),
	    .i_addr_col_left (i_addr_col_left_0_1),
		.i_data_left (i_data_left_0_1),
		.i_valid_left (i_valid_left_0_1),
		.o_ready_left (o_ready_left_0_1),
	    .o_valid_left (o_valid_left_0_1),
		.o_addr_row_left (o_addr_row_left_0_1),
		.o_addr_col_left (o_addr_col_left_0_1),
		.o_data_left (o_data_left_0_1),
		.i_ready_right (i_ready_right_0_1),
		.i_addr_row_right (i_addr_row_right_0_1),
	    .i_addr_col_right (i_addr_col_right_0_1),
		.i_data_right (i_data_right_0_1),
		.i_valid_right (i_valid_right_0_1),
		.o_ready_right (o_ready_right_0_1),
	    .o_valid_right (o_valid_right_0_1),
		.o_addr_row_right (o_addr_row_right_0_1),
		.o_addr_col_right (o_addr_col_right_0_1),
		.o_data_right (o_data_right_0_1)
    );

	smash_noc
		#(
		  .ADDR_SIZE       (ADDR_SIZE),
		  .DATA_SIZE       (DATA_SIZE),
		  .NUM_ROWS        (NUM_ROWS),
		  .NUM_COLUMNS     (NUM_COLUMNS),
		  .ROUTER_ROW_ADDR (1),
		  .ROUTER_COL_ADDR (0))
	NOC_1_0 (
	    .i_clk (i_clk),
		.i_rst (i_rst),
		.i_ready_up (i_ready_up_1_0),
		.i_addr_row_up (i_addr_row_up_1_0),
	    .i_addr_col_up (i_addr_col_up_1_0),
		.i_data_up (i_data_up_1_0),
		.i_valid_up (i_valid_up_1_0),
		.o_ready_up (o_ready_up_1_0),
	    .o_valid_up (o_valid_up_1_0),
		.o_addr_row_up (o_addr_row_up_1_0),
		.o_addr_col_up (o_addr_col_up_1_0),
		.o_data_up (o_data_up_1_0),
		.i_ready_down (i_ready_down_1_0),
		.i_addr_row_down (i_addr_row_down_1_0),
	    .i_addr_col_down (i_addr_col_down_1_0),
		.i_data_down (i_data_down_1_0),
		.i_valid_down (i_valid_down_1_0),
		.o_ready_down (o_ready_down_1_0),
	    .o_valid_down (o_valid_down_1_0),
		.o_addr_row_down (o_addr_row_down_1_0),
		.o_addr_col_down (o_addr_col_down_1_0),
		.o_data_down (o_data_down_1_0),
		.i_ready_left (i_ready_left_1_0),
		.i_addr_row_left (i_addr_row_left_1_0),
	    .i_addr_col_left (i_addr_col_left_1_0),
		.i_data_left (i_data_left_1_0),
		.i_valid_left (i_valid_left_1_0),
		.o_ready_left (o_ready_left_1_0),
	    .o_valid_left (o_valid_left_1_0),
		.o_addr_row_left (o_addr_row_left_1_0),
		.o_addr_col_left (o_addr_col_left_1_0),
		.o_data_left (o_data_left_1_0),
		.i_ready_right (i_ready_right_1_0),
		.i_addr_row_right (i_addr_row_right_1_0),
	    .i_addr_col_right (i_addr_col_right_1_0),
		.i_data_right (i_data_right_1_0),
		.i_valid_right (i_valid_right_1_0),
		.o_ready_right (o_ready_right_1_0),
	    .o_valid_right (o_valid_right_1_0),
		.o_addr_row_right (o_addr_row_right_1_0),
		.o_addr_col_right (o_addr_col_right_1_0),
		.o_data_right (o_data_right_1_0)
    );

	smash_noc
		#(
		  .ADDR_SIZE       (ADDR_SIZE),
		  .DATA_SIZE       (DATA_SIZE),
		  .NUM_ROWS        (NUM_ROWS),
		  .NUM_COLUMNS     (NUM_COLUMNS),
		  .ROUTER_ROW_ADDR (1),
		  .ROUTER_COL_ADDR (1))
	NOC_1_1 (
	    .i_clk (i_clk),
		.i_rst (i_rst),
		.i_ready_up (i_ready_up_1_1),
		.i_addr_row_up (i_addr_row_up_1_1),
	    .i_addr_col_up (i_addr_col_up_1_1),
		.i_data_up (i_data_up_1_1),
		.i_valid_up (i_valid_up_1_1),
		.o_ready_up (o_ready_up_1_1),
	    .o_valid_up (o_valid_up_1_1),
		.o_addr_row_up (o_addr_row_up_1_1),
		.o_addr_col_up (o_addr_col_up_1_1),
		.o_data_up (o_data_up_1_1),
		.i_ready_down (i_ready_down_1_1),
		.i_addr_row_down (i_addr_row_down_1_1),
	    .i_addr_col_down (i_addr_col_down_1_1),
		.i_data_down (i_data_down_1_1),
		.i_valid_down (i_valid_down_1_1),
		.o_ready_down (o_ready_down_1_1),
	    .o_valid_down (o_valid_down_1_1),
		.o_addr_row_down (o_addr_row_down_1_1),
		.o_addr_col_down (o_addr_col_down_1_1),
		.o_data_down (o_data_down_1_1),
		.i_ready_left (i_ready_left_1_1),
		.i_addr_row_left (i_addr_row_left_1_1),
	    .i_addr_col_left (i_addr_col_left_1_1),
		.i_data_left (i_data_left_1_1),
		.i_valid_left (i_valid_left_1_1),
		.o_ready_left (o_ready_left_1_1),
	    .o_valid_left (o_valid_left_1_1),
		.o_addr_row_left (o_addr_row_left_1_1),
		.o_addr_col_left (o_addr_col_left_1_1),
		.o_data_left (o_data_left_1_1),
		.i_ready_right (i_ready_right_1_1),
		.i_addr_row_right (i_addr_row_right_1_1),
	    .i_addr_col_right (i_addr_col_right_1_1),
		.i_data_right (i_data_right_1_1),
		.i_valid_right (i_valid_right_1_1),
		.o_ready_right (o_ready_right_1_1),
	    .o_valid_right (o_valid_right_1_1),
		.o_addr_row_right (o_addr_row_right_1_1),
		.o_addr_col_right (o_addr_col_right_1_1),
		.o_data_right (o_data_right_1_1)
    );

	// Connect NOC_0_0
	assign i_addr_row_up_0_0  = o_addr_row_down_1_0;
	assign i_addr_col_up_0_0  = o_addr_col_down_1_0;
	assign i_data_up_0_0  = o_data_down_1_0;
	assign i_ready_up_0_0  = o_ready_down_1_0;
	assign i_valid_up_0_0  = o_valid_down_1_0;

	assign i_addr_row_right_0_0  = o_addr_row_left_0_1;
	assign i_addr_col_right_0_0  = o_addr_col_left_0_1;
	assign i_data_right_0_0  = o_data_left_1_0;
	assign i_ready_right_0_0  = o_ready_left_1_0;
	assign i_valid_right_0_0  = o_valid_left_1_0;

	// Connect NOC_0_1
	assign i_addr_row_up_0_1  = o_addr_row_down_1_1;
	assign i_addr_col_up_0_1  = o_addr_col_down_1_1;
	assign i_data_up_0_1  = o_data_down_1_1;
	assign i_ready_up_0_1  = o_ready_down_1_1;
	assign i_valid_up_0_1  = o_valid_down_1_1;

	assign i_addr_row_left_0_1 	= o_addr_row_right_0_0;
	assign i_addr_col_left_0_1 	= o_addr_col_right_0_0;
	assign i_data_left_0_1  = o_data_right_0_0;
	assign i_ready_left_0_1  = o_ready_right_0_0;
	assign i_valid_left_0_1  = o_valid_right_0_0;

	// Connect NOC_1_0
	assign i_addr_row_down_1_0 	= o_addr_row_up_0_0;
	assign i_addr_col_down_1_0 	= o_addr_col_up_0_0;
	assign i_data_down_1_0 	= o_data_up_0_0;
	assign i_ready_down_1_0  = o_ready_up_0_0;
	assign i_valid_down_1_0  = o_valid_up_0_0;

	assign i_addr_row_right_1_0  = o_addr_row_left_0_0;
	assign i_addr_col_right_1_0  = o_addr_col_left_0_0;
	assign i_data_right_1_0  = o_data_left_0_0;
	assign i_ready_right_1_0  = o_ready_left_0_0;
	assign i_valid_right_1_0  = o_valid_left_0_0;

	// Connect NOC_1_1
	assign i_addr_row_down_1_1 	= o_addr_row_up_0_1;
	assign i_addr_col_down_1_1 	= o_addr_col_up_0_1;
	assign i_data_down_1_1 	= o_data_up_0_1;
	assign i_ready_down_1_1  = o_ready_up_0_1;
	assign i_valid_down_1_1  = o_valid_up_0_1;
	
	assign i_addr_row_left_1_1 	= o_addr_row_right_1_0;
	assign i_addr_col_left_1_1 	= o_addr_col_right_1_0;
	assign i_data_left_1_1 	= o_data_right_0_1;
	assign i_ready_left_1_1  = o_ready_right_0_1;
	assign i_valid_left_1_1  = o_valid_right_0_1;

    initial begin
        // Dump waves
        $dumpfile("smash_noc_top.vcd");
        //$dumpvars(1, smash_noc_top_tb);
        $dumpvars(0);

        i_clk = 1'b0;
        i_rst = 1'b1;

        toggle_clk;
		toggle_clk;

		i_rst = 'b0;

		toggle_clk;
		toggle_clk;

        $finish;
    end

    task toggle_clk;
    begin
        #1 i_clk = ~i_clk;
        #1 i_clk = ~i_clk;
    end
    endtask
endmodule
