package wrapper_test;
    import wrapper_env::*;
    import wrapper_config::*;
    import write_sequence::*;
    import read_sequence::*;
    import Write_Read_sequence::*;
    import rst_sequence::*;
    import uvm_pkg::*;
    import slave_env::*;
    import ram_env::*;
    import ram_config::*;
    import slave_config::*;
    `include "uvm_macros.svh"

    class wrapper_test extends uvm_test;
        `uvm_component_utils(wrapper_test);
    
        wrapper_env env_act;
        slave_env env_pass_slave; 
        ram_env env_pass_ram;

        wrapper_config_obj wrapper_config_obj_test;
        slave_config_obj slave_cfg;
        ram_config_obj ram_cfg;

        wrapper_write_seq write_only_seq;
        wrapper_read_seq read_only_seq;
        wrraper_Write_Read_seq read_write_seq;
        wrapper_rst_seq rst_seq;
        

        function new(string name = "wrapper_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction
 

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env_act                 = wrapper_env        :: type_id :: create("env_act",this);
            wrapper_config_obj_test = wrapper_config_obj :: type_id :: create("wrapper_config_obj_test");

            env_pass_slave          = slave_env          :: type_id :: create ("env_pass_slave",this);
            slave_cfg               = slave_config_obj   :: type_id :: create ("slave_cfg");

            env_pass_ram            = ram_env            :: type_id :: create ("env_pass_ram",this);
            ram_cfg                 = ram_config_obj     :: type_id :: create ("ram_cfg");

            write_only_seq          = wrapper_write_seq        :: type_id :: create ("write_only_seq");
            read_only_seq           = wrapper_read_seq         :: type_id :: create ("read_only_seq");
            read_write_seq          = wrraper_Write_Read_seq   :: type_id :: create ("read_write_seq");
            rst_seq                 = wrapper_rst_seq          :: type_id :: create ("rst_seq");

            wrapper_config_obj_test.is_active_wrapper = UVM_ACTIVE;
            slave_cfg.is_active_slave                 = UVM_PASSIVE;
            ram_cfg.is_active_ram                     = UVM_PASSIVE;

            if(!uvm_config_db #(virtual wrapper_if) :: get(this, "", "Wrapper_IF", wrapper_config_obj_test.wrapper_config_vif))
                `uvm_fatal("build_phase", " test -  unable to get the first virtual interface");

            if(!uvm_config_db #(virtual slave_if)   :: get(this,"","Slave_IF",slave_cfg.slave_config_vif))
                `uvm_fatal("build_phase","test - unable to get the second virtul interface");

            if(!uvm_config_db #(virtual ram_if)     :: get(this,"","Ram_IF",ram_cfg.ram_config_vif))
                `uvm_fatal("build_phase","test - unable to get the third virtul interface");


            uvm_config_db #(wrapper_config_obj) :: set(this,"env_act.*","CFG_wrap", wrapper_config_obj_test);
            uvm_config_db #(slave_config_obj)   :: set(this,"env_pass_slave.*","CFG_slave",slave_cfg);
            uvm_config_db #(ram_config_obj)     :: set(this,"env_pass_ram.*","CFG_ram",ram_cfg);
 
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            `uvm_info("run_phase","assert rst ",UVM_LOW);
            rst_seq.start(env_act.agt.sqr);
            `uvm_info("run_phase","deassert rst ",UVM_LOW);

            `uvm_info("run_phase","write operation started",UVM_LOW);
            write_only_seq.start(env_act.agt.sqr);
            `uvm_info("run_phase","write operation ended",UVM_LOW);

            `uvm_info("run_phase","read operation started",UVM_LOW);
            read_only_seq.start(env_act.agt.sqr);
            `uvm_info("run_phase","read operation ended",UVM_LOW);

            `uvm_info("run_phase","write_read operation started",UVM_LOW);
            read_write_seq.start(env_act.agt.sqr);
            `uvm_info("run_phase","write_read operation ended",UVM_LOW);

            phase.drop_objection(this); 

        endtask 
        
    endclass

endpackage 