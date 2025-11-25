module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

localparam IDLE      = 3'b000;
localparam CHK_CMD   = 3'b001;//replaced
localparam WRITE     = 3'b010;// replaced
localparam READ_ADD  = 3'b011;
localparam READ_DATA = 3'b100;

input            MOSI, clk, rst_n, SS_n, tx_valid;
input      [7:0] tx_data;
output reg [9:0] rx_data;
output reg       rx_valid, MISO;

reg [3:0] counter;

reg      received_address = 0; //should be intialized by zero

reg [2:0] cs, ns;

always @(posedge clk) begin 
    if (~rst_n) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns; 
    end
end

always @(*) begin
    case (cs)
        IDLE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = CHK_CMD;
        end
        CHK_CMD : begin
            if (SS_n)
                ns = IDLE;
            else begin
                if (~MOSI)
                    ns = WRITE;
                else begin
                    if (!received_address) // '!' has been added.;
                        ns = READ_ADD; 
                    else
                        ns = READ_DATA;
                end
            end
        end
        WRITE : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
        end
        READ_ADD : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
        end
        READ_DATA : begin
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
        end
    endcase
end

always @(posedge clk) begin
    if (~rst_n) begin 
        rx_data <= 0;
        rx_valid <= 0;
        received_address <= 0;
        counter <= 10;
        
    end
    else begin
        case (cs)
            IDLE : begin
                rx_data  <= 0; //has been added
                rx_valid <= 0; 
                //MISO <= 0; //has been added 
            end
            CHK_CMD : begin
                counter <= 10; 
            end
            WRITE : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;     
                end
                else begin
                    rx_valid <= 1;    
                end
            end
            READ_ADD : begin
                if (counter > 0) begin
                    rx_data[counter-1] <= MOSI;
                    counter <= counter - 1;
                end
                else begin
                    rx_valid <= 1;
                    received_address <= 1;
                end 
            end
            READ_DATA : begin
                if (tx_valid) begin
                   // rx_valid <= 0; //removed
                    if (counter > 0) begin
                        MISO <= tx_data[counter-1];
                        counter <= counter - 1;
                    end
                    else begin
                        received_address <= 0;
                        rx_valid <= 0;//added
                    end
                end
                else begin
                    if (counter > 0) begin
                        rx_data[counter-1] <= MOSI;
                        counter <= counter - 1;
                    end
                    else begin
                        rx_valid <= 1;
                        counter <= 9; // 9 not 8
                    end
                end 
            end
        endcase
    end
end


`ifdef SIM
    // Assertions
    trans1_assert:assert property  (@(posedge clk) disable iff (!rst_n) (cs == IDLE && !SS_n) |=> (cs == CHK_CMD)); 
    trans1_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (cs == IDLE && !SS_n) |=> (cs == CHK_CMD));

    trans2_assert:assert property  (@(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && !SS_n) |=> (cs == WRITE || cs == READ_ADD || cs == READ_DATA)); 
    trans2_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (cs == CHK_CMD && !SS_n) |=> (cs == WRITE || cs == READ_ADD || cs == READ_DATA));

    trans3_assert:assert property  (@(posedge clk) disable iff (!rst_n) (cs == WRITE && SS_n) |=> (cs == IDLE)); 
    trans3_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (cs == WRITE && SS_n) |=> (cs == IDLE));

    trans4_assert:assert property  (@(posedge clk) disable iff (!rst_n) (cs == READ_ADD && SS_n) |=> (cs == IDLE)); 
    trans4_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (cs == READ_ADD && SS_n) |=> (cs == IDLE));

    trans5_assert:assert property  (@(posedge clk) disable iff (!rst_n) (cs == READ_DATA && SS_n) |=> (cs == IDLE)); 
    trans5_cover:cover   property  (@(posedge clk) disable iff (!rst_n) (cs == READ_DATA && SS_n) |=> (cs == IDLE));


`endif

endmodule