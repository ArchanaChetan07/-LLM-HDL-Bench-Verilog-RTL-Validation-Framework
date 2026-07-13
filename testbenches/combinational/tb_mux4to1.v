`timescale 1ns/1ps
module tb_mux4to1;
    reg [3:0] in; reg [1:0] sel; wire out;
    integer i, s, errors=0;
    mux4to1 dut(.in(in), .sel(sel), .out(out));
    initial begin
        errors = 0;
        for (i=0;i<16;i=i+1) begin
            in = i[3:0];
            for (s=0;s<4;s=s+1) begin
                sel = s[1:0];
                #1;
                if (out !== in[sel]) begin
                    errors = errors + 1;
                    $display("MISMATCH in=%b sel=%b out=%b expected=%b", in, sel, out, in[sel]);
                end
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
