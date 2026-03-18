module fast_adder_32bit (
    input wire [31:0] a,       // 输入 A
    input wire [31:0] b,       // 输入 B
    input wire cin,            // 输入进位
    output wire [31:0] sum,    // 输出和
    output wire cout           // 输出进位
);

    // 内部信号
    wire [31:0] G;             // 生成信号
    wire [31:0] P;             // 传播信号
    wire [32:0] C;             // 进位信号

    // 计算生成信号和传播信号
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign G[i] = a[i] & b[i];         // 生成信号
            assign P[i] = a[i] ^ b[i];         // 传播信号
        end
    endgenerate

    // 计算进位信号
    assign C[0] = cin;                         // 初始进位
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign C[i+1] = G[i] | (P[i] & C[i]); // 进位计算
        end
    endgenerate

    // 计算输出和
    generate
        for (i = 0; i < 32; i = i + 1) begin
            assign sum[i] = a[i] ^ b[i] ^ C[i]; // 和 = A XOR B XOR Cin
        end
    endgenerate

    // 输出最终进位
    assign cout = C[32];

endmodule