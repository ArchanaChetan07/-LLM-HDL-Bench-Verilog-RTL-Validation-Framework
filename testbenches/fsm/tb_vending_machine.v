`timescale 1ns/1ps
module tb_vending_machine;
    reg clk=0, rst, coin_5, coin_10;
    wire dispense;
    integer errors=0;
    vending_machine dut(.clk(clk), .rst(rst), .coin_5(coin_5), .coin_10(coin_10), .dispense(dispense));
    always #5 clk=~clk;
    task tick(input c5, input c10, input exp_disp, input [127:0] msg);
        begin
            coin_5=c5; coin_10=c10;
            @(posedge clk); #1;
            if (dispense !== exp_disp) begin
                errors=errors+1;
                $display("MISMATCH %0s dispense=%b expected=%b", msg, dispense, exp_disp);
            end
        end
    endtask
    initial begin
        rst=1; coin_5=0; coin_10=0; @(posedge clk); #1; rst=0;
        // 5+5+5=15 -> dispense on 3rd nickel
        tick(1,0,0,"nickel1");
        tick(1,0,0,"nickel2");
        tick(1,0,1,"nickel3->dispense");
        // dime+dime = 20 >=15 -> dispense on 2nd dime
        tick(0,1,0,"dime1");
        tick(0,1,1,"dime2->dispense");
        // dime+nickel = 15 -> dispense on nickel
        tick(0,1,0,"dime1b");
        tick(1,0,1,"nickel->dispense");
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
