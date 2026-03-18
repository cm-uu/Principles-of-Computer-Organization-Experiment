module adder(
    input wire [31:0] A,       
    input wire [31:0] B, 
    input wire op,              // 控制信号 (0: 加法, 1: 减法)
    output wire [31:0] result,  
    output wire cout     
);

    // 内部信号
    wire [31:0] B_in; 
    wire [31:0] sum;      
    wire carry_out;  

    // 加法还是减法
    assign B_in = op ? ~B : B;

    // 32 位加法器
    adder_32bit adder (
        .a(A),
        .b(B_in),
        .cin(op),               // 初始进位为 op
        .sum(sum),
        .cout(carry_out)
    );

    // 输出结果
    assign result = sum;
    assign cout = carry_out;

endmodule

// 32 位加法器模块
module adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output wire [31:0] sum,
    output wire cout
);

    // 内部信号
    wire [32:0] carry;

    // 进位链
    assign carry[0] = cin;
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin 
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // 最终进位
    assign cout = carry[32];

endmodule

// 一位全加器
module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule