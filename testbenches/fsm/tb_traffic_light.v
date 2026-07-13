`timescale 1ns/1ps
module tb_traffic_light;
    reg clk=0, rst;
    wire [1:0] light;
    integer errors=0, i;
    traffic_light dut(.clk(clk), .rst(rst), .light(light));
    always #5 clk = ~clk;
    task check(input [1:0] exp, input [127:0] msg);
        begin
            if (light !== exp) begin
                errors = errors+1;
                $display("MISMATCH %0s: light=%b expected=%b", msg, light, exp);
            end
        end
    endtask
    initial begin
        rst = 1; @(posedge clk); #1; check(2'b00,"after reset");
        rst = 0;
        // Initial RED hold: reset already established cnt=0/RED, so only 3 more cycles before GREEN
        for (i=0;i<3;i=i+1) begin @(posedge clk); #1; check(2'b00, "initial red hold"); end
        // GREEN for 4 cycles
        for (i=0;i<4;i=i+1) begin @(posedge clk); #1; check(2'b01, "green phase"); end
        // YELLOW for 2 cycles
        for (i=0;i<2;i=i+1) begin @(posedge clk); #1; check(2'b10, "yellow phase"); end
        // RED for 4 cycles
        for (i=0;i<4;i=i+1) begin @(posedge clk); #1; check(2'b00, "red phase"); end
        // second cycle: GREEN again
        for (i=0;i<4;i=i+1) begin @(posedge clk); #1; check(2'b01, "green phase 2"); end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
