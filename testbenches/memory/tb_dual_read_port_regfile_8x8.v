`timescale 1ns/1ps
module tb_dual_read_port_regfile_8x8;
    reg clk=0, we; reg [2:0] waddr, raddr1, raddr2, raddr3; reg [7:0] wdata;
    wire [7:0] rdata1, rdata2, rdata3;
    reg [7:0] model [0:7]; reg written [0:7];
    integer i, errors=0;
    dual_read_port_regfile_8x8 dut(.clk(clk), .we(we), .waddr(waddr), .wdata(wdata),
                                    .raddr1(raddr1), .raddr2(raddr2), .raddr3(raddr3),
                                    .rdata1(rdata1), .rdata2(rdata2), .rdata3(rdata3));
    always #5 clk=~clk;
    initial begin
        errors=0;
        for (i=0;i<8;i=i+1) begin model[i]=0; written[i]=0; end
        for (i=0;i<20;i=i+1) begin
            we = (i%2==0);
            waddr = i[2:0];
            wdata = (i*11+3)&8'hFF;
            raddr1=(i+1)%8; raddr2=(i+3)%8; raddr3=(i+5)%8;
            #1;
            if ((written[raddr1] && rdata1!==model[raddr1]) ||
                (written[raddr2] && rdata2!==model[raddr2]) ||
                (written[raddr3] && rdata3!==model[raddr3])) begin
                errors=errors+1;
                $display("MISMATCH pre-edge i=%0d", i);
            end
            @(posedge clk); #1;
            if (we) begin model[waddr]=wdata; written[waddr]=1; end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
