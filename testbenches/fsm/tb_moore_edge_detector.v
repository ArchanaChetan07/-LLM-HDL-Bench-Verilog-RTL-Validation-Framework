`timescale 1ns/1ps
module tb_moore_edge_detector;
    reg clk=0, rst, din; wire pulse;
    integer errors=0, i;
    reg [7:0] seq = 8'b01101100;
    // Moore machine: a rising edge sampled on cycle N is reflected in `pulse`
    // starting cycle N+1 (state-entry latency), per the prompt's spec.
    // one_ago = din value from the previous iteration; two_ago = the one before that.
    reg one_ago, two_ago;
    reg expected;
    moore_edge_detector dut(.clk(clk), .rst(rst), .din(din), .pulse(pulse));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; din=0; @(posedge clk); #1;
        one_ago=0; two_ago=0;
        rst=0;
        for (i=0;i<8;i=i+1) begin
            din = seq[7-i];
            @(posedge clk); #1;
            // after this edge, dut's pulse reflects whether (two_ago==0 && one_ago==1),
            // i.e. the rising edge that happened when din went one_ago -> ... wait:
            // dut samples "din==1 from LOW" to move to PULSE; PULSE asserts pulse next cycle.
            // So: pulse this cycle == (one_ago==0 && the din applied last iteration [now one_ago]) doesn't work directly;
            // simplest correct model: pulse(cycle i) == rising edge occurred going INTO cycle i-1
            //   i.e. din(i-2)==0 && din(i-1)==1, using this iteration's one_ago/two_ago BEFORE update.
            expected = (two_ago==1'b0) && (one_ago==1'b1);
            if (i>=2) begin
                if (pulse !== expected) begin
                    errors=errors+1;
                    $display("MISMATCH i=%0d pulse=%b expected=%b two_ago=%b one_ago=%b din=%b", i, pulse, expected, two_ago, one_ago, din);
                end
            end
            two_ago = one_ago;
            one_ago = din;
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
