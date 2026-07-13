module button_debouncer(input clk, input rst, input button_in, output reg button_out);
    reg [2:0] cnt;
    reg last_in;
    always @(posedge clk) begin
        if (rst) begin cnt<=0; button_out<=0; last_in<=0; end
        else begin
            if (button_in == last_in) begin
                if (cnt < 4) cnt <= cnt + 1;
                if (cnt == 3) button_out <= button_in; // reaches 4 stable cycles this edge
            end else begin
                cnt <= 1;
            end
            last_in <= button_in;
        end
    end
endmodule
