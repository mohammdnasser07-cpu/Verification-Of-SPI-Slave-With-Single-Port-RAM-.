package sequencer_pkg_ram;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_ram::*;

    class ram_sqr extends uvm_sequencer #(ram_seq_item);
        `uvm_component_utils(ram_sqr);
        function new(string name = "ram_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction
    endclass
endpackage