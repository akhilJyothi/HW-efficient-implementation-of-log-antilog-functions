`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 10:59:43
// Design Name: 
// Module Name: segmentselecttb
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


module segmentselecttb(
);
reg[10:0] M_full;
wire[5:0]seg_idx;

segmentselect uut(.M_full(M_full), .seg_idx(seg_idx));
initial
begin
#10;
$display("t=%0t\t seg_idx=%b", $time, seg_idx);
M_full= 11'b11110101101;
$display("t=%0t\t seg_idx=%b", $time, seg_idx);
#10;
M_full= 11'b11001101101;
$display("t=%0t\t seg_idx=%b", $time, seg_idx);
#10;
M_full=11'b10101010101;
$display("t=%0t\t seg_idx=%b", $time, seg_idx);
#10;
$finish;
end

endmodule
