`timescale 1ns/1ps
module tb_shadow_register_pair;
    reg clk=0, rst, we, commit, restore; reg [7:0] wdata;
    wire [7:0] working_out, shadow_out;
    reg [7:0] mworking, mshadow;
    integer errors=0;
    shadow_register_pair dut(.clk(clk), .rst(rst), .we(we), .wdata(wdata), .commit(commit), .restore(restore),
                              .working_out(working_out), .shadow_out(shadow_out));
    always #5 clk=~clk;
    task check(input [127:0] msg); begin
        if (working_out!==mworking || shadow_out!==mshadow) begin
            errors=errors+1;
            $display("MISMATCH %0s working=%b exp=%b shadow=%b exp=%b", msg, working_out, mworking, shadow_out, mshadow);
        end
    end endtask
    initial begin
        errors=0;
        rst=1; we=0; commit=0; restore=0; wdata=0; @(posedge clk); #1; mworking=0; mshadow=0; check("after reset");
        rst=0;
        we=1; wdata=8'hAA; @(posedge clk); #1; mworking=8'hAA; check("after we");
        we=0; commit=1; @(posedge clk); #1; mshadow=mworking; check("after commit");
        commit=0; we=1; wdata=8'h55; @(posedge clk); #1; mworking=8'h55; check("after 2nd we");
        we=0; restore=1; @(posedge clk); #1; mworking=mshadow; check("after restore");
        // priority: restore over we/commit same cycle
        restore=0; we=1; commit=1; wdata=8'hFF;
        @(posedge clk); #1; mshadow=mworking; check("commit wins over we (restore=0)");
        we=1; commit=0; restore=1; wdata=8'h11;
        @(posedge clk); #1; mworking=mshadow; check("restore wins over we");
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
