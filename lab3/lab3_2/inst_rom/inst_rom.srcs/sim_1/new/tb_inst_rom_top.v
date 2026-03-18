`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/10 23:03:38
// Design Name: 
// Module Name: tb_inst_rom_top
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

module tb_inst_rom_top();
    reg [31:0] rom_addr;
    wire [31:0] rom_rdata;

    // 实例化待测模块
    inst_rom_top uut (
      .rom_addr(rom_addr),
      .rom_rdata(rom_rdata)
    );

    // 初始化测试信号
    initial begin
        // 初始化地址为0
        rom_addr = 32'd0;
        #10;

        // 改变地址为1
        rom_addr = 32'd1;
        #10;

        // 改变地址为2
        rom_addr = 32'd2;
        #10;
      
         // 改变地址为2
        rom_addr = 32'd3;
        #10;
         // 改变地址为2
        rom_addr = 32'd4;
        #10;
         // 改变地址为2
        rom_addr = 32'd5;
        #10;
         // 改变地址为2
        rom_addr = 32'd6;
        #10;
         // 改变地址为2
        rom_addr = 32'd7;
        #10;
         // 改变地址为2
        rom_addr = 32'd8;
        #10;
         // 改变地址为2
        rom_addr = 32'd9;
        #10;
         // 改变地址为2
        rom_addr = 32'd10;
        #10;
         // 改变地址为2
        rom_addr = 32'd11;
        #10;
         // 改变地址为2
        rom_addr = 32'd12;
        #10;
        

        $finish;
    end
endmodule
