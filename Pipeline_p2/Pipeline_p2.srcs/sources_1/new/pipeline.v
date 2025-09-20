`timescale 1ns / 1ps


module pipeline#(
    parameter DATA_SIZE = 8,
    parameter STAGE_COUNT = 16
)(
    input clk, reset, fifo_out_ready, valid_in,
    input [STAGE_COUNT - 1: 0] valid_stages_in,
    input [DATA_SIZE - 1: 0] data_in,
    output [DATA_SIZE - 1: 0] data_out
    );

reg [DATA_SIZE - 1: 0] pipe_reg [0: STAGE_COUNT - 1];

always@(posedge clk)
begin
    if (reset)
    begin
        pipe_reg[0] <= 0;
    end
    else if (valid_in && valid_stages_in[0])
    begin
        pipe_reg[0] <= data_in;
    end
end

assign data_out = pipe_reg[STAGE_COUNT - 1];

genvar i;
generate
    for (i = 1; i < STAGE_COUNT; i = i + 1)
    begin : pipeline_increment
        always@(posedge clk)
        begin
            if (reset)
            begin
                pipe_reg[i] <= 0;
            end
            else if (valid_stages_in[i - 1])
            begin
                pipe_reg[i] <= pipe_reg[i - 1] + 1;
            end
        end
    end
endgenerate

endmodule
