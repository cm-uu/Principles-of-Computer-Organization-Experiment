`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/17 15:51:47
// Design Name: 
// Module Name: SE
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


module SE(
    input [15:0] in16,  // 16位输入
    output [31:0] out32 // 32位输出
);
    assign out32 = {{16{in16[15]}}, in16}; // 根据符号位进行符号扩展
endmodule   

