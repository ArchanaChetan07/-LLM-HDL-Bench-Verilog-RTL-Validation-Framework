module sign_magnitude_adder4(input sign_a, input [2:0] mag_a, input sign_b, input [2:0] mag_b,
                              output reg sign_result, output reg [2:0] mag_result, output reg overflow);
    reg [3:0] sum4;
    always @(*) begin
        overflow = 0;
        if (sign_a == sign_b) begin
            sum4 = mag_a + mag_b;
            if (sum4 > 7) begin overflow = 1; mag_result = sum4[2:0]; end
            else mag_result = sum4[2:0];
            sign_result = sign_a;
        end else begin
            if (mag_a >= mag_b) begin
                mag_result = mag_a - mag_b;
                sign_result = (mag_a == mag_b) ? 1'b0 : sign_a;
            end else begin
                mag_result = mag_b - mag_a;
                sign_result = sign_b;
            end
        end
    end
endmodule
