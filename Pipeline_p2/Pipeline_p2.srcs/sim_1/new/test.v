module test;

reg clk = 0;
always #10 clk <= ~clk;
reg reset, fifo_out_rdy, valid_in;

initial
begin
    reset = 1;
    @(posedge clk);
    @(posedge clk);
    reset = 0; fifo_out_rdy = 1; valid_in = 1;
    @(posedge clk);
    @(posedge clk);
    fifo_out_rdy = 0; valid_in = 0;
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    valid_in = 1;
    @(posedge clk);
    valid_in = 0;
    @(posedge clk);
end

wire [7:0] data_out;
Top #(
    .DATA_SIZE(8),
    .STAGE_COUNT(16)
) uut (
    .clk(clk),
    .reset(reset),
    .fifo_out_rdy(fifo_out_rdy),
    .valid_in(valid_in),
    .data_in(1),
    .data_out(data_out),
    .valid_out(valid_out)
);

endmodule
