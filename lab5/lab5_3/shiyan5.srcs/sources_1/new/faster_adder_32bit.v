module fast_adder_32bit (
    input wire [31:0] a,       
    input wire [31:0] b,    
    input wire cin,//低位的进位
    input wire sub, //sub = 0,加法，做加法还是减法         
    output wire [31:0] result, //结果  
    output wire cout  //输出的进位       
);
    wire [31:0] b_2;
    wire [31:0] sum;
    wire [32:0] cout_in;
    assign b_2 = sub ? (~b + 1) : b;
    assign cout_in[0] = cin;
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
    assign cout = cout_in[32];
    assign result = sum;
endmodule


module adder_4bit(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire cin,
    output wire [3:0] result,
    output wire cout
);
    wire [3:0] G, P;
    wire [4:0] C;
    genvar i; 
    generate
    for (i = 0; i < 4; i = i + 1) begin
        assign G[i] = a[i] & b[i];
        assign P[i] = a[i] ^ b[i];
    end
    endgenerate
    assign C[0] = cin;
    generate
    for (i = 1; i < 5; i = i + 1) begin
        assign C[i] = G[i - 1] | (P[i - 1] & C[i - 1]);
    end
    endgenerate
    generate
    for (i = 0; i < 4; i = i + 1) begin
        assign result[i] = P[i] ^ C[i];
    end
    endgenerate
    assign cout = C[4];
endmodule
