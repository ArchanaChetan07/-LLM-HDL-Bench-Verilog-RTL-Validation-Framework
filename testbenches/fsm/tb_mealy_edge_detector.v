`timescale 1ns/1ps
module tb_mealy_edge_detector;
    reg clk=0, rst, din; wire pulse;
    integer errors=0, i;
    reg [7:0] seq = 8'b01101100;
    reg prev; // mirrors dut's registered prev_din (value BEFORE the upcoming edge)
    mealy_edge_detector dut(.clk(clk), .rst(rst), .din(din), .pulse(pulse));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; din=0; @(posedge clk); #1; prev=0;
        rst=0;
        for (i=0;i<8;i=i+1) begin
            din = seq[7-i];
            #1; // let combinational pulse settle BEFORE the next edge updates prev_din
            if (pulse !== (prev && !din)) begin
                errors=errors+1;
                $display("MISMATCH i=%0d din=%b prev=%b pulse=%b expected=%b", i, din, prev, pulse, (prev && !din));
            end
            @(posedge clk); #1;
            prev = din; // dut's prev_din register just updated to this cycle's din too
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
