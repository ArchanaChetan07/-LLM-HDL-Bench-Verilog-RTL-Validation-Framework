`timescale 1ns/1ps
module tb_shift_register_piso;
    reg clk=0, rst, load, shift_en; reg [7:0] parallel_in;
    wire serial_out;
    reg [7:0] model;
    integer i, errors=0;
    shift_register_piso dut(.clk(clk), .rst(rst), .load(load), .parallel_in(parallel_in), .shift_en(shift_en), .serial_out(serial_out));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; load=0; shift_en=0; parallel_in=0;
        @(posedge clk); #1; model=0;
        if (serial_out !== model[7]) begin errors=errors+1; $display("MISMATCH after reset so=%b exp=%b",serial_out,model[7]); end
        rst=0; load=1; parallel_in=8'b11001010;
        @(posedge clk); #1; model=8'b11001010;
        if (serial_out !== model[7]) begin errors=errors+1; $display("MISMATCH after load so=%b exp=%b",serial_out,model[7]); end
        load=0; shift_en=1;
        for (i=0;i<8;i=i+1) begin
            @(posedge clk); #1;
            model = {model[6:0], 1'b0};
            if (serial_out !== model[7]) begin
                errors=errors+1;
                $display("MISMATCH shift %0d so=%b exp=%b", i, serial_out, model[7]);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
