`timescale 1ns/1ps
module tb_one_pulse_edge_detector_io;
    reg clk=0, rst, sig_in; wire edge_pulse;
    integer errors=0, i;
    reg [7:0] seq = 8'b01101100;
    reg prev; reg exp;
    one_pulse_edge_detector_io dut(.clk(clk), .rst(rst), .sig_in(sig_in), .edge_pulse(edge_pulse));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; sig_in=0; @(posedge clk); #1; prev=0;
        if (edge_pulse!==0) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        for (i=0;i<8;i=i+1) begin
            sig_in = seq[7-i];
            @(posedge clk); #1;
            exp = (sig_in != prev);
            if (edge_pulse !== exp) begin
                errors=errors+1;
                $display("MISMATCH i=%0d edge_pulse=%b expected=%b", i, edge_pulse, exp);
            end
            prev = sig_in;
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
