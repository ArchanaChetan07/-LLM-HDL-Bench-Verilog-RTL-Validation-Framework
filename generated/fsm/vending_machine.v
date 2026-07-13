module vending_machine(
    input clk,
    input rst,
    input coin_5,
    input coin_10,
    output reg dispense
);
    reg [4:0] cents;
    reg [4:0] next_cents;  // FIX (v2): compute the post-coin total combinationally
                           // first, then branch on THAT value. v1's bug: it checked
                           // `cents >= 15` using the OLD (pre-update) registered value
                           // in the same always block as the nonblocking update, so a
                           // coin that crossed the 15-cent threshold wasn't detected
                           // until one cycle too late (a classic nonblocking-assignment
                           // race). Computing next_cents combinationally and branching
                           // on it fixes the off-by-one-cycle race.

    always @(*) begin
        next_cents = cents;
        if (coin_5)
            next_cents = cents + 5;
        else if (coin_10)
            next_cents = cents + 10;
    end

    always @(posedge clk) begin
        if (rst) begin
            cents <= 0;
            dispense <= 0;
        end else begin
            if (next_cents >= 15) begin
                dispense <= 1;
                cents <= 0;
            end else begin
                dispense <= 0;
                cents <= next_cents;
            end
        end
    end
endmodule
