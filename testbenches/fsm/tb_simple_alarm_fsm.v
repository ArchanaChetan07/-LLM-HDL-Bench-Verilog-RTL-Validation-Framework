`timescale 1ns/1ps
module tb_simple_alarm_fsm;
    reg clk=0, rst, arm, sensor, disarm;
    wire armed, alarm_triggered;
    integer errors=0;
    simple_alarm_fsm dut(.clk(clk), .rst(rst), .arm(arm), .sensor(sensor), .disarm(disarm),
                          .armed(armed), .alarm_triggered(alarm_triggered));
    always #5 clk=~clk;
    task check(input exp_armed, input exp_trig, input [127:0] msg); begin
        if (armed!==exp_armed || alarm_triggered!==exp_trig) begin
            errors=errors+1;
            $display("MISMATCH %0s armed=%b trig=%b exp_armed=%b exp_trig=%b", msg, armed, alarm_triggered, exp_armed, exp_trig);
        end
    end endtask
    initial begin
        errors=0;
        rst=1; arm=0; sensor=0; disarm=0; @(posedge clk); #1; check(0,0,"after reset");
        rst=0;
        arm=1; @(posedge clk); #1; arm=0; check(1,0,"armed");
        sensor=1; @(posedge clk); #1; check(1,1,"triggered");
        sensor=0; @(posedge clk); #1; check(1,1,"stays triggered after sensor clears");
        disarm=1; @(posedge clk); #1; disarm=0; check(0,0,"disarmed");
        // disarm from ARMED (not triggered) directly
        arm=1; @(posedge clk); #1; arm=0; check(1,0,"armed again");
        disarm=1; @(posedge clk); #1; disarm=0; check(0,0,"disarmed from armed");
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
