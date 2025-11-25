package cov_pkg_wrapper;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;
    import shared_pkg::*;

    class wrapper_coverage extends uvm_component;
    `uvm_component_utils(wrapper_coverage);

    uvm_analysis_export   #(wrapper_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(wrapper_seq_item) cov_fifo;
    wrapper_seq_item seq_item_cov;

        covergroup CovCode;
            cp_ssn: coverpoint seq_item_cov.SS_n {
                bins normal_trans = (1 => 0 [*13] => 1);
                bins read_trans   = (1 => 0 [*23] => 1);
            }
        endgroup

    function new(string name = "wrapper_coverage",uvm_component parent = null);
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
              //  CovCode.sample();
            end
    endtask

    endclass
endpackage