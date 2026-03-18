`timescale 1ns / 1ps

module alu(
    input  wire [2:0] alu_control,  // ALU控制信号,用几位控制自己修改X值
    input  wire [31:0] alu_src1,     // ALU操作数1,为补码
    input  wire [31:0] alu_src2,     // ALU操作数2，为补码
    output wire [31:0] alu_result    // ALU结果
    );

//补全设计代码，要求add,sub,slt,sltu指令均调用加法器模块实现
//先进行译码
wire [7:0]aluop;
decoder3_8 uut1(
.input_bits(alu_control),
.output_bits(aluop));

// 临时变量用于存储加法和减法结果
    wire [31:0] add_result;
    wire [31:0] sub_result;
    wire add_cout;
    wire sub_cout;
    reg [31:0]aluop_result;

    // 实例化加法器模块
    adder adder_module(
        .a(alu_src1),
        .b(alu_src2),
        .cin(1'b0),
        .sub(1'b0),
        .result(add_result),
        .cout(add_cout)
    );

    // 实例化减法器模块（使用加法器实现）
    adder  adder_uut2(
        .a(alu_src1),
        .b(alu_src2),
        .cin(1'b0),
        .sub(1'b1),
        .result(sub_result),
        .cout(sub_cout)
    );
    wire zf;
    assign zf = (sub_result == 32'd0)? 1:0;
    wire of;
    assign of = (alu_src1[31] == ~alu_src2[31] && sub_result[31] != alu_src1[31])?1:0;
    wire cf;
    assign cf = 1 ^ sub_cout;
    wire sf;
    assign sf = sub_result[31];

    // 逻辑左移和逻辑右移
    wire [31:0] sll_result = alu_src1 << alu_src2[4:0];
    wire [31:0] srl_result = alu_src1 >> alu_src2[4:0];

    // 根据控制信号选择操作
    always @(*) begin
        case (aluop)
            8'b0000_0001: aluop_result = add_result;       // 加法
            8'b0000_0010: aluop_result = sub_result;       // 减法
            8'b0000_0100: aluop_result = (of != sf && zf == 0) ? 32'b1 : 32'b0; // slt
            8'b0000_1000: aluop_result = (cf == 1 && zf == 0) ? 32'b1 : 32'b0; // sltu
            8'b0001_0000: aluop_result = sll_result;       // 逻辑左移
            8'b0010_0000: aluop_result = srl_result;       // 逻辑右移
            default: aluop_result = 32'b0;            // 默认情况
        endcase
    end
    assign alu_result = aluop_result;
endmodule
