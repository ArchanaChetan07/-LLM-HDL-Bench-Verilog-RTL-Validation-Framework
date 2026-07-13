module uart_tx(
    input clk,
    input rst,
    input start,
    input  [7:0] data,
    output reg tx,
    output reg busy
);
    reg [3:0] bitcount;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (rst) begin
            tx <= 1'b1;
            busy <= 1'b0;
            bitcount <= 0;
        end else if (!busy) begin
            if (start) begin
                busy <= 1'b1;
                data_reg <= data;
                tx <= 1'b0;      // start bit
                bitcount <= 0;
            end else begin
                tx <= 1'b1;      // idle
            end
        end else begin
            if (bitcount < 8) begin
                tx <= data_reg[bitcount];
                bitcount <= bitcount + 1;
            end else if (bitcount == 8) begin
                tx <= 1'b1;      // stop bit
                bitcount <= bitcount + 1;
            end else begin
                busy <= 1'b0;
                bitcount <= 0;
            end
        end
    end
endmodule
