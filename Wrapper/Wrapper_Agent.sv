package agent_pkg_wrapper;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import sequencer_pkg::*;
   import wrapper_driver::*;
   import monitor_wrap::*;
   import wrapper_config::*;
   import seq_item_pkg::*;

    class wrapper_agent extends uvm_agent;
        `uvm_component_utils(wrapper_agent);
        wrapper_sqr sqr;
        wrapper_driver drv;
        wrapper_monitor mon;
        wrapper_config_obj wrapper_cfg;
        uvm_analysis_port #(wrapper_seq_item) agt_ap;


        function new(string name = "wrapper_agent",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db #(wrapper_config_obj) :: get(this, "", "CFG_wrap", wrapper_cfg)) begin
                `uvm_fatal("build_phase","Unable to get configration object");
            end

            mon = wrapper_monitor :: type_id :: create("mon",this); 

            if(wrapper_cfg.is_active_wrapper == UVM_ACTIVE) begin
                sqr = wrapper_sqr     :: type_id :: create("sqr",this);
                drv = wrapper_driver  :: type_id :: create("drv",this);
            end
                                                        
            agt_ap = new("agt_ap", this);   
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);

            mon.wrapper_vif = wrapper_cfg.wrapper_config_vif; 
            mon.mon_ap.connect(agt_ap);
            
            if(wrapper_cfg.is_active_wrapper == UVM_ACTIVE) begin
                drv.wrapper_vif = wrapper_cfg.wrapper_config_vif;
                drv.seq_item_port.connect(sqr.seq_item_export);
            end
            
        endfunction

    endclass 
endpackage