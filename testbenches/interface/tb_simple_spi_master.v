`timescale 1ns/1ps
module tb_simple_spi_master;
    reg clk=0, rst, start; reg [7:0] tx_data; reg miso;
    wire sclk, mosi; wire [7:0] rx_data; wire busy;
    integer errors=0, i;
    // Software model mirroring the reference module's exact cycle-by-cycle logic
    reg m_busy, m_sclk; reg [7:0] m_shreg, m_rx; reg [3:0] m_bitcnt;
    reg exp_mosi;
    simple_spi_master dut(.clk(clk), .rst(rst), .start(start), .tx_data(tx_data), .miso(miso),
                           .sclk(sclk), .mosi(mosi), .rx_data(rx_data), .busy(busy));
    always #5 clk=~clk;

    task check(input [127:0] msg); begin
        exp_mosi = m_shreg[7];
        if (busy!==m_busy || sclk!==m_sclk || mosi!==exp_mosi || rx_data!==m_rx) begin
            errors=errors+1;
            $display("MISMATCH %0s busy=%b(%b) sclk=%b(%b) mosi=%b(%b) rx=%b(%b)",
                      msg, busy,m_busy, sclk,m_sclk, mosi,exp_mosi, rx_data,m_rx);
        end
    end endtask

    task model_step(input miso_val); begin
        if (!m_busy) begin
            m_sclk = 0;
            if (start) begin
                m_busy=1; m_shreg=tx_data; m_bitcnt=0; m_sclk=1;
            end
        end else begin
            if (m_sclk==0) begin
                m_sclk=1;
                m_rx = {m_rx[6:0], miso_val};
                m_shreg = {m_shreg[6:0], 1'b0};
                m_bitcnt = m_bitcnt+1;
            end else begin
                m_sclk=0;
                if (m_bitcnt==8) m_busy=0;
            end
        end
    end endtask

    initial begin
        errors=0;
        rst=1; start=0; tx_data=0; miso=0;
        @(posedge clk); #1;
        m_busy=0; m_sclk=0; m_shreg=0; m_rx=0; m_bitcnt=0;
        check("after reset");
        rst=0;

        tx_data = 8'b10110010;
        start = 1;
        miso = 1;
        model_step(miso);
        @(posedge clk); #1; check("cycle after start");
        start = 0;

        // drive miso with an arbitrary pattern for the remaining bits (20 cycles is
        // plenty to cover the full 8-bit transaction's rise+fall pairs)
        for (i=0;i<20;i=i+1) begin
            miso = i[0];
            model_step(miso);
            @(posedge clk); #1;
            check("transaction");
        end

        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
