`timescale 1ns/1ps
module tb_uart_tx;
    reg clk=0, rst, start; reg [7:0] data;
    wire tx, busy;
    integer errors=0, i;
    reg [9:0] captured;
    uart_tx dut(.clk(clk), .rst(rst), .start(start), .data(data), .tx(tx), .busy(busy));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; start=0; data=0; @(posedge clk); #1;
        if (tx!==1 || busy!==0) begin errors=errors+1; $display("MISMATCH idle after reset tx=%b busy=%b",tx,busy); end
        rst=0;
        data = 8'b10110010;
        start=1;
        @(posedge clk); #1; start=0;

        // Frame must be EXACTLY 10 cycles busy: capture 10 bits, and busy must be
        // high on every one of them (this exact-duration check is what the
        // v1-pilot testbench lacked -- it only checked bit values, not that busy
        // deasserted at precisely cycle 10, which is why an off-by-one extra
        // idle-detection cycle in the v1 generated module slipped through).
        for (i=0;i<10;i=i+1) begin
            captured[i] = tx;
            if (busy !== 1) begin
                errors=errors+1;
                $display("MISMATCH busy should be high during frame bit %0d, busy=%b", i, busy);
            end
            if (i<9) begin @(posedge clk); #1; end
        end
        if (captured[0]!==0) begin errors=errors+1; $display("MISMATCH start bit=%b",captured[0]); end
        for (i=0;i<8;i=i+1) begin
            if (captured[i+1] !== data[i]) begin
                errors=errors+1;
                $display("MISMATCH data bit %0d captured=%b expected=%b", i, captured[i+1], data[i]);
            end
        end
        if (captured[9]!==1) begin errors=errors+1; $display("MISMATCH stop bit=%b",captured[9]); end

        // Exactly ONE cycle after the 10th (stop) bit, busy must already be low
        // and tx back to idle-high -- not one cycle later.
        @(posedge clk); #1;
        if (busy !== 0 || tx !== 1) begin
            errors=errors+1;
            $display("MISMATCH busy must deassert exactly 1 cycle after stop bit: busy=%b tx=%b", busy, tx);
        end

        // start pulses asserted while busy must be ignored (spec: "only accepted
        // when not busy"). Fire a second frame back-to-back and confirm a start
        // pulse mid-frame does not corrupt or restart it.
        data = 8'b00001111;
        start = 1;
        @(posedge clk); #1; start = 0;
        @(posedge clk); #1;
        start = 1;
        @(posedge clk); #1;
        start = 0;
        for (i=0;i<8;i=i+1) @(posedge clk);
        #1;
        if (busy !== 0 || tx !== 1) begin
            errors=errors+1;
            $display("MISMATCH after mid-frame start injection, frame did not complete cleanly: busy=%b tx=%b", busy, tx);
        end

        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
