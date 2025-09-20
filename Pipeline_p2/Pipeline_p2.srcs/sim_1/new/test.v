`timescale 1ns / 1ps


module test;

localparam DATA_SIZE = 8;
localparam STAGE_COUNT = 16;

reg clk;
always #10 clk <= ~clk;

reg reset, fifo_out_ready, valid_in;

reg [DATA_SIZE-1:0] data_in;

initial
begin
    clk = 0;
    data_in = 5;
    reset = 1;
    fifo_out_ready = 0;
    valid_in = 0;
    @(posedge clk);
    @(posedge clk);
    reset = 0;
    fifo_out_ready = 1;
    valid_in = 1;
    repeat (6)
        @(posedge clk);
    fifo_out_ready = 0;
    @(posedge clk);
    @(posedge clk);
    valid_in = 0;
    data_in = 0;
//    repeat (12)
//        @(posedge clk);
//    valid_in = 1;
    repeat (3)
        @(posedge clk);
    valid_in = 1;
    data_in = 10;
    repeat (3)
        @(posedge clk);
    valid_in = 0;
    data_in = 0;
    repeat (12)
        @(posedge clk);
    fifo_out_ready = 1;
    repeat (12)
        @(posedge clk);
    $finish;
end

top #(
    .DATA_SIZE(DATA_SIZE),
    .STAGE_COUNT(STAGE_COUNT)
) top_unit (
    .clk(clk),
    .reset(reset),
    .fifo_out_ready(fifo_out_ready),
    .valid_in(valid_in),
    .data_in(data_in),
    .data_out(data_out),
    .valid_out(valid_out)
);


endmodule
