package agent_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import sequencer_pkg::*;
   import slave_driver::*;
   import monitor::*;
   import slave_config::*;
   import seq_item_pkg::*;

    class slave_agent extends uvm_agent;
        `uvm_component_utils(slave_agent);
        slave_sqr sqr;
        slave_driver drv;
        slave_monitor mon;
        slave_config_obj slave_cfg;
        uvm_analysis_port #(slave_seq_item) agt_ap;

        function new(string name = "slave_agent",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(slave_config_obj) :: get(this, "", "CFG", slave_cfg)) begin
                `uvm_fatal("build_phase","Unable to get configration object");
            end

            sqr = slave_sqr     :: type_id :: create("sqr",this);
            drv = slave_driver  :: type_id :: create("drv",this);
            mon = slave_monitor :: type_id :: create("mon",this);

            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.slave_vif = slave_cfg.slave_config_vif;
            mon.slave_vif = slave_cfg.slave_config_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass
endpackage