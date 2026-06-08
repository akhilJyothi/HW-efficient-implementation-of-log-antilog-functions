`timescale 1ns / 1ps

module fp16_decode(
    input [15:0] x,
    output sign,
    output [4:0] E,
    output [10:0] M_full,
    output [5:0] k
    );
    
    assign sign = x[15];
    assign E = x[14:10];
    assign M_full = {1'b1, x[9:0]};
    assign k = E - 5'd15;
endmodule
