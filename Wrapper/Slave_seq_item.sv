package seq_item_pkg_slave;
    import uvm_pkg::*;
   `include "uvm_macros.svh"

    class slave_seq_item extends uvm_sequence_item;
        `uvm_object_utils(slave_seq_item);
        
        rand logic [7:0] tx_data;
        logic [9:0] rx_data ,rx_data_ref;
        logic rx_valid, MISO,MISO_ref ,rx_valid_ref;
        logic MOSI;
        rand logic SS_n;
        rand logic rst_n;
        rand bit tx_valid;
        rand bit[10:0] MOSI_bins;

         int counter,i;

        function new(string name = "slave_seq_item");
            super.new(name);
        endfunction

    constraint reset_constraint {rst_n dist {0:=2, 1:=998};}

    constraint SS_N_constraint{ 
            if (~rst_n) SS_n == 1; 

            else if (MOSI_bins[10:8] == 3'b111) {
                if(counter == 24) 
                    SS_n == 1;
                else 
                    SS_n == 0;  
            }  

            else {
                if (counter == 14)
                    SS_n == 1;
                else 
                    SS_n == 0;
            }  
    }

    constraint MOSI_bins_constraint{ 

       MOSI_bins[10:8] inside {3'b000,3'b001,3'b110,3'b111};
 
    }

    constraint tx_valid_constraint{
            if (MOSI_bins[10:8] == 3'b111) 
              {
                if(counter > 13)
                  tx_valid == 1;
                else
                  tx_valid == 0;
              } 
            else
              {
                 tx_valid == 0;
              }
    }  

    function void post_randomize; 
                counter ++;
                if(SS_n) begin
                        counter = 1;  
                        i = 10;
                end
                else if (i >= 0 && counter > 2) begin
                    MOSI = MOSI_bins[i]; 
                    i--; 
                end
    endfunction


      function string convert2string();
        return $sformatf("%s reset = 0b%0b , mosi=%b , miso=%b , ss_n = %b ",super.convert2string(),rst_n, MOSI, MISO, SS_n);
      endfunction

      function string convert2string_stimulus();
        return $sformatf("reset = 0b%0b , mosi=%b , ss_n = %b ",rst_n, MOSI, SS_n);
      endfunction
    endclass

endpackage    