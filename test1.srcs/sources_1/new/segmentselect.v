`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 10:43:34
// Design Name: 
// Module Name: segmentselect
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


module segmentselect(M_full,seg_idx
   );
 input [10:0] M_full;
 output reg[5:0] seg_idx;
always @(*) begin

    if (M_full[9] == 1'b0) 
    begin
        // LOWER HALF: [1, 1.5)
        // Use 5 bits → 32 segments
        seg_idx = {1'b0, M_full[8:4]};  
        // 0–31
    end else begin
        // UPPER HALF: [1.5, 2)
        // Use 3 bits → 8 segments

        seg_idx = 6'd32 + M_full[8:6];  
        // 32–39
    end

end


endmodule
