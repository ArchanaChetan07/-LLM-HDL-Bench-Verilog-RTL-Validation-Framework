`timescale 1ns/1ps
module tb_incrementer4bit;
    reg [3:0] in; wire [3:0] out; wire overflow;
    integer i,errors=0;
    reg [3:0] exp_out; reg exp_of;
    incrementer4bit dut(.in(in),.out(out),.overflow(overflow));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin
            in=i[3:0];
            #1;
            exp_out = in+1;
            exp_of = (in==4'b1111);
            if (out!==exp_out || overflow!==exp_of) begin
                errors=errors+1;
                $display("MISMATCH in=%d out=%d overflow=%b exp_out=%d exp_of=%b",in,out,overflow,exp_out,exp_of);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
