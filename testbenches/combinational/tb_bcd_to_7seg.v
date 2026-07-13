`timescale 1ns/1ps
module tb_bcd_to_7seg;
    reg [3:0] bcd; wire [6:0] seg;
    integer i, errors=0;
    reg [6:0] exp;
    bcd_to_7seg dut(.bcd(bcd), .seg(seg));
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin
            bcd = i[3:0];
            #1;
            case(bcd)
                4'd0: exp=7'b1111110; 4'd1: exp=7'b0110000; 4'd2: exp=7'b1101101; 4'd3: exp=7'b1111001;
                4'd4: exp=7'b0110011; 4'd5: exp=7'b1011011; 4'd6: exp=7'b1011111; 4'd7: exp=7'b1110000;
                4'd8: exp=7'b1111111; 4'd9: exp=7'b1111011; default: exp=7'b0000000;
            endcase
            if (seg !== exp) begin
                errors=errors+1;
                $display("MISMATCH bcd=%d seg=%b expected=%b", bcd, seg, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
