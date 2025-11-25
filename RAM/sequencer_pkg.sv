package sequencer_pkg;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg::*;

    class ram_sqr extends uvm_sequencer #(ram_seq_item);
        `uvm_component_utils(ram_sqr);
        function new(string name = "ram_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction
    endclass
endpackage