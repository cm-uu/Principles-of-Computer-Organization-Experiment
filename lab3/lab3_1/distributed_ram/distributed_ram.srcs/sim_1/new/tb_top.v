`timescale 1ns / 1ps
module tb_top();
    reg clk;
    reg ram_wen;
    reg [15:0] ram_addr;
    reg [31:0] ram_wdata;
    wire [31:0] ram_rdata;
    ram_top u_ram_top(
      .clk(clk),
      .ram_wen(ram_wen),
      .ram_addr(ram_addr),
      .ram_wdata(ram_wdata),
      .ram_rdata(ram_rdata)
    );
    initial begin
        clk = 1'b1;end
    always #5 clk = ~clk;
    initial begin
    //1
        ram_addr = 16'd0;ram_wdata = 32'd0; ram_wen = 1'd0;#20;
    //2.
        ram_addr = 16'd1;ram_wdata = 32'h07010204;ram_wen = 1'b0; #26;
    //3.
        ram_wen = 1'b1;
    //4.
        ram_addr = 16'd2;ram_wdata = 32'h07010201;ram_wen = 1'b1;#10;
    //5.
        ram_wen = 1'b0;ram_addr = 16'd3;ram_wdata = 32'h07010202;ram_wen = 1'b1;#10;ram_wen = 1'b0;
    // 制造同一时刻既读又写的情况
        ram_addr = 16'd1;ram_wdata = 32'h12345678;ram_wen = 1'b1;ram_addr = 16'd1;ram_wen = 1'b0;
    end
endmodule