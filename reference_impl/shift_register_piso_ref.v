module shift_register_piso(input clk, input rst, input load, input [7:0] parallel_in, input shift_en, output serial_out);
    reg [7:0] shreg;
    always @(posedge clk) begin
        if (rst) shreg <= 8'b0;
        else if (load) shreg <= parallel_in;
        else if (shift_en) shreg <= {shreg[6:0], 1'b0};
    end
    assign serial_out = shreg[7];
endmodule
