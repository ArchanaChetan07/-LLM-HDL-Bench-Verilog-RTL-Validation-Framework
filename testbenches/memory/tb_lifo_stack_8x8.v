`timescale 1ns/1ps
module tb_lifo_stack_8x8;
    reg clk=0, rst, push, pop; reg [7:0] push_data;
    wire [7:0] pop_data; wire full, empty;
    reg [7:0] model [0:7]; integer sp;
    integer errors=0, i;
    lifo_stack_8x8 dut(.clk(clk), .rst(rst), .push(push), .push_data(push_data), .pop(pop),
                        .pop_data(pop_data), .full(full), .empty(empty));
    always #5 clk=~clk;
    task check_flags(input [127:0] msg); begin
        if (full!==(sp==8) || empty!==(sp==0)) begin
            errors=errors+1;
            $display("MISMATCH %0s full=%b empty=%b sp=%0d", msg, full, empty, sp);
        end
    end endtask
    initial begin
        errors=0; sp=0;
        rst=1; push=0; pop=0; push_data=0; @(posedge clk); #1; check_flags("after reset");
        rst=0;
        for (i=0;i<10;i=i+1) begin
            push=1; pop=0; push_data=i[7:0]+8'h20;
            @(posedge clk); #1;
            if (sp<8) begin model[sp]=push_data; sp=sp+1; end
            check_flags("push loop");
        end
        push=0;
        for (i=0;i<10;i=i+1) begin
            if (sp>0) begin
                if (pop_data !== model[sp-1]) begin
                    errors=errors+1;
                    $display("MISMATCH pop %0d pop_data=%b expected=%b", i, pop_data, model[sp-1]);
                end
            end
            pop=1;
            @(posedge clk); #1;
            if (sp>0) sp=sp-1;
            check_flags("pop loop");
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
