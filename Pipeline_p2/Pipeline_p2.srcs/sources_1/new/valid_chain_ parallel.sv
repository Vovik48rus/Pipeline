module valid_chain_parallel #(
    STAGE_COUNT = 16
)(
    input logic clk,
    input logic reset,
    input logic valid_in,
    input logic fifo_out_rdy,
    output logic [STAGE_COUNT-1:0] valid_out,
    output wire [STAGE_COUNT-1:0] shift_rdy
);

assign shift_rdy[0] = ~(&valid_out[STAGE_COUNT-1:0]);

always_ff @(posedge clk) begin              : valid_chain_first
    if (reset)
        valid_out[0] <= 0;
    else if (fifo_out_rdy | shift_rdy[1])
        valid_out[0] <= valid_in;
    else
        valid_out[0] <= valid_out[0];
end                                         : valid_chain_first

genvar i;
for (i = 1; i < STAGE_COUNT-1; i++) begin   : valid_chain_middle
    assign shift_rdy[i] = ~(&valid_out[STAGE_COUNT-1:i]);
    always_ff @(posedge clk)
        if (reset)
            valid_out[i] <= 0;
        else if (fifo_out_rdy | shift_rdy[i])
            valid_out[i] <= valid_out[i-1];
        else
            valid_out[i] <= valid_out[i];
end                                         : valid_chain_middle

assign shift_rdy[STAGE_COUNT-1] = ~valid_out[STAGE_COUNT-1];

always_ff @(posedge clk)
    if (reset)
        valid_out[STAGE_COUNT-1] <= 0;
    else if (fifo_out_rdy | ~valid_out[STAGE_COUNT-1])
        valid_out[STAGE_COUNT-1] <= valid_out[STAGE_COUNT-2];
    else
        valid_out[STAGE_COUNT-1] <= valid_out[STAGE_COUNT-1];

endmodule