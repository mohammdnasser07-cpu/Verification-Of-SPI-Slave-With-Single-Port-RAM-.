package slave_config;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_config_obj extends uvm_object;
        `uvm_object_utils(slave_config_obj);

        virtual slave_if slave_config_vif;  

        function new(string name = "slave_config_obj");
            super.new(name);
        endfunction

    endclass


endpackage  