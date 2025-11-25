package ram_test;
    import ram_env::*;
    import ram_config::*;
    import write_sequence::*;
    import read_sequence::*;
    import Write_Read_sequence::*;
    import rst_sequence::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class ram_test extends uvm_test;
        `uvm_component_utils(ram_test);

        ram_config_obj ram_config_obj_test;    
        ram_env env;
        ram_write_seq write_seq;
        ram_read_seq  read_seq;
        ram_Write_Read_seq write_read_seq;
        ram_rst_seq rst_seq;
        

        function new(string name = "ram_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction  

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = ram_env                         :: type_id :: create("env",this);
            ram_config_obj_test = ram_config_obj  :: type_id :: create("ram_config_obj_test");
            write_seq = ram_write_seq             :: type_id :: create ("write_seq");
            read_seq = ram_read_seq               :: type_id :: create ("read_seq");
            write_read_seq = ram_Write_Read_seq   :: type_id :: create ("write_read_seq");
            rst_seq  = ram_rst_seq                :: type_id :: create ("rst_seq");

            if(!uvm_config_db #(virtual ram_if) :: get(this, "", "ram_IF", ram_config_obj_test.ram_config_vif))
                `uvm_fatal("build_phase", " test -  unable to get the virtual interface");

            uvm_config_db #(ram_config_obj) :: set(this, "*", "CFG", ram_config_obj_test);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            `uvm_info("run_phase","assert rst ",UVM_LOW);
            rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","deassert rst ",UVM_LOW);

            `uvm_info("run_phase","write operation started",UVM_LOW);
            write_seq.start(env.agt.sqr);
            `uvm_info("run_phase","write operation ended",UVM_LOW);

            `uvm_info("run_phase","read operation started",UVM_LOW);
            read_seq.start(env.agt.sqr);
            `uvm_info("run_phase","read operation ended",UVM_LOW);

            `uvm_info("run_phase","write read  operation started",UVM_LOW);
            write_read_seq.start(env.agt.sqr);
            `uvm_info("run_phase","write read  operation ended",UVM_LOW);
            phase.drop_objection(this);

        endtask 
        
    endclass

endpackage 