package Write_Read_sequence;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class ram_Write_Read_seq extends uvm_sequence #(ram_seq_item);
        `uvm_object_utils(ram_Write_Read_seq);
        
        ram_seq_item seq_item;
        operation_t prev_op;

        function new(string name = "ram_Write_Read_seq");
                super.new(name);
        endfunction

        task body;
            seq_item = ram_seq_item :: type_id :: create ("seq_item");
            prev_op = WRITE_ADDR; // Start with Write Address

            repeat (10000) begin
            start_item(seq_item);
            if (!seq_item.randomize() with { 
                    
                    // Write Address followed by Write Address or Write Data
                    if (prev_op == WRITE_ADDR) {
                        seq_item.din[9:8] inside {WRITE_ADDR, WRITE_DATA};
                    }
                    // After Write Data: 60% Read Address, 40% Write Address
                    else if (prev_op == WRITE_DATA) {
                        seq_item.din[9:8] dist { READ_ADDR := 60, WRITE_ADDR := 40 };
                    }
                    // Read Address followed by Read Address or Read Data
                    else if (prev_op == READ_ADDR) {
                        seq_item.din[9:8] inside {READ_ADDR, READ_DATA};
                    }
                    // After Read Data: 60% Write Address, 40% Read Address
                    else if (prev_op == READ_DATA) {
                        seq_item.din[9:8] dist { WRITE_ADDR := 60, READ_ADDR := 40 };
                    }
                }) begin 
                    `uvm_error("RAND_FAIL", "Randomization failed in write_read sequence")
                end
                
                prev_op = operation_t'(seq_item.din[9:8]);
                seq_item.prev_op = prev_op;
                
            finish_item(seq_item);
            end
        endtask

    endclass           
                 
endpackage          