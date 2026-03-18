module full_adder (
    input wire a,       // 输入 A
    input wire b,       // 输入 B
    input wire cin,     // 进位输入
    output wire sum,    // 输出和
    output wire cout    // 进位输出
);
    assign sum = a ^ b ^ cin;           // 和 = A XOR B XOR Cin
    assign cout = (a & b) | (cin & (a ^ b)); // 进位输出 = (A AND B) OR (Cin AND (A XOR B))
endmodule