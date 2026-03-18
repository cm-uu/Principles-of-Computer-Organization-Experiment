`timescale 1ns / 1ps

module tb3_2_1;
    reg clk;  // 时钟信号
    reg ram_wen;  // 写使能信号
    reg [15:0] ram_addr;  // 地址信号
    reg [31:0] ram_wdata;  // 写入数据
    wire [31:0] ram_rdata;  // 读出数据

    // 实例化顶层模块
    tongbu_ram u_sync_ram_top (
        .clk(clk),
        .ram_wen(ram_wen),
        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_rdata(ram_rdata)
    );

    initial begin
        clk = 1'b1;
    end
    always #5 clk = ~clk;
    initial begin
        ram_addr = 16'd0; ram_wdata = 32'd0; ram_wen = 1'd0; #20;
        ram_addr = 16'd1; ram_wdata = 32'h07010204; ram_wen = 1'b0; #20;
        ram_wen = 1'b1; #10; ram_wen = 1'b0;
        ram_addr = 16'd2; ram_wdata = 32'h07010201; ram_wen = 1'b1; #10; ram_wen = 1'b0;
        ram_addr = 16'd3; ram_wdata = 32'h07010202; ram_wen = 1'b1; #10; ram_wen = 1'b0;
        ram_addr = 16'd1; ram_wen = 1'b0; #10;
        ram_addr = 16'd1; ram_wdata = 32'h12345678; ram_wen = 1'b1; #10; ram_wen = 1'b0;
        ram_addr = 16'd1; ram_wen = 1'b0; #10;
    end
endmodule