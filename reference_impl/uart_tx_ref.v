module uart_tx(input clk, input rst, input start, input [7:0] data, output reg tx, output reg busy);
    reg [3:0] bitcnt;
    reg [9:0] shiftreg;
    always @(posedge clk) begin
        if (rst) begin
            tx <= 1'b1; busy <= 1'b0; bitcnt <= 0;
        end else if (!busy && start) begin
            shiftreg <= {1'b1, data, 1'b0}; // stop, data, start (shifted out LSB first)
            busy <= 1'b1;
            bitcnt <= 0;
            tx <= 1'b0; // start bit immediately
        end else if (busy) begin
            if (bitcnt == 9) begin
                busy <= 1'b0;
                tx <= 1'b1;
            end else begin
                bitcnt <= bitcnt + 1;
                tx <= shiftreg[bitcnt+1];
            end
        end else begin
            tx <= 1'b1;
        end
    end
endmodule
