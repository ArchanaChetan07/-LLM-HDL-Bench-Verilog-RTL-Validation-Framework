module lifo_stack_8x8(
    input clk,
    input rst,
    input push,
    input  [7:0] push_data,
    input pop,
    output [7:0] pop_data,
    output full,
    output empty
);
    reg [7:0] mem [0:7];
    reg [3:0] sp;

    always @(posedge clk) begin
        if (rst) begin
            sp <= 0;
        end else if (push && pop) begin
            if (sp != 0)
                mem[sp-1] <= push_data;
            else begin
                mem[0] <= push_data;
                sp <= 1;
            end
        end else if (push && sp != 8) begin
            mem[sp] <= push_data;
            sp <= sp + 1;
        end else if (pop && sp != 0) begin
            sp <= sp - 1;
        end
    end

    assign full = (sp == 8);
    assign empty = (sp == 0);
    assign pop_data = mem[sp-1];
endmodule
