`timescale 1ns/1ps
module tb_one_shot_pulse_gen;
    reg clk=0, rst, trigger; wire pulse_out;
    integer errors=0, i;
    one_shot_pulse_gen dut(.clk(clk), .rst(rst), .trigger(trigger), .pulse_out(pulse_out));
    always #5 clk=~clk;
    task check(input exp, input [127:0] msg); begin
        if (pulse_out!==exp) begin errors=errors+1; $display("MISMATCH %0s pulse_out=%b expected=%b",msg,pulse_out,exp); end
    end endtask
    initial begin
        errors=0;
        rst=1; trigger=0; @(posedge clk); #1; check(0,"after reset");
        rst=0;
        trigger=1; @(posedge clk); #1; trigger=0; check(1,"pulse cycle1");
        @(posedge clk); #1; check(1,"pulse cycle2");
        @(posedge clk); #1; check(1,"pulse cycle3");
        @(posedge clk); #1; check(0,"pulse done");
        // trigger during pulse should be ignored -- test with a fresh trigger mid pulse
        trigger=1; @(posedge clk); #1; trigger=0; check(1,"2nd pulse cycle1");
        trigger=1; // ignored since active
        @(posedge clk); #1; trigger=0; check(1,"2nd pulse cycle2, ignored retrigger");
        @(posedge clk); #1; check(1,"2nd pulse cycle3");
        @(posedge clk); #1; check(0,"2nd pulse done");
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
