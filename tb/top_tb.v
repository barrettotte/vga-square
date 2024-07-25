`include "../rtl/top.v"
`timescale 1ns/1ps

module top_tb;

    // inputs

    // outputs

    // design under test
    top DUT(
    );

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
        // $monitor($time, " clk_1=%b", clk_1);

        // init

        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
