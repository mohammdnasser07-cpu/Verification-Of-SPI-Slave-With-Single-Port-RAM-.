// SPI_Wrapper

module SPI_Wrapper(MOSI ,MISO ,SS_n ,clk ,rst_n);
    input MOSI ,SS_n ,clk ,rst_n;
    output MISO;

    wire rx_valid , tx_valid;
    wire [9:0] rx_data;
    wire [7:0]tx_data;

    SPI_Slave_gold DUT (MOSI ,MISO ,SS_n ,clk ,rst_n ,rx_data ,rx_valid ,tx_data ,tx_valid);
    RAM_gold dut (rx_data , rx_valid , tx_valid , clk , rst_n , tx_data);


endmodule