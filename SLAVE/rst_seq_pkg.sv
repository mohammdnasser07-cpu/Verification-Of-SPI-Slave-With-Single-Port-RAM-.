package rst_sequence;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class slave_rst_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(slave_rst_seq);
        
        slave_seq_item seq_item;

        function new(string name = "slave_rst_seq");
            super.new(name);
        endfunction

        task body;
            seq_item = slave_seq_item :: type_id :: create ("seq_item");
            start_item(seq_item);
            seq_item.rst_n      = 0;
            seq_item.SS_n       = 1;
            seq_item.tx_valid   = 0;
            seq_item.tx_data    = 0;
            seq_item.MOSI       = 0;
            finish_item(seq_item); 
        endtask

    endclass
    
endpackage