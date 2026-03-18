`timescale 1ns / 1ps
module tb;
    reg         add_wen;
    reg         clkk;
    reg         clk;
    reg  [4:0]  raddr1;
    reg  [4:0]  raddr2;
    reg  [4:0]  raddr3;
    reg         wen;
    reg  [4:0]  waddr;
    reg  [31:0] wdata;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    wire [31:0] rdata3;
    reg  [4:0]  test_addr;
    wire [31:0] test_data;
    wire cout;
    regfile uut (
        .add_wen(add_wen),
        .clkk(clkk),
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .raddr3(raddr3),
        .rdata1(rdata1), // 补充 rdata1 端口连接
        .rdata2(rdata2), // 补充 rdata2 端口连接
        .rdata3(rdata3),
        .wen(wen),
        .waddr(waddr),
        .wdata(wdata),
        .test_addr(test_addr),
        .test_data(test_data),
        .led_add_cout(cout)
    );

    initial begin
        clk = 0;
        clkk = 1; // 初始设置 clkk 为高电平
    end
    always #5 clk = ~clk;
//1+2=3
    initial begin
     add_wen = 1'b0;//写第一个数
     raddr1 = 5'd1;
     raddr2 = 5'd2;
     raddr3 = 5'd3;
     wen = 1'b1;
     waddr = 5'd1;
     wdata = 32'h07010204;
     test_addr = 5'd1;
     
     #20;
     add_wen = 1'b0;//写第二个数
     raddr1 = 5'd1;
     raddr2 = 5'd2;
     raddr3 = 5'd3;
     wen = 1'b1;
     waddr = 5'd2;
     wdata = 32'h0210;
     test_addr = 5'd1;
     
     #20;
     add_wen = 1'b1;//第一次加法
     raddr1 = 5'd1;
     raddr2 = 5'd2;
     raddr3 = 5'd3;
     wen = 1'b0;
     waddr = 5'd2;
     wdata = 32'h07010204;
     test_addr = 5'd1;
      #20;
     add_wen = 1'b0;//更改第二个加数
     raddr1 = 5'd1;
     raddr2 = 5'd2;
     raddr3 = 5'd3;
     wen = 1'b1;
     waddr = 5'd2;
     wdata = 32'h07010204;
     test_addr = 5'd1;
       #20;
     add_wen = 1'b1;//第二次加法
     raddr1 = 5'd1;
     raddr2 = 5'd2;
     raddr3 = 5'd3;
     wen = 1'b0;
     waddr = 5'd2;
     wdata = 32'h07010204;
     test_addr = 5'd1;
     
    end

endmodule