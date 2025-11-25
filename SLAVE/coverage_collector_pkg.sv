package cov_pkg;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class slave_coverage extends uvm_component;
    `uvm_component_utils(slave_coverage);

    uvm_analysis_export   #(slave_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(slave_seq_item) cov_fifo;
    slave_seq_item seq_item_cov;

        covergroup CovCode;
            // 1. rx_data[9:8] coverpoint
            cp_cmd: coverpoint seq_item_cov.rx_data[9:8] {
                bins IDLE      = {2'b00};
                bins WRITE     = {2'b01};
                bins READ_ADD  = {2'b10};
                bins READ_DATA = {2'b11};
            }

              // 2. SS_n coverpoint
            cp_ssn: coverpoint seq_item_cov.SS_n {
                bins normal_trans = (1 => 0 [*13] => 1);
                bins read_trans   = (1 => 0 [*23] => 1);
            }

            // 3. MOSI coverpoint
            cp_mosi: coverpoint seq_item_cov.MOSI {
                bins trans1 = (0 => 0 => 0);
                bins trans2 = (0 => 0 => 1);
                bins trans3 = (1 => 1 => 0);
                bins trans4 = (1 => 1 => 1);
            }


        endgroup

    function new(string name = "slave_coverage",uvm_component parent = null);
        super.new(name,parent);
            CovCode = new ();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export",this);
        cov_fifo   = new("cov_fifo",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                CovCode.sample();
            end
    endtask
    

    endclass

endpackage