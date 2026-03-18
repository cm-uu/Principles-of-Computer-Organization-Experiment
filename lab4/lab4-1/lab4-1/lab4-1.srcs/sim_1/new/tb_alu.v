module tb_alu;
    reg [2:0] alu_control;
    reg [31:0] alu_src1;
    reg [31:0] alu_src2;
    wire [31:0] alu_result;
    wire [7:0] aluop;

    alu alu_module(
        .alu_control(alu_control),
        .alu_src1(alu_src1),
        .alu_src2(alu_src2),
        .alu_result(alu_result)
    );
    decoder3_8 uut1(
        .input_bits(alu_control),
        .output_bits(aluop)
    );

    initial begin
        // Initialize Inputs
        alu_src1 = 32'h07010204; // 学号的后8位，示例值
        alu_src2 = 32'h07010206;
        #20;
        // Add stimulus here,设计的运算在此都要仿真
        alu_control = 3'd0; // add.w
        #20;
        alu_control = 3'd1; // sub.w
        #20;
        alu_control = 3'd2; // slt
        #20;
        alu_control = 3'd3; // sltu
        #20;
        alu_control = 3'd4; // sll.w
        #20;
        alu_control = 3'd5; // srl.w
        #20;
    end
endmodule