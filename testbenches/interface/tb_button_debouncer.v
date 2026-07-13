`timescale 1ns/1ps
module tb_button_debouncer;
    reg clk=0, rst, button_in; wire button_out;
    integer errors=0, i;
    reg [2:0] cnt_model; reg last_in_model; reg out_model;
    button_debouncer dut(.clk(clk), .rst(rst), .button_in(button_in), .button_out(button_out));
    always #5 clk=~clk;
    task step(input bin); 
        reg [2:0] pre_cnt;
        begin
        button_in = bin;
        pre_cnt = cnt_model; // capture PRE-edge value: the real register's cnt==3
                              // check reads the old cnt (nonblocking semantics), not
                              // the value it's simultaneously being updated to.
        @(posedge clk); #1;
        if (bin == last_in_model) begin
            if (cnt_model < 4) cnt_model = cnt_model + 1;
            if (pre_cnt == 3) out_model = bin;
        end else cnt_model = 1;
        last_in_model = bin;
        if (button_out !== out_model) begin
            errors=errors+1;
            $display("MISMATCH button_out=%b expected=%b cnt=%0d", button_out, out_model, cnt_model);
        end
    end endtask
    initial begin
        errors=0;
        rst=1; button_in=0; @(posedge clk); #1; cnt_model=0; last_in_model=0; out_model=0;
        rst=0;
        // stable low for a while (no change expected)
        step(0); step(0); step(0);
        // brief glitch high for 2 cycles (not stable long enough) then back low
        step(1); step(1); step(0);
        // now truly hold high for 5 cycles -- should latch high after 4 stable
        step(1); step(1); step(1); step(1); step(1);
        // hold low again for 5
        step(0); step(0); step(0); step(0); step(0);
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
