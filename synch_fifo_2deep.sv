`default_nettype none

// synchronous 2-deep fifo

module synch_fifo_2deep #(
  parameter WIDTH = 32
) (
  input wire clk,

  input wire [WIDTH-1:0] wdata,
  input wire wen,
  output wire wrdy,

  output reg [WIDTH-1:0] rdata,
  input wire ren,
  output wire rrdy
);

reg [WIDTH-1:0] buffer [0:1];
reg [1:0] wptr = 0;
reg [1:0] rptr = 0;

wire full = (wptr[1] != rptr[1]) && (wptr[0] == rptr[0]);
wire empty = (wptr == rptr);
assign wrdy = !full;
assign rrdy = !empty;

always @(posedge clk) begin
  if (wrdy && wen) begin
    buffer[wptr[0]] <= wdata;
    wptr <= wptr + 1;
  end
end

wire [1:0] rptr_next = (rrdy && ren) ? rptr + 1 : rptr;
always @(posedge clk) begin
  rptr <= rptr_next;
end
assign rdata = buffer[rptr[0]];

endmodule

`default_nettype wire
