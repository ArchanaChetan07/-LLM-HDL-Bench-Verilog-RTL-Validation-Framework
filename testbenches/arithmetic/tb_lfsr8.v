`timescale 1ns/1ps
module tb_lfsr8;
    reg clk=0, rst; wire [7:0] value;
    reg [7:0] model;
    integer i, errors=0;
    lfsr8 dut(.clk(clk), .rst(rst), .value(value));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; @(posedge clk); #1;
        if (value !== 8'hFF) begin errors=errors+1; $display("MISMATCH after reset value=%b expected=11111111",value); end
        model = 8'hFF;
        rst=0;
        for (i=0;i<20;i=i+1) begin
            @(posedge clk); #1;
            model = {model[6:0], model[7]^model[5]^model[4]^model[3]};
            if (value !== model) begin
                errors=errors+1;
                $display("MISMATCH cycle=%0d value=%b expected=%b", i, value, model);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
