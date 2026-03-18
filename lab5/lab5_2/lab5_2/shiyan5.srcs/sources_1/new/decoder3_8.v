module decoder3_8(
    input wire [2:0] input_bits, // 3位输入
    output reg [7:0] output_bits // 8位输出
);

    // 组合逻辑
    always @(*) begin
            case (input_bits)
                3'd0: output_bits=8'b0000_0001; // 输入为000，输出Y0为高电平
                3'd1: output_bits=8'b0000_0010; // 输入为001，输出Y1为高电平
                3'd2: output_bits=8'b0000_0100; // 输入为010，输出Y2为高电平
                3'd3: output_bits=8'b0000_1000; // 输入为011，输出Y3为高电平
                3'd4: output_bits=8'b0001_0000; // 输入为100，输出Y4为高电平
                3'd5: output_bits=8'b0010_0000; // 输入为101，输出Y5为高电平
                3'd6: output_bits=8'b0100_0000; // 输入为110，输出Y6为高电平
                3'd7: output_bits=8'b1000_0000; // 输入为111，输出Y7为高电平
                default: output_bits = 8'b00000000; // 默认情况
            endcase
    end
endmodule