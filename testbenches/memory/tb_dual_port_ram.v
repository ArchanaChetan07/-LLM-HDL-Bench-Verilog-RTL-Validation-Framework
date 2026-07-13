`timescale 1ns/1ps
module tb_dual_port_ram;
    reg clk=0, we_a, we_b; reg [3:0] addr_a, addr_b; reg [7:0] din_a, din_b;
    wire [7:0] dout_a, dout_b;
    reg [7:0] model [0:15];
    reg written [0:15];
    integer i, errors=0;
    reg [7:0] exp_a, exp_b;
    dual_port_ram dut(.clk(clk), .we_a(we_a), .addr_a(addr_a), .din_a(din_a), .dout_a(dout_a),
                       .we_b(we_b), .addr_b(addr_b), .din_b(din_b), .dout_b(dout_b));
    always #5 clk=~clk;
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin model[i]=0; written[i]=0; end
        we_a=0; we_b=0; addr_a=0; addr_b=0; din_a=0; din_b=0;
        for (i=0;i<30;i=i+1) begin
            we_a = (i%2==0);
            we_b = (i%3==0);
            addr_a = i[3:0];
            addr_b = (i+8) % 16;
            din_a = (i*3+1)&8'hFF;
            din_b = (i*5+2)&8'hFF;
            // synchronous read-before/after-write both acceptable; use read-before-write model (matches ref)
            exp_a = model[addr_a];
            exp_b = model[addr_b];
            @(posedge clk); #1;
            if ((written[addr_a] && dout_a !== exp_a) || (written[addr_b] && dout_b !== exp_b)) begin
                errors=errors+1;
                $display("MISMATCH i=%0d dout_a=%b exp_a=%b dout_b=%b exp_b=%b", i, dout_a, exp_a, dout_b, exp_b);
            end
            if (we_a) begin model[addr_a] = din_a; written[addr_a] = 1; end
            if (we_b) begin model[addr_b] = din_b; written[addr_b] = 1; end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
