// SPI Slave

module SPI_Slave_gold(MOSI ,MISO ,SS_n ,clk ,rst_n ,rx_data ,rx_valid ,tx_data ,tx_valid);
    parameter IDLE = 3'b000 , CHK_CMD = 3'b001 , WRITE = 3'b010 , READ_ADD = 3'b011 , READ_DATA = 3'b100;
    input MOSI ,SS_n ,clk ,rst_n ,tx_valid;
    input [7:0] tx_data;
    output reg MISO , rx_valid;
    output reg [9:0] rx_data;

    reg [2:0] cs , ns;

    reg flag = 0;

    reg [3:0] i;
    //reg [2:0] i;                  

    always @(posedge clk ) begin
        if(~rst_n) cs <= IDLE;
        else cs <= ns; 
    end 

    always @(*) begin
        case (cs)
            IDLE : begin
                if(SS_n) ns = IDLE;
                else ns = CHK_CMD;
            end

            CHK_CMD : begin
                if(SS_n) ns = IDLE;                                         
                else begin
                    if(~MOSI) ns = WRITE;
                    else begin
                        if(flag) ns = READ_DATA;
                        else ns = READ_ADD;
                    end
                end 
            end

            WRITE : begin
                if(SS_n) ns = IDLE;
                else ns = WRITE;
            end

            READ_ADD : begin
                if(SS_n) ns = IDLE;
                else ns = READ_ADD;
            end

            READ_DATA : begin
                if(SS_n) ns = IDLE;
                else ns = READ_DATA;
            end

           // default ns = IDLE;
                
        endcase
    end


    always @(posedge clk ) begin
        if(~rst_n) begin
            rx_data  <= 0;
            rx_valid <= 0; 
            MISO <= 0;
            flag <= 0;
         //   i <= 9;
           // i <= 7;
        end

        else begin
          case(cs)
            IDLE: begin
                rx_data  <= 0;
                rx_valid <= 0; 
              //  MISO     <= 0;
            end

            CHK_CMD : begin
                 i <= 10; 
                // i <= 9;
            end

            WRITE : begin
                if(i > 0) begin
                   // rx_valid <= 0;
                    rx_data[i-1] <= MOSI;  
                    i <= i-1;
                end
                else rx_valid <= 1;
            end 

            READ_ADD : begin
                if(i > 0) begin
                   // rx_valid <= 0; 
                    rx_data[i-1] <= MOSI;  
                    i <= i-1;
                end
                else begin
                    rx_valid <= 1;
                    flag <= 1;
                end
            end   

            READ_DATA : begin 
                if(tx_valid) begin 
                   // rx_valid <= 0;
                    if (i > 0) begin
                        MISO <= tx_data[i-1];
                        i <= i - 1;
                    end
                    else begin
                        flag <= 0;
                        rx_valid <= 0;
                    end
                end

                else begin
                    if(i > 0) begin
                        //rx_valid <= 0;
                        rx_data[i-1] <= MOSI;  
                        i <= i-1;
                    end
                    else begin
                        rx_valid <= 1;
                        i <= 9;
                    end
                end
            end        

          endcase
         
        end 
    end

endmodule 