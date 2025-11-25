package main_sequence;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_slave::*;

    class slave_main_seq extends uvm_sequence #(slave_seq_item);
        `uvm_object_utils(slave_main_seq);
        
        slave_seq_item seq_item;

        function new(string name = "slave_main_seq");
                super.new(name);
        endfunction 

        task body ;
        seq_item= slave_seq_item :: type_id :: create("seq_item");
        repeat(10000) begin
            start_item(seq_item);
            if (seq_item.SS_n)
                seq_item.MOSI_bins.rand_mode(1);
            else 
                seq_item.MOSI_bins.rand_mode(0);

            assert (seq_item.randomize());
            finish_item(seq_item); 

        end 
        endtask 

 endclass
 
endpackage       