package scoreboard_pkg_slave;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_slave::*;

    class slave_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(slave_scoreboard);
        uvm_analysis_export #(slave_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(slave_seq_item) sb_fifo;
        slave_seq_item seq_item_sb;


        int error_count   = 0;
        int correct_count = 0;

        function new(string name = "slave_scoreboard",uvm_component parent = null);
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
                if(seq_item_sb.rx_data != seq_item_sb.rx_data_ref || seq_item_sb.rx_valid != seq_item_sb.rx_valid_ref || seq_item_sb.MISO != seq_item_sb.MISO_ref) begin
                    //`uvm_error ("run_phase",$sformatf("comparsion failed, transaction received by the DUT:%s while the reference out_ref:0b%0b",seq_item_sb.convert2string(), 
                                //seq_item_sb.rx_data_ref, seq_item_sb.rx_valid, seq_item_sb.MISO_ref));
                                $display("rx_data = %h, rx_data_ref = %h, rx_valid = %h, rx_valid_ref = %h, MISO_ref = %h, MISO = %h, rst_n = %h, SS_n = %h", seq_item_sb.rx_data, seq_item_sb.rx_data_ref, seq_item_sb.rx_valid, seq_item_sb.rx_valid_ref, seq_item_sb.MISO_ref, seq_item_sb.MISO, seq_item_sb.rst_n, seq_item_sb.SS_n);
                    error_count++;
                end
                else begin
                    `uvm_info("run_phase",$sformatf("correct out_ref outputs : %s ", seq_item_sb.convert2string()), UVM_HIGH);
                    correct_count++;
                end
            end
             
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf(" Successful transactions of Slave : %d ", correct_count), UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf(" failed transactions of Slave     : %d ", error_count), UVM_MEDIUM);
        endfunction

    endclass

endpackage