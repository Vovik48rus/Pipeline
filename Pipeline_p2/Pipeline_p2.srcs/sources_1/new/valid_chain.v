`timescale 1ns / 1ps


module valid_chain#(
    parameter STAGE_COUNT = 16
)(
    input clk, reset, valid_in, fifo_out_ready,
    output [STAGE_COUNT - 1: 0] back_tracking
);

reg [STAGE_COUNT - 1: 0] valid_out;

always@(posedge clk)
begin
    if (reset)
    begin
        valid_out[0] <= 0; 
    end
    else if (back_tracking[0])
    begin
        valid_out[0] <= valid_in;
    end
end

assign back_tracking[STAGE_COUNT - 1] = fifo_out_ready || ~valid_out[STAGE_COUNT - 1];

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
            else if (back_tracking[i])
            begin
                valid_out[i] <= valid_out[i - 1];
            end
        end
    end
    
    for (i = 0; i < STAGE_COUNT - 1; i = i + 1)
    begin
        assign back_tracking[i] = (back_tracking[i + 1] && valid_out[i]) || ~valid_out[i];
    end
endgenerate
    
endmodule
