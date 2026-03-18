`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 23:02:17
// Design Name: 
// Module Name: inst_rom_top
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

module inst_rom_top(
    input [31:0] rom_addr,
    output [31:0] rom_rdata
);
    inst_rom u0_irom (
      .a(rom_addr),
      .spo(rom_rdata)
    );
endmodule
