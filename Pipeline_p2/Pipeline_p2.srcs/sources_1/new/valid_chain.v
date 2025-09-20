`timescale 1ns / 1ps


module valid_chain#(
    parameter STAGE_COUNT = 16
)(
    input clk, reset, valid_in, fifo_out_ready,
    output reg [STAGE_COUNT - 1: 0] valid_out
);

always@(posedge clk)
begin
    if (reset)
    begin
        valid_out[0] <= 0; 
    end
    else if (fifo_out_ready)
    begin
        valid_out[0] <= valid_in;
    end
end

genvar i;
generate
    for (i = 1; i < STAGE_COUNT; i = i + 1)
    begin : valid_chain
        always@(posedge clk)
        begin
            if (reset)
            begin
                valid_out[i] <= 0;
            end
            else if (fifo_out_ready)
            begin
                valid_out[i] <= valid_out[i - 1];
            end
        end
    end
endgenerate
    
endmodule
