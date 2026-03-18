module pc(
    input clkk,//独属于这个部件的clkk信号
    input clk,
    input reset_rom_addr,
    input regwr,//是不是写到寄存器中
    input reg_from_out,//写入的数据是不是来自外部
    input alustr,//第二个操作数是来自寄存器还是立即数扩展
    input [31:0]write_data,//显示外部写进去的数据
    input [4:0] write_addr,//显示外部写入的地址
    output reg [31:0]pc,//显示pc
    output [31:0]inst,//显示指令
    input  [ 4:0] test_addr, 
    output [31:0] test_data,
    output [31:0]offset,//显示指令中的偏移量
    output [31:0]add_res,
    output [4:0]rdd,
    output [4:0]rjj
    );
    
 
reg [31:0]rom_addr;
wire [31:0] rom_rdata;
always @(posedge clkk)begin
if(reset_rom_addr)begin
     rom_addr = 32'b0;
     pc = 32'h1c00_0000;
     end
else begin
     rom_addr = rom_addr + 1;
     pc = pc + 4;
     end
end
//实例化rom,每来一个clkk，取一个指令  
inst_ram uut_irom (
      .a(rom_addr),
      .spo(rom_rdata)
    );
assign inst = rom_rdata;
//解析指令    
wire [ 4:0] rd;
wire [ 4:0] rj;
wire [ 4:0] rk;
wire [11:0] i12;
assign rd       = rom_rdata[ 4: 0];
assign rj       = rom_rdata[ 9: 5];
assign rk       = rom_rdata[14:10];
assign i12      = rom_rdata[21:10];
assign offset = (alustr)?{{20{i12[11]}}, i12}:32'd0;
assign rdd = rd;
assign rjj = rj;
//寄存器部分
wire [4:0]raddr2;
wire we;
reg [31:0]wdata;
//输出
wire [31:0]rdata1;
wire [31:0]rdata2;
wire [4:0]waddr;
assign we = regwr || reg_from_out;
assign raddr2 = (alustr)?rd:rk;
assign waddr = (reg_from_out == 1 & regwr == 0)?write_addr:rd;//写地址
regfile uut_regfile(.clk(clk),.raddr1(rj),
.raddr2(raddr2),.rdata1(rdata1),.rdata2(rdata2),
.we(we),.waddr(waddr),.wdata(wdata),.test_data(test_data),.test_addr(test_addr));
wire [31:0]rdata22;
//判断第二个操作数
assign rdata22 = (alustr)?{{20{i12[11]}}, i12}:rdata2;
//加法模块
wire [31:0]add_result;
wire add_cout;
fast_adder_32bit uut_adder2(.a(rdata1),.b(rdata22),.cin(1'b0),.sub(1'b0),
.result(add_result),.cout(add_cout));
assign add_res = add_result;//显示加法的结果
//要写回的数据
always@(*)begin
if(reg_from_out == 1 & regwr == 0)begin
     wdata = write_data; end
else begin
     wdata = add_result; end end endmodule
