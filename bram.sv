`default_nettype none

// this code will infer block RAM (Xilinx)

module bram #(
  parameter WIDTH = 72,
  parameter DEPTH = 256,
  localparam DEPTH_LOG2 = $clog2(DEPTH)q
) (
  input wire clk,

  input wire [WIDTH-1:0] wdata,
  input wire [DEPTH_LOG2-1:0] waddr,
  input wire wen,

  output reg [WIDTH-1:0] rdata,
  input wire [DEPTH_LOG2-1:0] raddr,
  input wire ren
);

(* ram_style = "block" *) reg [WIDTH-1:0] ram [0:DEPTH-1];
// initialise ram to 0 (for sim)
initial begin
  for (int i = 0; i < DEPTH; i++)
    ram[i] = 0;
end

// write
always @(posedge clk) begin
  if (wen)
    ram[waddr] <= wdata;
end

// read
always @(posedge clk) begin
  if (ren)
    rdata <= ram[raddr];
end

endmodule

`default_nettype wire
