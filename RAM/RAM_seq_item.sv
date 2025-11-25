package seq_item_pkg;
    import uvm_pkg::*;
   `include "uvm_macros.svh"

   typedef enum bit [1:0] {
        WRITE_ADDR = 2'b00,
        WRITE_DATA = 2'b01, 
        READ_ADDR  = 2'b10,
        READ_DATA  = 2'b11
    } operation_t;

    class ram_seq_item extends uvm_sequence_item;
        `uvm_object_utils(ram_seq_item);

        operation_t prev_op;    
        rand logic  [9:0] din;
        rand bit  rst_n, rx_valid;

        logic [7:0] dout, dout_ref;
        bit   tx_valid, tx_valid_ref;
        

        function new(string name = "ram_seq_item");
            super.new(name);
        endfunction

        constraint c_rst {rst_n dist {1 := 95 , 0 := 5};}  

        constraint c_rx_valid {rx_valid dist {1 := 95 , 0 := 5};} 


        function string convert2string();
            return $sformatf ("rst_n = 0b%0b, din = 0b%0b, rx_valid = 0b%0b, dout = 0b%0b, tx_valid = 0b%0b", super.convert2string(), rst_n, din, rx_valid, dout, tx_valid);
        endfunction

        function string convert2string_stimulus();
            return $sformatf ("rst_n = 0b%0b, din = 0b%0b, rx_valid = 0b%0b",rst_n, din, rx_valid);
        endfunction

    endclass
    
endpackage  