`timescale 1ns / 1ps


module test;

reg clk;
always #10 clk <= ~clk;

reg reset, fifo_out_ready, valid_in;

initial
begin
    clk = 0;
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
//    repeat (12)
//        @(posedge clk);
//    valid_in = 1;
    repeat (3)
        @(posedge clk);
    valid_in = 1;
    repeat (3)
        @(posedge clk);
    valid_in = 0;
    repeat (12)
        @(posedge clk);
    fifo_out_ready = 1;
    repeat (12)
        @(posedge clk);
    $finish;
end

top #(
    .DATA_SIZE(8),
    .STAGE_COUNT(16)
) top_unit (
    .clk(clk),
    .reset(reset),
    .fifo_out_ready(fifo_out_ready),
    .valid_in(valid_in),
    .data_in(5),
    .data_out(data_out),
    .valid_out(valid_out)
);


endmodule
