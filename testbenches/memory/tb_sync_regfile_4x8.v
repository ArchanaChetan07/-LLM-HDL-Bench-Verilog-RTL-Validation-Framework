`timescale 1ns/1ps
module tb_sync_regfile_4x8;
    reg clk=0, we; reg [1:0] waddr, raddr1, raddr2; reg [7:0] wdata;
    wire [7:0] rdata1, rdata2;
    reg [7:0] model [0:3];
    reg written [0:3];
    integer i, errors=0;
    sync_regfile_4x8 dut(.clk(clk), .we(we), .waddr(waddr), .wdata(wdata),
                          .raddr1(raddr1), .raddr2(raddr2), .rdata1(rdata1), .rdata2(rdata2));
    always #5 clk=~clk;
    initial begin
        errors=0;
        model[0]=0; model[1]=0; model[2]=0; model[3]=0;
        written[0]=0; written[1]=0; written[2]=0; written[3]=0;
        we=0; waddr=0; wdata=0; raddr1=0; raddr2=0;
        for (i=0;i<20;i=i+1) begin
            we = (i%3 != 0);
            waddr = i[1:0];
            wdata = (i*7+3) & 8'hFF;
            raddr1 = (i+1)%4;
            raddr2 = (i+2)%4;
            #1; // combinational reads reflect pre-edge state
            if ((written[raddr1] && rdata1 !== model[raddr1]) || (written[raddr2] && rdata2 !== model[raddr2])) begin
                errors=errors+1;
                $display("MISMATCH pre-edge i=%0d rdata1=%b exp1=%b rdata2=%b exp2=%b", i, rdata1, model[raddr1], rdata2, model[raddr2]);
            end
            @(posedge clk); #1;
            if (we) begin model[waddr] = wdata; written[waddr] = 1; end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
