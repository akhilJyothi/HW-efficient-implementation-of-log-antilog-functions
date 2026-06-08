`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 08:08:23
// Design Name: 
// Module Name: fp16decodetest
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1ns/1ps

module tb_fp16_decode;

    reg [15:0] x;
    
    wire sign;
    wire [4:0] E;
    wire [10:0] M_full;
    wire signed [5:0] k;

    // Instantiate DUT
    fp16_decode uut (
        .x(x),
        .sign(sign),
        .E(E),
        .M_full(M_full),
        .k(k)
    );

    initial begin
        $display("Time\t x\t sign exp mantissa_full k");

        // Test 1: 1.0
        // FP16: 0 01111 0000000000
        x = 16'b0_01111_0000000000;
        #10;
        $display("%0t\t%b\t%b %d %b %d", $time, x, sign, E, M_full, k);

        // Test 2: 2.0
        // 0 10000 0000000000
        x = 16'b0_10000_0000000000;
        #10;
        $display("%0t\t%b\t%b %d %b %d", $time, x, sign, E, M_full, k);

        // Test 3: 0.5
        // 0 01110 0000000000
        x = 16'b0_01110_0000000000;
        #10;
        $display("%0t\t%b\t%b %d %b %d", $time, x, sign, E, M_full, k);

        // Test 4: 1.5
        // 0 01111 1000000000
        x = 16'b0_01111_1000000000;
        #10;
        $display("%0t\t%b\t%b %d %b %d", $time, x, sign, E, M_full, k);

        // Test 5: Negative number (-2.0)
        // 1 10000 0000000000
        x = 16'b1_10000_0000000000;
        #10;
        $display("%0t\t%b\t%b %d %b %d", $time, x, sign, E, M_full, k);

        $finish;
    end

endmodule

