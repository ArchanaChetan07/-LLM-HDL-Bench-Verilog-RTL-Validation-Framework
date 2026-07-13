module button_debouncer(
    input clk,
    input rst,
    input button_in,
    output reg button_out
);
    reg [2:0] stable_cnt;
    reg last_in;

    always @(posedge clk) begin
        if (rst) begin
            stable_cnt <= 0;
            button_out <= 0;
            last_in <= 0;
        end else begin
            if (button_in == last_in) begin
                if (stable_cnt < 4)
                    stable_cnt <= stable_cnt + 1;
                if (stable_cnt == 3)
                    button_out <= button_in;
            end else begin
                stable_cnt <= 1;
            end
            last_in <= button_in;
        end
    end
endmodule
