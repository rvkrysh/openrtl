`default_nettype none

// this code will infer ultraRAM (Xilinx)

module uram #(
  parameter OREG = 0
) (
  input wire clk,

  input wire [71:0] wdata,
  input wire [11:0] waddr,
  input wire wen,

  output reg [71:0] rdata,
  input wire [11:0] raddr,
  input wire ren
);

localparam DEPTH = 4096; // fixed for uram
(* ram_style = "ultra" *) reg [71:0] ram [0:DEPTH-1];
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
reg [71:0] rdata_int;
always @(posedge clk) begin
  if (ren)
    rdata_int <= ram[raddr];
end

// optional pipeline for read
generate
  if (OREG) begin
    always @(posedge clk) rdata <= rdata_int;
  end else begin
    always @(*) rdata = rdata_int;
  end
endgenerate

endmodule

`default_nettype wire
