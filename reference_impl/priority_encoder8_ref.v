module priority_encoder8(input [7:0] in, output reg [2:0] code, output reg valid);
    integer i;
    always @(*) begin
        code = 3'b000; valid = 1'b0;
        for (i = 0; i < 8; i = i + 1)
            if (in[i]) begin code = i[2:0]; valid = 1'b1; end
    end
endmodule
