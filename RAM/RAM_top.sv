    import ram_test::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    module top ();
        bit clk;

        initial begin
            forever begin
                #1 clk = ~clk;
            end
        end

        ram_if ramif (clk);
        RAM DUT (ramif.din,clk,ramif.rst_n,ramif.rx_valid,ramif.dout,ramif.tx_valid);
        RAM_gold gold (ramif.din , ramif.rx_valid , ramif.tx_valid_ref , clk , ramif.rst_n , ramif.dout_ref);
       
        bind RAM ram_sva checker_inst (.*);

        initial begin
            uvm_config_db #(virtual ram_if) :: set(null, "uvm_test_top", "ram_IF", ramif);
            run_test("ram_test");
        end

    endmodule