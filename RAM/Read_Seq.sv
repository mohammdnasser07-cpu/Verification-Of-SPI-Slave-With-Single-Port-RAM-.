package read_sequence;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class ram_read_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_read_seq);
        
        ram_seq_item seq_item;
        operation_t prev_op;

        function new(string name = "ram_read_seq");
                super.new(name);
        endfunction

        task body;
            seq_item = ram_seq_item :: type_id :: create ("seq_item");
            prev_op = READ_ADDR; // Start with Rrad Address

            repeat (10000) begin
            start_item(seq_item);
            if (!seq_item.randomize() with { 
                    seq_item.din[9:8] inside {2'b10, 2'b11};
                    if (prev_op == READ_ADDR) {
                        seq_item.din[9:8] inside {READ_ADDR, READ_DATA};
                    } else if (prev_op == READ_DATA) {
                        seq_item.din[9:8] == READ_ADDR; // After Read Data, go back to Read Address
                    }
                }) begin
                    `uvm_error("RAND_FAIL", "Randomization failed in read sequence")
                end
                
                prev_op = operation_t'(seq_item.din[9:8]);
                seq_item.prev_op = prev_op;

            finish_item(seq_item);
            end
        endtask

    endclass           
                 
endpackage          