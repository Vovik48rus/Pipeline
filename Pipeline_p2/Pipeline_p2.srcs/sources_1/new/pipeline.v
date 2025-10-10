module pipeline #(
    DATA_SIZE = 8,
    STAGE_COUNT = 16
)(
    input clk,
    input reset,
    input fifo_out_rdy,
    input valid_in,
    input [STAGE_COUNT-1:0] shift_rdy,
    input [DATA_SIZE-1:0] data_in,
    output [DATA_SIZE-1:0] data_out
);

reg [DATA_SIZE-1:0] pipe_reg [0:STAGE_COUNT-1];

always @(posedge clk)
    if (reset)
        pipe_reg[0] <= 0;
    else if (valid_in)
        pipe_reg[0] <= data_in;

assign data_out = pipe_reg[STAGE_COUNT-1];

genvar i;
generate
    for (i = 1; i < STAGE_COUNT; i = i + 1)
    begin  : pipeline_increment
        always @(posedge clk)
            if (reset)
                pipe_reg[i] <= 0;
            else if (shift_rdy[i])
                pipe_reg[i] <= pipe_reg[i-1] + 1;
            else
                pipe_reg[i] <= pipe_reg[i];
    end
endgenerate


endmodule
