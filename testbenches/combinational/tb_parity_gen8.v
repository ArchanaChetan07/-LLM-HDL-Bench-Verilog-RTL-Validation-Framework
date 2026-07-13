`timescale 1ns/1ps
module tb_parity_gen8;
    reg [7:0] data; wire parity;
    integer i, errors=0;
    parity_gen8 dut(.data(data), .parity(parity));
    initial begin
        errors=0;
        for (i=0;i<256;i=i+1) begin
            data = i[7:0];
            #1;
            if (parity !== ^data) begin
                errors=errors+1;
                $display("MISMATCH data=%b parity=%b expected=%b", data, parity, ^data);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
