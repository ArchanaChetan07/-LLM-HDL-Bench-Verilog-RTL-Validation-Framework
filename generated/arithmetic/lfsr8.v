module lfsr8(
    input clk,
    input rst,
    output [7:0] value
);
    reg [7:0] shreg;
    wire feedback;
    // taps at bits 8,6,5,4 (1-indexed) -> bit indices 7,5,4,3
    assign feedback = shreg[7] ^ shreg[5] ^ shreg[4] ^ shreg[3];

    always @(posedge clk) begin
        if (rst)
            shreg <= 8'hFF;
        else
            shreg <= {shreg[6:0], feedback};
    end

    assign value = shreg;
endmodule
