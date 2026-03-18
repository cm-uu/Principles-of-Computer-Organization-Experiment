module tb_pc;

    // 输入信号
    reg clkk; // 独属于这个部件的时钟信号
    reg clk; // 主时钟信号
    reg reset_rom_addr; // 复位ROM地址
    reg regwr; // 寄存器写使能信号
    reg reg_from_out; // 写入数据是否来自外部
    reg alustr; // 第二个操作数是否来自寄存器或立即数扩展
    reg [31:0] write_data; // 外部写入的数据
    reg [4:0] write_addr; // 外部写入的地址

    // 输出信号
    wire [31:0] pc; // 程序计数器
    wire [31:0] inst; // 取到的指令
    wire [31:0] offset; // 指令中的偏移量
    wire [31:0] add_res; // 加法结果
    wire [4:0] rdd; // 目标寄存器地址
    wire [4:0] rjj; // 源寄存器地址

    // 实例化被测试模块
    pc uut (
        .clkk(clkk),
        .clk(clk),
        .reset_rom_addr(reset_rom_addr),
        .regwr(regwr),
        .reg_from_out(reg_from_out),
        .alustr(alustr),
        .write_data(write_data),
        .write_addr(write_addr),
        .pc(pc),
        .inst(inst),
        .offset(offset),
        .add_res(add_res),
        .rdd(rdd),
        .rjj(rjj)
    );

    // 时钟信号生成
    initial begin
        clkk = 0;
        clk = 0;
        forever #5 clkk = ~clkk; // 生成clkk时钟信号
        forever #10 clk = ~clk; // 生成主时钟信号，周期为20ns
    end

    // 测试过程
    initial begin
        // 初始化信号
        reset_rom_addr = 1;
        regwr = 0;
        reg_from_out = 0;
        alustr = 0;
        write_data = 0;
        write_addr = 0;

        // 复位ROM地址
        #10 reset_rom_addr = 0;

        // 向寄存器中写入初始值
        reg_from_out = 1; // 写入数据来自外部
        write_addr = 1; // 写入地址为1号寄存器
        write_data = 32'h07010204; // 写入数据
        #20 regwr = 1; // 使能寄存器写操作
        #10 regwr = 0; // 禁用寄存器写操作

        write_addr = 2; // 写入地址为2号寄存器
        write_data = 32'h12; // 写入数据
        #20 regwr = 1; // 使能寄存器写操作
        #10 regwr = 0; // 禁用寄存器写操作

        // 等待一个时钟周期
        #20;

        // 开始取指令和执行指令
        reg_from_out = 0; // 写入数据不再来自外部
        alustr = 0; // 第二个操作数来自寄存器

        // 等待一个时钟周期后执行指令
        #10 alustr = 1; // 第二个操作数来自立即数扩展

        // 模拟一段时间后结束仿真
        #100 $finish;
    end

endmodule