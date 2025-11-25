package write_sequence;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class wrapper_write_seq extends uvm_sequence #(wrapper_seq_item);
        `uvm_object_utils(wrapper_write_seq);
        
        wrapper_seq_item seq_item;

        function new(string name = "wrapper_write_seq");
                super.new(name);
        endfunction
 
        task body();
            seq_item = wrapper_seq_item::type_id::create("seq_item");
            // write sequence
            seq_item.read_constraint.constraint_mode(0);
            seq_item.read_constraint.constraint_mode(0);
            repeat (1000) begin
                start_item(seq_item);
                if (seq_item.SS_n) begin
                    seq_item.MOSI_bins.rand_mode(1);
                    seq_item.write_constraint.constraint_mode(1);
                end
                else begin
                    seq_item.MOSI_bins.rand_mode(0);
                    seq_item.write_constraint.constraint_mode(0);
                    assert(seq_item.randomize() with {seq_item.MOSI_bins[10:8] inside {3'b000 , 3'b001};});  
                end
                
                finish_item(seq_item); 
            end 
        endtask

  endclass

endpackage         