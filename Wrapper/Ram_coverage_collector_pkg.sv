package cov_pkg_ram;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_ram::*;

    class ram_coverage extends uvm_component;
    `uvm_component_utils(ram_coverage);

    uvm_analysis_export   #(ram_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(ram_seq_item) cov_fifo;
    ram_seq_item seq_item_cov;

           
        covergroup CovCode;
            // 1. [9:8] coverpoint
            cp_din: coverpoint seq_item_cov.din[9:8] {
                bins IDLE              = {2'b00};
                bins WRITE             = {2'b01};
                bins READ_ADD          = {2'b10};
                bins READ_DATA         = {2'b11};
                bins transitions1      = (2'b00 => 2'b01);
                bins transitions2      = (2'b10 => 2'b11);
             //   bins total_transitions = (2'b00 => 2'b01 => 2'b10 => 2'b11);
            }

              // 2. rx_valid coverpoint
            cp_rx_valid: coverpoint seq_item_cov.rx_valid {
                bins rx_high = {1};
                bins rx_low  = {0};
            }

            cp_tx_valid: coverpoint seq_item_cov.tx_valid {
                bins tx_high = {1};
                bins tx_low  = {0}; 
            }

            //cross coverage  1
            cp_din__cp_rx_valid_1 : cross cp_din, cp_rx_valid {
                //option.cross_auto_bin_max = 0;
                bins cross_1 = binsof(cp_rx_valid.rx_high) && binsof(cp_din);
            }

            //cross coverage  2
            cp_din__cp_rx_valid_2 : cross cp_din, cp_tx_valid {
                option.cross_auto_bin_max = 0;
                bins cross_2 = binsof(cp_din.READ_DATA) && binsof(cp_tx_valid.tx_high); 
            }



        endgroup

    function new(string name = "ram_coverage",uvm_component parent = null);
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