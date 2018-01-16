`timescale 1ns / 1ps

module smash_fifo_tb;
    parameter ADDR_SIZE_FIFO = 2;
    parameter DATA_SIZE      = 32;

    reg                  i_clk, i_rst, i_write, i_read;
    reg  [DATA_SIZE-1:0] i_data;
    wire [DATA_SIZE-1:0] o_data;
    wire                 o_full;
    wire                 o_empty;

    smash_fifo #(ADDR_SIZE_FIFO, DATA_SIZE) DUT (
        .i_clk    (i_clk),
        .i_rst    (i_rst),
        .i_write  (i_write),
        .i_read   (i_read),
        .i_data   (i_data),
        .o_data   (o_data),
        .o_full   (o_full),
        .o_empty  (o_empty)
    );

    initial begin
        // Dump waves
        $dumpfile("smash_fifo.vcd");
        //$dumpvars(1, smash_fifo_tb);
        $dumpvars(0);

        i_clk = 1'b1;
        i_rst = 1'b1;
        i_write = 1'b0;
        i_read = 1'b0;
        i_data = 32'b0;//DATA_SIZE'b0;

        toggle_clk;
        toggle_clk;
        i_rst = 1'b0;
        toggle_clk;

        i_data  <= 32'hAAAA5555;
        i_write <= 1'b1;
        toggle_clk;

        i_data  <= 32'hCAFEBABE;
        i_write <= 1'b1;
        toggle_clk;

        i_data  <= 32'hFFFFFFFF;
        i_write <= 1'b1;
        toggle_clk;

        i_write <= 1'b0;
        i_read  <= 1'b1;
        toggle_clk;
        toggle_clk;
        toggle_clk;
        toggle_clk;

        i_write <= 1'b1;
        i_read  <= 1'b0;
        i_data  <= 32'h22222222;
        toggle_clk;

        i_write <= 1'b1;
        i_read  <= 1'b1;
        i_data  <= 32'h11111111;
        toggle_clk;

        i_write <= 1'b0;
        i_read  <= 1'b0;
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
