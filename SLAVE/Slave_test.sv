package slave_test;
    import slave_env::*;
    import slave_config::*;
    import main_sequence::*;
    import rst_sequence::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class slave_test extends uvm_test;
        `uvm_component_utils(slave_test);

        slave_config_obj slave_config_obj_test;    
        slave_env env;
        slave_main_seq main_seq;
        slave_rst_seq rst_seq;


        function new(string name = "slave_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction  

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = slave_env                         :: type_id :: create("env",this);
            slave_config_obj_test = slave_config_obj :: type_id :: create("slave_config_obj_test");
            main_seq = slave_main_seq               :: type_id :: create ("main_seq");
            rst_seq  = slave_rst_seq                :: type_id :: create ("rst_seq");

            if(!uvm_config_db #(virtual slave_if) :: get(this, "", "slave_IF", slave_config_obj_test.slave_config_vif))
                `uvm_fatal("build_phase", " test -  unable to get the virtual interface");

            uvm_config_db #(slave_config_obj) :: set(this, "*", "CFG", slave_config_obj_test);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","assert rst ",UVM_LOW);
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","deassert rst ",UVM_LOW);

            `uvm_info("run_phase","stimulus generation started",UVM_LOW);
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","stimulus generation ended",UVM_LOW);
            phase.drop_objection(this);

        endtask 
        
    endclass

endpackage 