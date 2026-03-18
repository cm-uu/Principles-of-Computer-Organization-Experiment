module fast_adder_32bit (
    input wire [31:0] a,       
    input wire [31:0] b,    
    input wire cin,
    input wire sub,          
    output wire [31:0] result,   
    output wire cout         
);
    wire [31:0] b_2;
    wire [31:0] sum;
    wire [32:0] cout_in;

    // 计算补码（减法时使用）
    assign b_2 = sub ? (~b + 1) : b;//

    // 初始化进位
    assign cout_in[0] = cin;

    // 生成8个4位超前进位加法器
    genvar i;
    generate
        for (i = 0; i < 8; i= i+1) begin
            adder_4bit uut (
                .a(a[i*4 +: 4]),
                .b(b_2[i*4 +: 4]),
                .cin(cout_in[i*4]),
                .result(result[i*4 +: 4]),
                .cout(cout_in[i*4 + 4])
            );
        end
    endgenerate

    // 最终进位输出
    assign cout = cout_in[32];

    // 结果输出
    assign result = sum;
endmodule
