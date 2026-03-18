`default_nettype none
`define SIMU_USE_PLL 0 
module soc_mini_top #(parameter SIMULATION=1'b0)
(
    input  wire        resetn, 
    input  wire        clk,

    output wire [15:0] led,
    input  wire [7 :0] switch
);

//时钟信号和复位
wire cpu_clk;
reg cpu_resetn;
always @(posedge cpu_clk)
begin
    cpu_resetn <= resetn;
end
generate if(SIMULATION && `SIMU_USE_PLL==0)
begin: speedup_simulation
    assign cpu_clk   = clk;
end
else
begin: pll
    clk_pll clk_pll
    (
        .clk_in1 (clk),
        .cpu_clk (cpu_clk),
        .timer_clk ()
    );
end
endgenerate

//指令寄存器相关
wire        cpu_inst_we;
wire [31:0] cpu_inst_addr;
wire [31:0] cpu_inst_rdata;
wire [31:0] cpu_inst_wdata;
//cpu需要的数据寄存器相关
wire        cpu_data_we;
wire [31:0] cpu_data_addr;
wire [31:0] cpu_data_wdata;
wire [31:0] cpu_data_rdata;

//数据寄存器
wire        data_sram_en;
wire        data_sram_we;
wire [31:0] data_sram_addr;
wire [31:0] data_sram_wdata;
wire [31:0] data_sram_rdata;

//显示
wire        conf_en;
wire        conf_we;
wire [31:0] conf_addr;
wire [31:0] conf_wdata;
wire [31:0] conf_rdata;
wire [15:0] conf_led;

//实例化cpu
minicpu_top cpu(
    .clk              (cpu_clk       ),
    .resetn           (cpu_resetn    ),  //低有效
//指令寄存器相关的
    .inst_sram_we     (cpu_inst_we   ),
    .inst_sram_addr   (cpu_inst_addr ),
    .inst_sram_wdata  (cpu_inst_wdata),
    .inst_sram_rdata  (cpu_inst_rdata),
 //与cpu相关的  
    .data_sram_we     (cpu_data_we   ),
    .data_sram_addr   (cpu_data_addr ),
    .data_sram_wdata  (cpu_data_wdata),
    .data_sram_rdata  (cpu_data_rdata)
);

assign cpu_data_rdata = (cpu_data_addr == 12'd1024)? {24'b0, switch[7:0]} :
                                                      32'b0;

//inst ram
inst_ram inst_ram
(
    .clk   (cpu_clk            ),   
    .we    (cpu_inst_we        ),   
    .a     (cpu_inst_addr[17:2]),   
    .d     (cpu_inst_wdata     ),   
    .spo   (cpu_inst_rdata     )   
);

//confreg
confreg u_confreg
(
    .clk          ( cpu_clk    ),  // i, 1   
    .resetn       ( cpu_resetn ),  // i, 1    
    .conf_we      ( conf_we    ),  // i, 4      
    .conf_wdata   ( conf_wdata ),  // i, 32         
    .led          ( conf_led   )   // o, 16   
);

assign conf_we    = cpu_data_we && cpu_data_addr == 12'd1028;
assign conf_wdata = cpu_data_wdata;

assign led = ~conf_led; 

endmodule

