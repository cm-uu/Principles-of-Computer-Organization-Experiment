module minicpu_top(
    input  wire        clk,
    input  wire        resetn,
    output wire        inst_sram_we,//指令寄存器相关
    output wire [31:0] inst_sram_addr,
    output wire [31:0] inst_sram_wdata,
    input  wire [31:0] inst_sram_rdata,
    
    output wire        data_sram_we,//数据寄存器相关
    output wire [31:0] data_sram_addr,
    output wire [31:0] data_sram_wdata,
    input  wire [31:0] data_sram_rdata
);

reg         reset;//取反，输入低有效
always @(posedge clk) reset <= ~resetn;

reg         valid;//有效信号
always @(posedge clk) begin
    if (reset) begin
        valid <= 1'b0;
    end
    else begin
        valid <= 1'b1;
    end
end

reg  [31:0] pc;//指令
wire [31:0] nextpc;//下一条指令
assign n = nextpc;
wire [31:0] inst;//指令内容

wire [ 5:0] op_31_26;//指令操作码分解
wire [ 3:0] op_25_22;
wire [ 1:0] op_21_20;
wire [ 4:0] op_19_15;
wire [63:0] op_31_26_d;//指令操作码分解后译码结果
wire [15:0] op_25_22_d;
wire [ 3:0] op_21_20_d;
wire [31:0] op_19_15_d;
wire [ 4:0] rd;
wire [ 4:0] rj;
wire [ 4:0] rk;
wire [11:0] i12;//12位立即数
wire [15:0] i16;//16位立即数

wire        inst_add_w;//确定做什么指令
wire        inst_addi_w;
wire        inst_ld_w;
wire        inst_st_w;
wire        inst_bne;

wire        src2_is_imm;//第二个操作数是不是立即数
wire        res_from_mem;//是不是来自主存
wire        gr_we;//寄存器写使能信号
wire        mem_we;//主存写使能信号
wire        src_reg_is_rd;
wire [31:0] rj_value;
wire [31:0] rkd_value;

wire [ 4:0] rf_raddr1;
wire [ 4:0] rf_raddr2;
wire [31:0] rf_wdata;

wire        br_taken;
wire        rj_eq_rd;
wire [31:0] br_offs;
wire [31:0] br_target;
wire [31:0] imm;
wire [31:0] alu_src1;
wire [31:0] alu_src2;
wire [31:0] alu_result;


always @(posedge clk) begin
    if (reset) begin
        pc <= 32'h1bfffffc;     //trick: to make nextpc be 0x1c000000 during reset 
    end
    else begin
        pc <= nextpc;
    end
end

assign inst_sram_we    = 1'b0;
assign inst_sram_addr  = pc;
assign inst_sram_wdata = 32'b0;
assign inst            = inst_sram_rdata;

assign op_31_26 = inst[31:26];
assign op_25_22 = inst[25:22];
assign op_21_20 = inst[21:20];
assign op_19_15 = inst[19:15];
assign rd       = inst[ 4: 0];
assign rj       = inst[ 9: 5];
assign rk       = inst[14:10];
assign i12      = inst[21:10];
assign i16      = inst[25:10];

decoder_6_64 u_dec0(.in(op_31_26 ), .co(op_31_26_d ));
decoder_4_16 u_dec1(.in(op_25_22 ), .co(op_25_22_d ));
decoder_2_4  u_dec2(.in(op_21_20 ), .co(op_21_20_d ));
decoder_5_32 u_dec3(.in(op_19_15 ), .co(op_19_15_d ));

assign inst_add_w  = op_31_26_d[6'h00] & op_25_22_d[4'h0] & op_21_20_d[2'h1] & op_19_15_d[5'h00];//根据操作码
assign inst_addi_w = op_31_26_d[6'h00] & op_25_22_d[4'ha];
assign inst_ld_w   = op_31_26_d[6'h0a] & op_25_22_d[4'h2];
assign inst_st_w   = op_31_26_d[6'h0a] & op_25_22_d[4'h6];
assign inst_bne    = op_31_26_d[6'h17];

assign src2_is_imm   = inst_addi_w|inst_ld_w|inst_st_w;//操作数2是不是立即数
assign res_from_mem  = inst_ld_w;//结果来自主存
assign gr_we         = inst_add_w |inst_addi_w|inst_ld_w;//寄存器写使能信号，向寄存器中写入数据 
assign mem_we        = inst_st_w;//主存写使能
assign src_reg_is_rd = inst_bne | inst_st_w;//只有这两个的操作数来自rd,其他的要不是立即数，要不在rj
//类似于cache
assign rf_raddr1 = rj;
assign rf_raddr2 = src_reg_is_rd ? rd :rk;
regfile u_regfile(
    .clk    (clk      ),
    .raddr1 ( rf_raddr1),
    .rdata1 (rj_value),
    .raddr2 (rf_raddr2),
    .rdata2 (rkd_value),
    .we     (gr_we),
    .waddr  (rd),
    .wdata  (rf_wdata )
    );

assign br_offs   = {{16{i16[15]}},i16[15:0]};
// br_target = pc + br_offs;改动1
wire cout1;
fast_adder_32bit uut1_32bit(.a(pc),.b(br_offs),.cin(1'b0),.sub(1'b0),.result(br_target),.cout(cout1));
assign rj_eq_rd  = (rj_value == rkd_value);
assign br_taken  = valid && inst_bne  && !rj_eq_rd;//分支是不是被采取
assign nextpc    = br_taken ? br_target : pc + 4;
assign f1 = rj_eq_rd;
assign imm      = {{20{i12[11]}},i12[11:0]};
assign alu_src1 = rj_value;
assign alu_src2 = src2_is_imm?imm:rkd_value;

//assign alu_result = alu_src1+alu_src2;改动二
alu uut1_alu(.alu_control(3'd0),.alu_src1(alu_src1),.alu_src2(alu_src2),.alu_result(alu_result));
//store指令是要往主存中写入数据
assign data_sram_we    = mem_we;
assign data_sram_addr  = alu_result;
assign data_sram_wdata = rkd_value;

assign rf_wdata = res_from_mem ? data_sram_rdata : alu_result;

endmodule
                         
