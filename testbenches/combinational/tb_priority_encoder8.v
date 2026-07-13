`timescale 1ns/1ps
module tb_priority_encoder8;
    reg [7:0] in; wire [2:0] code; wire valid;
    integer i, j, errors=0;
    reg [2:0] exp_code; reg exp_valid;
    priority_encoder8 dut(.in(in), .code(code), .valid(valid));
    initial begin
        errors = 0;
        for (i=0;i<256;i=i+1) begin
            in = i[7:0];
            #1;
            exp_valid = (in != 0);
            exp_code = 0;
            for (j=0;j<8;j=j+1) if (in[j]) exp_code = j[2:0];
            if (valid !== exp_valid || (exp_valid && code !== exp_code)) begin
                errors = errors + 1;
                $display("MISMATCH in=%b code=%b valid=%b expected_code=%b expected_valid=%b", in, code, valid, exp_code, exp_valid);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
