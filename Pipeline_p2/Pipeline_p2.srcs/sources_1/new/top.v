module Top #(
    parameter DATA_SIZE = 8,
    parameter STAGE_COUNT = 64
)(
    input clk,
    input reset,
    input fifo_out_rdy,
    input valid_in,
    input [DATA_SIZE-1:0] data_in,
    output [DATA_SIZE-1:0] data_out,
    output valid_out
);

wire [STAGE_COUNT-1:0] valid_stages;
wire [STAGE_COUNT-1:1] shift_rdy;

pipeline #(
    .DATA_SIZE(DATA_SIZE),
    .STAGE_COUNT(STAGE_COUNT)
) pipeline_unit (
    .clk(clk),
    .reset(reset),
    .fifo_out_rdy(fifo_out_rdy),
    .valid_in(valid_in),
    .shift_rdy(shift_rdy),
    .data_in(data_in),
    .data_out(data_out)
);

valid_chain_parallel #(
    .STAGE_COUNT(STAGE_COUNT)
) valid_chain_unit (
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .fifo_out_rdy(fifo_out_rdy),
    .valid_out(valid_stages),
    .shift_rdy(shift_rdy)
);

assign valid_out = valid_stages[STAGE_COUNT-1];

endmodule
