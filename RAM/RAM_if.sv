interface ram_if (clk);
  parameter MEM_WIDTH = 8 , MEM_DEPTH = 256 , ADDER_SIZE = 8;
  input clk;
  logic [MEM_WIDTH+1:0] din;
  bit rx_valid , clk , rst_n;
  bit tx_valid, tx_valid_ref;
  logic [MEM_WIDTH-1:0] dout, dout_ref;

endinterface : ram_if