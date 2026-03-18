`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/11 11:45:00
// Design Name: 
// Module Name: regfile
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
module regfile(
  input         clk,
  input clkk,
  input  [ 4:0] raddr1,
  output [31:0] rdata1,
  input  [ 4:0] raddr2,
  output [31:0] rdata2,
  input         wen,
  input  [ 4:0] waddr,
  input  [31:0] wdata,
  input  [ 4:0] test_addr, //下载测试需要
  output [31:0] test_data  //下载测试需要
);
    reg [31:0] rf[31:0];//32个32位的寄存器
	//在此补全代码
	
    // WRITE
integer i;

always @(posedge clkk or posedge clk)
begin
    if(!clk)begin
        for (i = 0; i < 32; i = i + 1) begin
             rf[i] <= 32'd0; // 复位时清零
        end
       end
    else
    if(wen == 1)begin
        if(waddr != 5'd0) begin
             rf[waddr] <= wdata;
             end
        end
end
   
    // READ OUT 1
    assign rdata1 = rf[raddr1];
    // READ OUT 2
    assign rdata2 = rf[raddr2];
    // READ TESTOUT
   assign test_data = rf[test_addr];
endmodule

