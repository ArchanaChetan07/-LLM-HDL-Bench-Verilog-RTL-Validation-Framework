module one_pulse_edge_detector_io(
    input clk,
    input rst,
    input sig_in,
    output reg edge_pulse
);
    reg prev;

    always @(posedge clk) begin
        if (rst) begin
            prev <= 0;
            edge_pulse <= 0;
        end else begin
            edge_pulse <= (sig_in != prev);
            prev <= sig_in;
        end
    end
endmodule
