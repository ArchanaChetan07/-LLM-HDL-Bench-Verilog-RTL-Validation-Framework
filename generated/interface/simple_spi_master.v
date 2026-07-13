module simple_spi_master(
    input clk,
    input rst,
    input start,
    input  [7:0] tx_data,
    input miso,
    output reg sclk,
    output mosi,
    output reg [7:0] rx_data,
    output reg busy
);
    reg [7:0] shreg;
    reg [3:0] bitcnt;

    always @(posedge clk) begin
        if (rst) begin
            busy <= 0;
            sclk <= 0;
            bitcnt <= 0;
            rx_data <= 0;
            shreg <= 0;
        end else if (!busy) begin
            sclk <= 0;
            if (start) begin
                busy <= 1;
                shreg <= tx_data;
                bitcnt <= 0;
                sclk <= 1;
            end
        end else begin
            if (sclk == 0) begin
                sclk <= 1;
                rx_data <= {rx_data[6:0], miso};
                shreg <= {shreg[6:0], 1'b0};
                bitcnt <= bitcnt + 1;
            end else begin
                sclk <= 0;
                if (bitcnt == 8)
                    busy <= 0;
            end
        end
    end

    assign mosi = shreg[7];
endmodule
