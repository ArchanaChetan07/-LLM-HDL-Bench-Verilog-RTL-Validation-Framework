`timescale 1ns/1ps
module tb_priority_arbiter4;
    reg [3:0] req; wire [3:0] grant;
    integer i, errors=0;
    reg [3:0] exp;
    priority_arbiter4 dut(.req(req), .grant(grant));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin
            req = i[3:0];
            #1;
            if (req[0]) exp=4'b0001;
            else if (req[1]) exp=4'b0010;
            else if (req[2]) exp=4'b0100;
            else if (req[3]) exp=4'b1000;
            else exp=4'b0000;
            if (grant !== exp) begin
                errors=errors+1;
                $display("MISMATCH req=%b grant=%b expected=%b", req, grant, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
