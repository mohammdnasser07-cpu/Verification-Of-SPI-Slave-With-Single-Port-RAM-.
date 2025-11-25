module RAM_gold (din , rx_valid , tx_valid , clk , rst_n , dout);
    parameter MEM_WIDTH = 8 , MEM_DEPTH = 256 , ADDER_SIZE = 8;
    input [MEM_WIDTH+1:0] din;
    reg [ADDER_SIZE-1:0] addr_wr;
    reg [ADDER_SIZE-1:0] addr_rd;
    input rx_valid , clk , rst_n;
    output reg tx_valid;
    output reg [MEM_WIDTH-1:0] dout;

    reg [MEM_WIDTH-1:0] mem [MEM_DEPTH-1:0];

    always@(posedge clk) begin
        if(~rst_n) begin
             dout <= 0;
             tx_valid <= 0;
             addr_wr <= 0;
             addr_rd <= 0;
        end
        else begin
            if(rx_valid) begin
                case(din[9:8])
                    2'b00 : begin
                         addr_wr <= din[7:0];
                         tx_valid <= 0;
                    end
                    2'b01 : begin
                         mem [addr_wr] <= din[7:0];
                         tx_valid <= 0;
                    end
                    2'b10 : begin 
                        addr_rd <= din[7:0];
                        tx_valid <= 0;
                    end
                    2'b11 : begin
                        dout <= mem [addr_rd]; 
                        tx_valid <= 1;
                    end
                         
                endcase
            end
            else begin
                tx_valid <= 0;
            end

        end

    end

endmodule