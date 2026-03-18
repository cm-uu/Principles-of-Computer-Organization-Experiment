`timescale 1ns / 1ps
module tst;
// Inputs
reg [31:0]a;
reg [31:0] b;
reg cin;
// Outputs
wire [31:0] sum;
wire cout;
// Instantiate the Unit Under Test (UUT)
fast_adder_32bit uut (
.a(a),
.b(b),
.cin(cin),
.sum(sum),
.cout(cout)
);
initial begin
// Initialize Inputs
a = 0;
b = 0;
cin = 0;
// Wait 100 ns for global reset to finish
#100;
// Add stimulus here
end
always #10 a=$random; //$random 为系统任务，产生一个随机的 32 位数
always #10 b=$random; //#10 表示等待 10 个单位时间(10ns)，即每过 10ns，赋值一个随机的 32 位数
always #10 cin = {$random}%2;
endmodule
