module vending_machine(input clk, input rst, input coin_5, input coin_10, output reg dispense);
    reg [4:0] cents;
    always @(posedge clk) begin
        if (rst) begin cents <= 0; dispense <= 0; end
        else begin
            dispense <= 0;
            if (cents + (coin_5?5:0) + (coin_10?10:0) >= 15) begin
                dispense <= 1;
                cents <= 0;
            end else begin
                cents <= cents + (coin_5?5:0) + (coin_10?10:0);
            end
        end
    end
endmodule
