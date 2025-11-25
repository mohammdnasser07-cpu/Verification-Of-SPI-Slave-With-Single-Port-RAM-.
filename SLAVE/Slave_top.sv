    import slave_test::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    module top ();
        bit clk;

        initial begin
            forever begin
                #1 clk = ~clk;
            end
        end
        
        slave_if slaveif (clk);
        SLAVE DUT (slaveif.MOSI, slaveif.MISO, slaveif.SS_n, clk, slaveif.rst_n, slaveif.rx_data, slaveif.rx_valid, slaveif.tx_data, slaveif.tx_valid);
        SPI_Slave_gold gold (slaveif.MOSI, slaveif.MISO_ref ,slaveif.SS_n ,clk ,slaveif.rst_n ,slaveif.rx_data_ref ,slaveif.rx_valid_ref ,slaveif.tx_data ,slaveif.tx_valid);

        bind SLAVE slave_sva checker_inst (.*);

        initial begin
            uvm_config_db #(virtual slave_if) :: set(null, "uvm_test_top", "slave_IF", slaveif);
            run_test("slave_test");
        end

    endmodule