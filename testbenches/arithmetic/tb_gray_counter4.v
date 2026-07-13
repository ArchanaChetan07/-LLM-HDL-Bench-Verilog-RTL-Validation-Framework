`timescale 1ns/1ps
module tb_gray_counter4;
    reg clk=0, rst; wire [3:0] gray_out;
    reg [3:0] bin_model;
    integer i, errors=0;
    reg [3:0] exp;
    gray_counter4 dut(.clk(clk), .rst(rst), .gray_out(gray_out));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; @(posedge clk); #1; bin_model=0;
        if (gray_out !== 4'b0000) begin errors=errors+1; $display("MISMATCH after reset gray=%b",gray_out); end
        rst=0;
        for (i=0;i<20;i=i+1) begin
            @(posedge clk); #1;
            bin_model = bin_model + 1;
            exp = bin_model ^ (bin_model >> 1);
            if (gray_out !== exp) begin
                errors=errors+1;
                $display("MISMATCH cycle=%0d gray=%b expected=%b", i, gray_out, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
