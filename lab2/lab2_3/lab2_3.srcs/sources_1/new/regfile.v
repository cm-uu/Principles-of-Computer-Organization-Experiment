`timescale 1ns / 1ps
//raddr1+raddr2=raddr3
module regfile(
  input         add_wen,
  input         clkk,
  input         clk,
  input  [ 4:0] raddr1,
  input  [ 4:0] raddr2,
  input  [ 4:0] raddr3,
  output [31:0] rdata1,
  output [31:0] rdata2,
  output [31:0] rdata3,
  input         wen,
  input  [ 4:0] waddr,
  input  [31:0] wdata,
  input  [ 4:0] test_addr, 
  output [31:0] test_data, 
  output led_add_cout
);
    reg [31:0] rf[31:0];
    
wire [31:0]waddr2;//译码部分
decoder_5_32 uut(
.data_in(waddr),
.data_out(waddr2)
);
integer i;
integer j;
always @(posedge clk)
begin
    if(!clkk)begin
        for(j = 1;j < 32;j = j + 1) begin//复位部分
            rf[j] <= 32'b0;
            end
        end
    else begin
    if(wen == 1)begin
        for(i = 1;i < 32;i = i + 1)begin//写数据
           if(waddr2[i])begin
               rf[i] <= wdata;
               end
        end
    end
    end
    //加法结果
    if (add_wen) begin
            rf[raddr3] <= result;
        end
end
    assign rdata1 = rf[raddr1];
    assign rdata2 = rf[raddr2];
   assign test_data = rf[test_addr];
wire [31:0] result;
wire cout;
adder uutt (//加法部分
    .a(rdata1),
    .b(rdata2),
    .result(result),
    .cout(cout)
); 
//always @(posedge clk)
//    begin
//        if (add_wen) begin
//            rf[raddr3] <= result;
//        end
//    end
assign rdata3 = rf[raddr3];
assign led_add_cout = cout;
endmodule
 
 
 //译码器部分
module decoder_5_32(data_in, data_out) ;
		 input [4:0] data_in ;
		 output reg [31:0] data_out ;
		 always@(data_in)
		 begin
					    case(data_in)
						     5'b0_0000 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0001 ;
							 5'b0_0001 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0010 ;
							 5'b0_0010 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0100 ;
							 5'b0_0011 : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_1000 ;
							 5'b0_0100 : data_out = 32'b0000_0000_0000_0000_0000_0000_0001_0000 ;
							 5'b0_0101 : data_out = 32'b0000_0000_0000_0000_0000_0000_0010_0000 ;
							 5'b0_0110 : data_out = 32'b0000_0000_0000_0000_0000_0000_0100_0000 ;
							 5'b0_0111 : data_out = 32'b0000_0000_0000_0000_0000_0000_1000_0000 ;
							 5'b0_1000 : data_out = 32'b0000_0000_0000_0000_0000_0001_0000_0000 ;
							 5'b0_1001 : data_out = 32'b0000_0000_0000_0000_0000_0010_0000_0000 ;
							 5'b0_1010 : data_out = 32'b0000_0000_0000_0000_0000_0100_0000_0000 ;
							 5'b0_1011 : data_out = 32'b0000_0000_0000_0000_0000_1000_0000_0000 ;
							 5'b0_1100 : data_out = 32'b0000_0000_0000_0000_0001_0000_0000_0000 ;
							 5'b0_1101 : data_out = 32'b0000_0000_0000_0000_0010_0000_0000_0000 ;
							 5'b0_1110 : data_out = 32'b0000_0000_0000_0000_0100_0000_0000_0000 ;
							 5'b0_1111 : data_out = 32'b0000_0000_0000_0000_1000_0000_0000_0000 ;
							 5'b1_0000 : data_out = 32'b0000_0000_0000_0001_0000_0000_0000_0000 ;
							 5'b1_0001 : data_out = 32'b0000_0000_0000_0010_0000_0000_0000_0000 ;
							 5'b1_0010 : data_out = 32'b0000_0000_0000_0100_0000_0000_0000_0000 ;
							 5'b1_0011 : data_out = 32'b0000_0000_0000_1000_0000_0000_0000_0000 ;
							 5'b1_0100 : data_out = 32'b0000_0000_0001_0000_0000_0000_0000_0000 ;
							 5'b1_0101 : data_out = 32'b0000_0000_0010_0000_0000_0000_0000_0000 ;
							 5'b1_0110 : data_out = 32'b0000_0000_0100_0000_0000_0000_0000_0000 ;
							 5'b1_0111 : data_out = 32'b0000_0000_1000_0000_0000_0000_0000_0000 ;
							 5'b1_1000 : data_out = 32'b0000_0001_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1001 : data_out = 32'b0000_0010_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1010 : data_out = 32'b0000_0100_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1011 : data_out = 32'b0000_1000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1100 : data_out = 32'b0001_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1101 : data_out = 32'b0010_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1110 : data_out = 32'b0100_0000_0000_0000_0000_0000_0000_0000 ;
							 5'b1_1111 : data_out = 32'b1000_0000_0000_0000_0000_0000_0000_0000 ;
							 default   : data_out = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
                   endcase
		 end
endmodule
/*
module adder( 
input  [31:0] a, 
input  [31:0] b, 
output [31:0] result, 
output  cout 
   ); 
assign {cout,result} = a + b;
endmodule 
*/
module adder (
    input wire [31:0] a,       
    input wire [31:0] b,         
    output wire [31:0] result,   
    output wire cout         
);
    wire [32:0] cout_in;
    // 初始化进位
    assign cout_in[0] = 1'b0;

    // 生成8个4位超前进位加法器
    genvar i;
    generate
        for (i = 0; i < 8; i= i+1) begin
            adder_4bit uut (
                .a(a[i*4 +: 4]),
                .b(b[i*4 +: 4]),
                .cin(cout_in[i*4]),
                .result(result[i*4 +: 4]),
                .cout(cout_in[i*4 + 4])
            );
        end
    endgenerate

    // 最终进位输出
    assign cout = cout_in[32];

endmodule


module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] result,
    output cout
);
    wire [3:0] G, P;
    wire [4:0] C;
    genvar i;  // 使用 genvar 类型来声明循环变量
    generate
    for (i = 0; i < 4; i = i + 1) begin
        assign G[i] = a[i] & b[i];
        assign P[i] = a[i] ^ b[i];
    end
    endgenerate
    // 计算进位
    assign C[0] = cin;
//    assign c[1] = g[0] | (p[0] & c[0]);
    generate
    for (i = 1; i < 5; i = i + 1) begin
        assign C[i] = G[i - 1] | (P[i - 1] & C[i - 1]);
    end
    endgenerate

    // 计算和
//    assign sum[0] = p[0] ^ c[0];
    generate
    for (i = 0; i < 4; i = i + 1) begin
        assign result[i] = P[i] ^ C[i];
    end
    endgenerate
    assign cout = C[4];
endmodule




