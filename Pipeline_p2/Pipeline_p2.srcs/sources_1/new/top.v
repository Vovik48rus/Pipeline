`timescale 1ns / 1ps


module top#(
    parameter DATA_SIZE = 8,
    parameter STAGE_COUNT = 16
)(
    input clk, reset, fifo_out_ready, valid_in,
    input [DATA_SIZE - 1: 0] data_in,
    output [DATA_SIZE - 1: 0] data_out,
    output valid_out
);

wire [STAGE_COUNT - 1: 0] valid_stages;

pipeline #(
    .DATA_SIZE(DATA_SIZE),
    .STAGE_COUNT(STAGE_COUNT)
) pipeline_unit (
    .clk(clk),
    .reset(reset),
    .fifo_out_ready(fifo_out_ready),
    .data_in(data_in),
    .data_out(data_out),
    .valid_in(valid_in),
    .valid_stages_in(valid_stages)
);

valid_chain #(
    .STAGE_COUNT(STAGE_COUNT)
) valid_chain_unit (
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .fifo_out_ready(fifo_out_ready),
    .valid_out(valid_stages)
);

assign valid_out = valid_stages[STAGE_COUNT - 1];

endmodule
