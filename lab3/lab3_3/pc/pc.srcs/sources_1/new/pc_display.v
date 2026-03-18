`timescale 1ns / 1ps

module pc_display(
  //时钟与复位信号 
    input clk, 
    input resetn,
    input reset_rom,
    input resetpc,
    input clkk,
  
//触摸屏相关接口，不需要更改 
output lcd_rst, 
output lcd_cs, 
output lcd_rs, 
output lcd_wr, 
output lcd_rd, 
inout[15:0] lcd_data_io, 
output lcd_bl_ctr, 
inout  ct_int, 
inout  ct_sda, 
output ct_scl, 
output ct_rstn
);


//加法和减法的模块
//-----{调用加法模块}begin 
wire [31:0]rom_data;
wire [31:0]pcout;
wire [31:0]offs;
wire [31:0]rom_raddr;
pc uut_pc(
.clkk(clkk),
.rom_data(rom_data),
.resetpc(resetpc),
.pcout(pcout),
.reset_rom(reset_rom),
.rom_raddr(rom_raddr),
.offs(offs));


 //-----{调用加法模块}end 
 //---------------------{调用触摸屏模块}begin--------------------// 
 //-----{实例化触摸屏}begin 
//此小节不需要更改 
reg   display_valid; 
reg  [39:0] display_name; 
reg  [31:0] display_value; 
wire [5 :0] display_number; 
wire    input_valid; 
wire [31:0] input_value; 
lcd_module  lcd_module( 
.clk(clk                    ),   //10Mhz 
.resetn (resetn ), 

//调用触摸屏的接口 
.display_valid  (display_valid ), 
.display_name   (display_name  ), 
.display_value  (display_value ), 
.display_number (display_number), 
.input_valid    (input_valid   ), 
.input_value    (input_value   ), 
//lcd触摸屏相关接口，不需要更改 
.lcd_rst(lcd_rst ), 
.lcd_cs (lcd_cs ),
.lcd_rs         (lcd_rs        ), 
.lcd_wr         (lcd_wr        ), 
.lcd_rd         (lcd_rd        ), 
.lcd_data_io    (lcd_data_io   ), 
 .lcd_bl_ctr     (lcd_bl_ctr    ), 
 .ct_int         (ct_int        ), 
 .ct_sda         (ct_sda        ), 
 .ct_scl         (ct_scl        ), 
 .ct_rstn        (ct_rstn       ) 
);  
 //-----{实例化触摸屏}end 
//-----{从触摸屏获取输入}begin 




//根据实际需要输入的数修改此小节， 
//建议对每一个数的输入，编写单独一个always块 
//当input_sel为0时，表示输入数为加数1，即operand1 
//具体的引脚设置
//always @(posedge clk) 
//begin 
//if (!resetn) 
// begin 
//  rom_addr <= 32'd0; 
// end 
//else if (input_valid && in == 2'b0) 
// begin 
//   rom_addr <= input_value; 
// end 
//end 

 //-----{从触摸屏获取输入}end 
//-----{输出到触摸屏显示}begin 
//根据需要显示的数修改此小节，
//触摸屏上共有44块显示区域，可显示44组32位数据 



//44块显示区域从1开始编号，编号为1~44， 
always @(posedge clk) 
begin 
case(display_number) 
 6'd1 : 
 begin 
display_valid <= 1'b1; 
 display_name  <= "ADDR"; 
 display_value <= rom_raddr; 
end 
 6'd2 : 
 begin 
 display_valid <= 1'b1; 
 display_name  <= "RDATA"; 
 display_value <= rom_data; 
 end 
6'd3 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "PPCCC"; 
 display_value <= pcout; 
end 
6'd4 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "OFFSE"; 
 display_value <= offs; 
end 
default : 
  begin 
display_valid <= 1'b0; 
display_name  <= 40'd0; 
display_value <= 32'd0; 
end 
 endcase 
end 
//-----{输出到触摸屏显示}end 
//----------------------{调用触摸屏模块}end---------------------// 
endmodule


