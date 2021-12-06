`default_nettype none

module top #(
  parameter WIDTH = 36,
  parameter DEPTH = 256
) (
  input wire wclk,
  input wire wen,
  input wire [WIDTH-1:0] wdata,

  input wire rclk,
  input wire ren,
  output reg [WIDTH-1:0] rdata,

  output reg empty,
  output reg full
);

async_fifo #(
  .WIDTH(WIDTH),
  .DEPTH(DEPTH)
) async_fifo_inst (
  .wclk(wclk),
  .wen(wen),
  .wdata(wdata),
  .rclk(rclk),
  .ren(ren),
  .rdata(rdata),
  .empty(empty),
  .full(full)
);

endmodule

`default_nettype wire
