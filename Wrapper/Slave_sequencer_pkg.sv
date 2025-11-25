package sequencer_pkg_slave;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
    import seq_item_pkg_slave::*;

    class slave_sqr extends uvm_sequencer #(slave_seq_item);
        `uvm_component_utils(slave_sqr);
        function new(string name = "slave_sqr", uvm_component parent = null);
            super.new(name,parent);
        endfunction
    endclass
endpackage