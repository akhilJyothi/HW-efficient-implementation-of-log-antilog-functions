`timescale 1ns / 1ps
module logmain ( input [15:0] x, output signed [15:0] ln_out ); 
wire sign; 
wire [4:0] E; 
wire [10:0] M_full; 
wire [5:0] k; 
wire [5:0] seg_idx; 
wire signed [15:0] y_lut; 
// Stage 1 
fp16_decode u_dec ( .x(x), .sign(sign), .E(E), .M_full(M_full), .k(k) ); 
// Stage 2 
segmentselect u_seg ( .M_full(M_full), .seg_idx(seg_idx) ); 
// Stage 3 
lut_block u_lut ( .M_full(M_full), .seg_idx(seg_idx), .y(y_lut) ); 
// Stage 4 
wire signed [15:0] k_signed; 
wire signed [19:0] log2_x; 
wire signed [35:0] ln_mult; 
assign k_signed = {{10{k[5]}}, k}; 
assign log2_x = (k_signed <<< 14) + y_lut; 

// Stage 5 
assign ln_mult = log2_x * 16'sd11356; 
assign ln_out = ln_mult >>> 14; 
endmodule