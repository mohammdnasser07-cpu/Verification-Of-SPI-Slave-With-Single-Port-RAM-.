    import wrapper_test::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    module top ();
        bit clk;

        initial begin
            forever begin
                #1 clk = ~clk;
            end
        end

        wrapper_if wrapif (clk);
        slave_if slaveif (clk); 
        ram_if ramif (clk); 

        WRAPPER DUT_1 (wrapif.MOSI,wrapif.MISO,wrapif.SS_n,clk,wrapif.rst_n);
        SPI_Wrapper golden_1 (wrapif.MOSI ,wrapif.MISO_ref ,wrapif.SS_n ,clk ,wrapif.rst_n);

            assign ramif.rx_valid= DUT_1.rx_valid;
            assign ramif.din = DUT_1.rx_data_din;
            assign ramif.tx_valid= DUT_1.tx_valid;
            assign ramif.dout = DUT_1.tx_data_dout;
            assign ramif.rst_n    = DUT_1.rst_n;

            assign ramif.tx_valid_ref= golden_1.tx_valid;
            assign ramif.dout_ref = golden_1.tx_data;


            assign slaveif.MOSI= DUT_1.MOSI; 
            assign slaveif.MISO = DUT_1.MISO;
            assign slaveif.tx_valid= DUT_1.tx_valid;
            assign slaveif.tx_data = DUT_1.tx_data_dout;
            assign slaveif.rx_data    = DUT_1.rx_data_din;
            assign slaveif.rx_valid    = DUT_1.rx_valid;
            assign slaveif.rst_n    = DUT_1.rst_n;
            assign slaveif.SS_n    = DUT_1.SS_n;

            assign slaveif.rx_data_ref= golden_1.rx_data;
            assign slaveif.rx_valid_ref = golden_1.rx_valid;
            assign slaveif.MISO_ref = golden_1.MISO; 
            
       
        bind WRAPPER wrapper_sva checker1_inst (.*);
        bind SLAVE slave_sva checker2_inst (.*);
        bind RAM ram_sva checker3_inst (.*); 

        initial begin 
            $readmemh("mem.dat",DUT_1.RAM_instance.MEM);
            $readmemh("mem.dat",golden_1.dut.mem);
            uvm_config_db #(virtual wrapper_if) :: set(null,"uvm_test_top","Wrapper_IF",wrapif);
            uvm_config_db #(virtual slave_if)   :: set(null,"uvm_test_top","Slave_IF",slaveif);
            uvm_config_db #(virtual ram_if)     :: set(null,"uvm_test_top","Ram_IF",ramif);

            run_test("wrapper_test");
        end


    endmodule