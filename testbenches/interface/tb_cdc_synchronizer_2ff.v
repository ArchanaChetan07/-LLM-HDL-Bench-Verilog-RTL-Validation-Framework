`timescale 1ns/1ps
module tb_cdc_synchronizer_2ff;
    reg clk=0, rst, async_in; wire sync_out;
    integer i, errors=0;
    reg [9:0] seq = 10'b1011001101;
    reg hist [0:11]; // explicit history, avoids shift-register off-by-one bugs in the model itself
    cdc_synchronizer_2ff dut(.clk(clk), .rst(rst), .async_in(async_in), .sync_out(sync_out));
    always #5 clk=~clk;
    initial begin
        errors=0;
        hist[0]=0; hist[1]=0; // pre-seed: values "before time 0" are 0 (matches reset state)
        rst=1; async_in=0; @(posedge clk); #1;
        if (sync_out!==0) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        for (i=0;i<10;i=i+1) begin
            async_in = seq[9-i];
            hist[i+1] = async_in; // hist index i+1 = value applied at iteration i
            @(posedge clk); #1;
            // sync_out after iteration i's edge equals async_in applied one iteration ago
            if (sync_out !== hist[i]) begin
                errors=errors+1;
                $display("MISMATCH i=%0d sync_out=%b expected=%b", i, sync_out, hist[i]);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
