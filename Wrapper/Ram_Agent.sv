package agent_pkg_ram;
    import uvm_pkg::*;
   `include "uvm_macros.svh"
   import sequencer_pkg_ram::*;
   import ram_driver::*;
   import monitor_ram::*;
   import ram_config::*;
   import seq_item_pkg_ram::*;

    class ram_agent extends uvm_agent;
        `uvm_component_utils(ram_agent);
        ram_sqr sqr;
        ram_driver drv;
        ram_monitor mon;
        ram_config_obj ram_cfg;
        uvm_analysis_port #(ram_seq_item) agt_ap;

        function new(string name = "ram_agent",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(ram_config_obj) :: get(this, "", "CFG_ram", ram_cfg)) begin
                `uvm_fatal("build_phase","Unable to get configration object");
            end

            mon = ram_monitor :: type_id :: create("mon",this);

            if(ram_cfg.is_active_ram == UVM_ACTIVE) begin
                sqr = ram_sqr     :: type_id :: create("sqr",this);
                drv = ram_driver  :: type_id :: create("drv",this);
            end

            agt_ap = new("agt_ap", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            mon.ram_vif = ram_cfg.ram_config_vif;
            mon.mon_ap.connect(agt_ap);

            if(ram_cfg.is_active_ram == UVM_ACTIVE) begin
                drv.ram_vif = ram_cfg.ram_config_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            
        endfunction

    endclass 
endpackage