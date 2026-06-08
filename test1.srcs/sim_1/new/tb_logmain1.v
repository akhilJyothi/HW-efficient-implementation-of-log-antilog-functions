
`timescale 1ns / 1ps
module tb_logmain;

// Inputs
reg [15:0] x;

// Output
wire signed [15:0] ln_out;

// Instantiate top module
logmain uut (
    .x(x),
    .ln_out(ln_out)
);

// Real value display task
task check;
    input [15:0] fp16_in;
    input real   expected_ln;
    input real   fp16_real_value;
    begin
        x = fp16_in;
        #10;
        $display("x = %h | real value = %f | expected ln = %f | got ln = %f | error = %f",
            fp16_in,
            fp16_real_value,
            expected_ln,
            $itor(ln_out) / 16384.0,   // convert Q14 back to real
            expected_ln - ($itor(ln_out) / 16384.0));
    end
endtask

initial begin
    $display("--- ln(x) testbench ---");
    $display("input_hex | real_value | expected_ln | got_ln | error");

    // ln(1.0) = 0.0        fp16: sign=0, E=15(01111), M=0  → 0x3C00
    check(16'h3C00, 0.0,       1.0);

    // ln(2.0) = 0.6931     fp16: sign=0, E=16(10000), M=0  → 0x4000
    check(16'h4000, 0.693147,  2.0);

    // ln(0.5) = -0.6931    fp16: sign=0, E=14(01110), M=0  → 0x3800
    check(16'h3800, -0.693147, 0.5);

    // ln(1.5) = 0.4055     fp16: sign=0, E=15(01111), M=1.5→ 0x3E00
    check(16'h3E00, 0.405465,  1.5);

    // ln(4.0) = 1.3863     fp16: sign=0, E=17(10001), M=0  → 0x4400
    check(16'h4400, 1.386294,  4.0);

    // ln(0.25) = -1.3863   fp16: sign=0, E=13(01101), M=0  → 0x3400
    check(16'h3400, -1.386294, 0.25);
    // ln(4.0)  = 1.3863   k=2   -- the one that was failing before
check(16'h4400, 1.386294,  4.0);

// ln(8.0)  = 2.0794   k=3
check(16'h4800, 2.079442,  8.0);

// ln(16.0) = 2.7726   k=4
check(16'h4C00, 2.772589,  16.0);

// ln(100)  = 4.6052   k≈6
check(16'h5640, 4.605170,  100.0);

// ln(1000) = 6.9078   k≈9
check(16'h6400, 6.907755,  1000.0);

// ln(65504)= 11.0898  k=15  -- largest finite fp16 number
check(16'h7BFF, 11.089750, 65504.0);

    $display("--- done ---");
    $finish;
end
// probe internal signals


endmodule
