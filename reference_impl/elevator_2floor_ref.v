module elevator_2floor(input clk, input rst, input call_floor1, input call_floor2,
                        output reg at_floor1, output reg at_floor2, output reg moving);
    reg [1:0] move_cnt;
    reg dest_floor2; // 1 if moving toward floor2, 0 if toward floor1
    always @(posedge clk) begin
        if (rst) begin
            at_floor1<=1; at_floor2<=0; moving<=0; move_cnt<=0; dest_floor2<=0;
        end else if (!moving) begin
            if (at_floor1 && call_floor2) begin moving<=1; move_cnt<=0; dest_floor2<=1; at_floor1<=0; end
            else if (at_floor2 && call_floor1) begin moving<=1; move_cnt<=0; dest_floor2<=0; at_floor2<=0; end
        end else begin
            if (move_cnt == 1) begin
                moving<=0;
                if (dest_floor2) at_floor2<=1; else at_floor1<=1;
            end else begin
                move_cnt <= move_cnt+1;
            end
        end
    end
endmodule
