module priority_arbiter4(
    input  [3:0] req,
    output [3:0] grant
);
    assign grant = req[0] ? 4'b0001 :
                   req[1] ? 4'b0010 :
                   req[2] ? 4'b0100 :
                   req[3] ? 4'b1000 : 4'b0000;
endmodule
