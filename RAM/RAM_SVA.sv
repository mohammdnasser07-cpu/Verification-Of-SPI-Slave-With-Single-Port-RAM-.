module  ram_sva (
    input  clk,
    input  rx_valid,
    input  rst_n,
    input  [9:0] din,
    input  tx_valid,
    input  [7:0] dout
);

    localparam IDLE      = 3'b000;
    localparam WRITE     = 3'b001;
    localparam CHK_CMD   = 3'b010;
    localparam READ_ADD  = 3'b011;
    localparam READ_DATA = 3'b100;

    
   // Assertions 

    // rst Assertion 
    rst_assert:assert        property  (@(posedge clk) !rst_n |=> (!tx_valid && !dout)); 
    rst_cover:cover          property  (@(posedge clk) !rst_n |=> (!tx_valid && !dout));

    // tx_valid 1 Assertion 
    tx_valid_1_assert:assert property  (@(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b00 || din[9:8] == 2'b01 || din[9:8] == 2'b10) |=> (!tx_valid));
    tx_valid_1_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (din[9:8] == 2'b00 || din[9:8] == 2'b01 || din[9:8] == 2'b10) |=> (!tx_valid));

    // tx_valid 2 Assertion 
    tx_valid_2_assert:assert property  (@(posedge clk) disable iff (!rst_n) (din[9] && din[8] && rx_valid) |=> $rose(tx_valid) ##1 $fell(tx_valid) [->1]); 
    tx_valid_2_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (din[9] && din[8] && rx_valid) |=> $rose(tx_valid) ##1 $fell(tx_valid) [->1]);  

    // write Assertion 
    write_assert:assert      property  (@(posedge clk) disable iff (!rst_n) (rx_valid && din[9:8] == 2'b00) |=> (din[9:8] == 2'b01) [->1]); 
    write_cover:cover        property  (@(posedge clk) disable iff (!rst_n) (rx_valid && din[9:8] == 2'b00) |=> (din[9:8] == 2'b01) [->1]);   

    // read Assertion 
    read_assert:assert       property  (@(posedge clk) disable iff (!rst_n) (rx_valid && din[9:8] == 2'b10) |=> (din[9:8] == 2'b11) [->1]); 
    read_cover:cover         property  (@(posedge clk) disable iff (!rst_n) (rx_valid && din[9:8] == 2'b10) |=> (din[9:8] == 2'b11) [->1]);  

     


endmodule