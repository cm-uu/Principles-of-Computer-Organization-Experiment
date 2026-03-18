`timescale 1ns / 1ps
module tongbu_ram(
    input clk,  // 时钟信号
    input [15:0] ram_addr,  // 地址信号，根据RAM深度调整位宽
    input [31:0] ram_wdata,  // 写入数据，根据RAM宽度调整位宽
    input ram_wen,  // 写使能信号
    output [31:0] ram_rdata  // 读出数据
    );
// 实例化同步RAM IP核
block_ram u_block_ram (
    .clka(clk),  // 时钟信号
    .wea(ram_wen),  // 写使能信号
    .addra(ram_addr),  // 地址信号
    .dina(ram_wdata),  // 写入数据
    .douta(ram_rdata)  // 读出数据
);

endmodule
