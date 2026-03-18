module pc(
    input clkk,
    output [31:0] rom_data,
    input resetpc,
    input reset_rom,
    output [31:0] pcout,
    output [31:0] offs,
    output reg [31:0]rom_raddr
);

wire [31:0] rom_data1;
always @(posedge clkk) begin
    if (reset_rom) begin
        rom_raddr <= 32'd0;
    end else begin
        rom_raddr <= rom_raddr + 1;
    end
end

// 假设 inst_rom 是一个 ROM 模块
inst_rom u0_irom (
    .a(rom_raddr),
    .spo(rom_data1)
);
assign rom_data = rom_data1;

reg [15:0] offset;
reg [31:0] off;
always @(*) begin
    if (rom_data[31:26] == 6'b010111) begin // 是条件转移指令
        offset = rom_data[25:10];
        off = {{16{rom_data[25]}}, rom_data[25:10]}; // 符号扩展器
    end else begin
        offset = 16'b0;
        off = offset;
    end
end
assign offs = off;

reg [31:0] pc;
always @(posedge clkk or posedge resetpc) begin
    if (resetpc) begin
        pc <= 32'h1c00_0000; // 重置PC
    end else begin
        if (rom_data[31:26] == 6'b010111) begin
            pc <= pc + (off << 2);
        end else begin
            pc <= pc + 4;
        end
    end
end
assign pcout = pc;
endmodule