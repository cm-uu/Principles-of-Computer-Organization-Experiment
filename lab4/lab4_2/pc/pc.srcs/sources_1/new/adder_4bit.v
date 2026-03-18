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
