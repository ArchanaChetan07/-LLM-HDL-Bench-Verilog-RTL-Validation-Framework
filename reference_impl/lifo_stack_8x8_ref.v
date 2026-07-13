module lifo_stack_8x8(input clk, input rst, input push, input [7:0] push_data,
                       input pop, output [7:0] pop_data, output full, output empty);
    reg [7:0] mem [0:7];
    reg [3:0] sp; // stack pointer: number of elements
    always @(posedge clk) begin
        if (rst) sp <= 0;
        else begin
            if (push && pop) begin
                if (sp==0) begin mem[0] <= push_data; sp <= 1; end
                else begin mem[sp-1] <= push_data; end // replace top, depth unchanged
            end else if (push && !full) begin
                mem[sp] <= push_data; sp <= sp+1;
            end else if (pop && !empty) begin
                sp <= sp-1;
            end
        end
    end
    assign full = (sp==8);
    assign empty = (sp==0);
    assign pop_data = mem[sp-1];
endmodule
