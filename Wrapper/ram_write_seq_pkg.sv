package write_sequence_ram;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_ram::*;

    class ram_write_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_write_seq);
         
        ram_seq_item seq_item;
        operation_t prev_op;

        function new(string name = "ram_write_seq");
                super.new(name);
        endfunction

        task body;
            seq_item = ram_seq_item :: type_id :: create ("seq_item");
            prev_op = WRITE_ADDR; // Start with Write Address

            repeat (10000) begin
            start_item(seq_item);
            
                // Constraint 3: Write Address followed by Write Address or Write Data
                if (!seq_item.randomize() with { 
                    seq_item.din[9:8] inside {2'b00, 2'b01};
                    if (prev_op == WRITE_ADDR) {
                        seq_item.din[9:8] inside {WRITE_ADDR, WRITE_DATA};
                    } else if (prev_op == WRITE_DATA) {
                        seq_item.din[9:8] == WRITE_ADDR; // After Write Data, go back to Write Address
                    }
                }) begin
                    `uvm_error("RAND_FAIL", "Randomization failed in write sequence")
                end
                
                prev_op = operation_t'(seq_item.din[9:8]);
                seq_item.prev_op = prev_op;
                
            finish_item(seq_item);
            end
        endtask

    endclass           
                 
endpackage          