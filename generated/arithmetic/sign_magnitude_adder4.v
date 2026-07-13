module sign_magnitude_adder4(
    input  sign_a,
    input  [2:0] mag_a,
    input  sign_b,
    input  [2:0] mag_b,
    output reg sign_result,
    output reg [2:0] mag_result,
    output reg overflow
);
    reg [3:0] sum_ext;

    always @(*) begin
        overflow = 1'b0;
        if (sign_a == sign_b) begin
            sum_ext = mag_a + mag_b;
            sign_result = sign_a;
            if (sum_ext > 4'd7) begin
                overflow = 1'b1;
            end
            mag_result = sum_ext[2:0];
        end else begin
            if (mag_a >= mag_b) begin
                mag_result = mag_a - mag_b;
                // Equal magnitudes cancel to +0 (sign_result=0), per spec
                sign_result = (mag_a == mag_b) ? 1'b0 : sign_a;
            end else begin
                mag_result = mag_b - mag_a;
                sign_result = sign_b;
            end
        end
    end
endmodule
