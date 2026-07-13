`timescale 1ns/1ps
module tb_byte_enable_ram_16x8;
    reg clk=0, we, byte_en; reg [3:0] addr; reg [7:0] wdata;
    wire [7:0] rdata;
    reg [7:0] model [0:15]; reg written [0:15];
    integer i, errors=0;
    reg [7:0] exp;
    byte_enable_ram_16x8 dut(.clk(clk), .we(we), .byte_en(byte_en), .addr(addr), .wdata(wdata), .rdata(rdata));
    always #5 clk=~clk;
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin model[i]=0; written[i]=0; end
        for (i=0;i<25;i=i+1) begin
            we = (i%2==0);
            byte_en = (i%3!=0); // sometimes we&&!byte_en to test gating
            addr = i[3:0];
            wdata = (i*9+4)&8'hFF;
            exp = model[addr];
            @(posedge clk); #1;
            if (written[addr] && rdata !== exp) begin
                errors=errors+1;
                $display("MISMATCH i=%0d addr=%d rdata=%b expected=%b", i, addr, rdata, exp);
            end
            if (we && byte_en) begin model[addr]=wdata; written[addr]=1; end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
