`default_nettype none

module async_fifo #(
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

localparam DEPTH_LOG2 = $clog2(DEPTH);

// binary to gray code conversion
function [DEPTH_LOG2-1:0] bin2gray;
  input [DEPTH_LOG2-1:0] bin;
begin
  bin2gray = (bin >> 1) ^ bin;
end
endfunction

// gray code to binay conversion
function [DEPTH_LOG2-1:0] gray2bin;
  input [DEPTH_LOG2-1:0] gray;
begin
  for (int i = 0; i < DEPTH_LOG2; i++)
    gray2bin[i] = ^(gray >> i);
end
endfunction

(* ram_style = "block" *) reg [WIDTH-1:0] mem [0:DEPTH-1];
initial begin
  for (int i = 0; i < DEPTH; i++)
    mem[i] = 0;
end

reg [DEPTH_LOG2-1:0] wptr;
always @(posedge wclk) begin
  if (wen) begin
    mem[wptr] <= wdata;
    wptr <= wptr + 1;
  end
end

reg [DEPTH_LOG2-1:0] rptr;
always @(posedge rclk) begin
  if (ren)
    rptr <= rptr + 1;
end
assign rdata = mem[rptr];

// fifo pointers

// rptr in wclk
reg [DEPTH_LOG2-1:0] rptr_gray_meta;
reg [DEPTH_LOG2-1:0] rptr_gray_sync;
always @(posedge wclk) begin
  rptr_gray_meta <= bin2gray(rptr);
  rptr_gray_sync <= rptr_gray_meta;
end
wire [DEPTH_LOG2-1:0] rptr_sync = gray2bin(rptr_gray_sync);

// wptr in rclk
reg [DEPTH_LOG2-1:0] wptr_gray_meta;
reg [DEPTH_LOG2-1:0] wptr_gray_sync;
always @(posedge rclk) begin
  wptr_gray_meta <= bin2gray(wptr);
  wptr_gray_sync <= wptr_gray_meta;
end
wire [DEPTH_LOG2-1:0] wptr_sync = gray2bin(wptr_gray_sync);

// flags
assign full = (wptr == rptr_sync);
assign empty = (rptr == wptr_sync);

endmodule

`default_nettype wire
