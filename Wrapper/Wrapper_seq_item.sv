package seq_item_pkg;
    import shared_pkg::*;
    import uvm_pkg::*;
   `include "uvm_macros.svh"

    class wrapper_seq_item extends uvm_sequence_item;
      `uvm_object_utils(wrapper_seq_item);

      rand bit  rst_n, SS_n, MOSI;
      bit MISO, MISO_ref;
      rand bit[10:0] MOSI_bins;

      int counter,i;
      bit WRITE_ADD, READ_ADD, WRITE_DATA, READ_DATA;

     function new (string name = "wrapper_seq_item");
        super.new(name);
     endfunction
    
    constraint rst_constraint {rst_n dist {1 := 999 , 0 := 1};}
 
        // ss_n constraint
        constraint SS_N_constraint { 
            if (~rst_n)
                SS_n == 1; 
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

        constraint write_constraint {  
        if (WRITE_ADD)
            MOSI_bins [10:8] inside {3'b000 , 3'b001};
        }

        constraint read_constraint {     
        MOSI_bins [10:8] inside {3'b111 , 3'b110};   
        if (READ_ADD)
            MOSI_bins [10:8] == 3'b111; 
        else if (READ_DATA)
            MOSI_bins [10:8] == 3'b110;     
         }

        constraint write_read_constraint {
            if (WRITE_ADD)
                 MOSI_bins [10:8] inside {3'b000 , 3'b001};

            else if (WRITE_DATA)
               MOSI_bins [10:8] dist {3'b000:=40 , 3'b110:=60}; 
            
            else if (READ_ADD)
               MOSI_bins [10:8] == {3'b111};       

            else if (READ_DATA)
                MOSI_bins [10:8] dist {3'b110:=40 , 3'b000:=60};  
        }

        function void post_randomize; 
                counter ++;
                if(SS_n) begin
                        counter = 1;  
                        i = 10;
                end
                else if (i>=0 && counter >2) begin
                    MOSI = MOSI_bins[i]; 
                    i --;
                end
                
                if (MOSI_bins [10:8] == 3'b000)
                    WRITE_ADD = 1'b1;
                else 
                    WRITE_ADD = 1'b0;   

                if (MOSI_bins [10:8] == 3'b110)
                    READ_ADD = 1'b1;
                else 
                    READ_ADD = 1'b0;  

                if (MOSI_bins [10:8] == 3'b001)
                    WRITE_DATA = 1'b1;
                else 
                    WRITE_DATA = 1'b0;

                if (MOSI_bins [10:8] == 3'b111)
                    READ_DATA = 1'b1;
                else 
                    READ_DATA = 1'b0;                
    endfunction
    

    function string convert2string();
      return $sformatf("%s MOSI = %0d, SS_n = %0d, rst_n = %0d , MISO = %0d , MISO_ref = %0d , MOSI_bins = %b",
      super.convert2string(), MOSI, SS_n, rst_n, MISO, MISO_ref, MOSI_bins);
    endfunction 

  endclass
  
endpackage