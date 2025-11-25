package scoreboard_pkg_ram;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_ram::*;

    class ram_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ram_scoreboard);
        uvm_analysis_export #(ram_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(ram_seq_item) sb_fifo;
        ram_seq_item seq_item_sb;


        int error_count   = 0;
        int correct_count = 0;

        function new(string name = "ram_scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo   = new("sb_fifo",this); 
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                if(seq_item_sb.tx_valid != seq_item_sb.tx_valid_ref || seq_item_sb.dout != seq_item_sb.dout_ref) begin
                    //`uvm_error ("run_phase",$sformatf("comparsion failed, transaction received by the DUT:%s while the reference out_ref:0b%0b",seq_item_sb.convert2string(), 
                              //  seq_item_sb.tx_valid_ref, seq_item_sb.dout_ref));
                    $display("tx_valid = %h, tx_valid_ref = %h, dout = %h, dout_ref = %h, rst_n = %h, rx_valid = %h", seq_item_sb.tx_valid, seq_item_sb.tx_valid_ref, seq_item_sb.dout, seq_item_sb.dout_ref, seq_item_sb.rst_n, seq_item_sb.rx_valid);
                    error_count++;
                end
                else begin
                   // `uvm_info("run_phase",$sformatf("correct out_refputs : %s ", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
             
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf(" Successful transactions of RAM : %d ", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf(" failed transactions of RAM     : %d ", error_count), UVM_MEDIUM);
        endfunction

    endclass

endpackage