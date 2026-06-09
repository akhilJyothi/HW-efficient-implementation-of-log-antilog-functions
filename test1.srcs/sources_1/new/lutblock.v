`timescale 1ns / 1ps
module lut_block (
    input  [10:0]        M_full,     // Q1.10 from fp16_decode, range [1.0, 2.0)
    input  [5:0]         seg_idx,    // from segmentselect, range 0–39
    output reg signed [15:0] y       // log2(M_full) output, Q14
);

// LUT storage
reg signed [15:0] lut_a [0:39];     // slopes,     Q14
reg signed [15:0] lut_b [0:39];     // intercepts, Q14
reg        [10:0] edges  [0:40];    // segment edges, Q1.10 — matches M_full width

// Internal signals
reg signed [15:0] a;
reg signed [15:0] b;
reg        [10:0] m_start;
reg signed [11:0] m_prime;          // signed, 1 extra bit for safe subtraction
reg signed [31:0] mult;

initial begin
    $readmemh("a_lut.mem",  lut_a);
    $readmemh("b_lut.mem",  lut_b);
    $readmemh("edges.mem",  edges); // must be regenerated with Q1.10 scaling
end

always @(*) begin
    if (seg_idx < 6'd40) begin
        a       = lut_a[seg_idx];
        b       = lut_b[seg_idx];
        m_start = edges[seg_idx];

        // Both M_full and m_start are 11-bit unsigned Q1.10
        // Extend to 12-bit signed for safe subtraction
        m_prime = {1'b0, M_full} - {1'b0, m_start};  // Q1.10, signed 12-bit

        // Q14 × Q10 = Q24; shift back to Q14
        mult = a * m_prime;
        y = ((mult + 32'sd512) >>> 10) + b;  // +512 = 0.5 in Q10, for rounding

    end else begin
        y = 16'sd0;
    end
end

endmodule