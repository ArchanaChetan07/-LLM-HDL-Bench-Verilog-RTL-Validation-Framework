`timescale 1ns/1ps
module tb_elevator_2floor;
    reg clk=0, rst, call_floor1, call_floor2;
    wire at_floor1, at_floor2, moving;
    integer errors=0;
    elevator_2floor dut(.clk(clk), .rst(rst), .call_floor1(call_floor1), .call_floor2(call_floor2),
                         .at_floor1(at_floor1), .at_floor2(at_floor2), .moving(moving));
    always #5 clk=~clk;
    task tick; begin @(posedge clk); #1; end endtask
    initial begin
        errors=0;
        rst=1; call_floor1=0; call_floor2=0; tick;
        if (!(at_floor1===1 && at_floor2===0 && moving===0)) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        // request floor2 while idle at floor1
        call_floor2=1; tick; call_floor2=0;
        if (moving!==1) begin errors=errors+1; $display("MISMATCH should be moving cycle1 moving=%b",moving); end
        tick; // 2nd moving cycle
        if (moving!==1) begin errors=errors+1; $display("MISMATCH should be moving cycle2 moving=%b",moving); end
        tick; // should arrive at floor2 now
        if (!(at_floor2===1 && at_floor1===0 && moving===0)) begin errors=errors+1; $display("MISMATCH should be at floor2 f1=%b f2=%b moving=%b",at_floor1,at_floor2,moving); end
        // request floor1 while idle at floor2
        call_floor1=1; tick; call_floor1=0;
        tick; tick;
        if (!(at_floor1===1 && at_floor2===0 && moving===0)) begin errors=errors+1; $display("MISMATCH should be back at floor1"); end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
