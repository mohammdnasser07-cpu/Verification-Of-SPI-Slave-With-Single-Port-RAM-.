module  slave_sva (
    input  clk,
    input  MOSI,
    input  rst_n,
    input  SS_n,
    input  tx_valid,
    input  [7:0] tx_data,
    input  [9:0] rx_data,
    input  rx_valid, 
    input  MISO,
    input  [2:0] cs,
    input  [2:0] ns 
);


       // Assertions 

    // rst Assertion 
    rst_assert:assert        property  (@(posedge clk) !rst_n |=> ((!MISO && !rx_valid && !rx_data))); 
    rst_cover:cover          property  (@(posedge clk) !rst_n |=> ((!MISO && !rx_valid && !rx_data)));

    // Assertion 2 
    tx_valid_1_assert:assert property  (@(posedge clk) disable iff (!rst_n) (rx_data[9:7] == 2'b000 || rx_data[9:7] == 2'b001 || rx_data[9:7] == 2'b110 || rx_data[9:7] == 2'b111) |-> ##10 (rx_valid) && SS_n [->1]);
    tx_valid_1_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (rx_data[9:7] == 2'b000 || rx_data[9:7] == 2'b001 || rx_data[9:7] == 2'b110 || rx_data[9:7] == 2'b111) |-> ##10 (rx_valid) && SS_n [->1]);




endmodule 