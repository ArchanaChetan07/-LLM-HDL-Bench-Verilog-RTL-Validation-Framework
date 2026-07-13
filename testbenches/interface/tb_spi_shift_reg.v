`timescale 1ns/1ps
module tb_spi_shift_reg;
    reg clk=0, rst, load, shift_en, serial_in;
    reg [7:0] parallel_in;
    wire serial_out; wire [7:0] parallel_out;
    reg [7:0] model;
    integer i, errors=0;
    spi_shift_reg dut(.clk(clk), .rst(rst), .load(load), .parallel_in(parallel_in), .shift_en(shift_en),
                       .serial_in(serial_in), .serial_out(serial_out), .parallel_out(parallel_out));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; load=0; shift_en=0; parallel_in=0; serial_in=0;
        @(posedge clk); #1; model=0;
        if (parallel_out !== model) begin errors=errors+1; $display("MISMATCH after reset po=%b exp=%b",parallel_out,model); end
        rst=0;
        load=1; parallel_in=8'b10100110;
        @(posedge clk); #1; model=8'b10100110;
        if (parallel_out !== model || serial_out !== model[7]) begin errors=errors+1; $display("MISMATCH after load po=%b exp=%b",parallel_out,model); end
        load=0; shift_en=1;
        for (i=0;i<8;i=i+1) begin
            serial_in = i[0]; // arbitrary pattern in
            @(posedge clk); #1;
            model = {model[6:0], serial_in};
            if (parallel_out !== model || serial_out !== model[7]) begin
                errors=errors+1;
                $display("MISMATCH shift %0d po=%b exp=%b so=%b exp_so=%b", i, parallel_out, model, serial_out, model[7]);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
