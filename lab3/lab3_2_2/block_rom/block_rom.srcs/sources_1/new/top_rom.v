module top_rom (
    input clk,          // 时钟信号
    input [15:0] rom_addr, // ROM地址
    output  [31:0] rom_rdata // ROM读出数据
);

    // 实例化同步ROM IP核
    block_rom block_rom_inst (
        .clka(clk), // 时钟信号
        .addra(rom_addr), // 地址信号
        .douta(rom_rdata) // 数据输出
    );

endmodule