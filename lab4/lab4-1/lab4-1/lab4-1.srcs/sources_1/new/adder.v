module adder (
    input wire [31:0] A,       
    input wire [31:0] B, 
    input wire op, 
    output wire [31:0] result,  
    output wire cout     
);
    wire [31:0] B_in; 
    wire [31:0] sum;      
    wire carry_out;  
    assign B_in = op ? ~B : B;
    adder_32bit adder (
        .a(A),
        .b(B_in),
        .cin(op), 
        .sum(sum),
        .cout(carry_out)
    );
    assign result = sum;
    assign cout = carry_out;
endmodule
module adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire cin,
    output wire [31:0] sum,
    output wire cout
);
    wire [32:0] carry;
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
    assign cout = carry[32];
endmodule
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