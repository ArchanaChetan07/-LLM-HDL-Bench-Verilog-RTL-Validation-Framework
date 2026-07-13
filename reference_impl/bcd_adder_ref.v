module bcd_adder(input [3:0] a, input [3:0] b, input cin, output [3:0] sum, output cout);
    wire [4:0] bin_sum;
    assign bin_sum = a + b + cin;
    wire correction = (bin_sum > 9);
    wire [4:0] corrected = correction ? (bin_sum + 5'd6) : bin_sum;
    assign sum = corrected[3:0];
    assign cout = correction;
endmodule
