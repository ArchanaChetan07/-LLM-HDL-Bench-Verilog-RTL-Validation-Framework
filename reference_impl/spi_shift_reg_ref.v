module spi_shift_reg(input clk, input rst, input load, input [7:0] parallel_in, input shift_en,
                      input serial_in, output serial_out, output [7:0] parallel_out);
    reg [7:0] shreg;
    always @(posedge clk) begin
        if (rst) shreg <= 8'b0;
        else if (load) shreg <= parallel_in;
        else if (shift_en) shreg <= {shreg[6:0], serial_in};
    end
    assign serial_out = shreg[7];
    assign parallel_out = shreg;
endmodule
