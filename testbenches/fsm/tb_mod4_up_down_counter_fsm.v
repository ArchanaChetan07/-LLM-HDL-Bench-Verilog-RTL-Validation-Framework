`timescale 1ns/1ps
module tb_mod4_up_down_counter_fsm;
    reg clk=0, rst, up_down; wire [1:0] count;
    integer errors=0, i;
    reg [1:0] model;
    mod4_up_down_counter_fsm dut(.clk(clk), .rst(rst), .up_down(up_down), .count(count));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; up_down=1; @(posedge clk); #1; model=0;
        if (count!==0) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        for (i=0;i<6;i=i+1) begin
            up_down=1; @(posedge clk); #1; model=model+1;
            if (count!==model) begin errors=errors+1; $display("MISMATCH up i=%0d count=%b exp=%b",i,count,model); end
        end
        for (i=0;i<6;i=i+1) begin
            up_down=0; @(posedge clk); #1; model=model-1;
            if (count!==model) begin errors=errors+1; $display("MISMATCH down i=%0d count=%b exp=%b",i,count,model); end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
