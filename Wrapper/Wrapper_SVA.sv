module  wrapper_sva (
    input  clk,
    input  MOSI,
    input  SS_n,
    input  rst_n,
    input  MISO

);

   // rst Assertion 
    rst_assert:assert        property  (@(posedge clk) !rst_n |=> (!MISO)); 
    rst_cover:cover          property  (@(posedge clk) !rst_n |=> (!MISO));

    sequence seq;
    $fell(SS_n) ##1 (MOSI [*3]) ##1 $rose(SS_n);
    endsequence

    property MISO_prop;
        @(posedge clk) disable iff (!rst_n)
            $fell(SS_n) |=> 
                (not seq ##1 ($stable(MISO) throughout (!SS_n)) );
    endproperty

  assert property (MISO_prop);
  cover property (MISO_prop);



endmodule 