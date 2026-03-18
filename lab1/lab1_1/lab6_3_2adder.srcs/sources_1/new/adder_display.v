module adder_display(
 //时钟与复位信号 
input clk, 
input resetn,    //后缀"n"代表低电平有效 
  //拨码开关，用于选择输入数和产生cin 
  //用于决定输入哪个数字
input input_sel,//0:输入为加数1(add_operand1);1:为加数2(add_operand2) 
input input_sel2,//0:输入为加数1(add1);1:为加数2(add2) 
input input_sel3,


//进位
input sw_cin, //加法进位
input sw_cin1,//减法进位

 //led灯，用于显示cout 
output led_cout, //加法进位
output led_cout1,//减法进位


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
reg  [31:0] adder_operand1; 
reg  [31:0] adder_operand2; 
reg [31:0] adder1;
reg [31:0]adder2;
wire  adder_cin; 
wire adder_cin1;
wire [31:0] adder_result; 
wire [31:0] adder_result1;
wire   adder_cout; 
wire adder_cout1;
adder adder_module( 
.operand1(adder_operand1), 
.operand2(adder_operand2), 
.cin     (adder_cin     ), 
.result  (adder_result  ), 
.cout    (adder_cout    ) 
);
sub sub_module(
.add1(adder1),
.add2(adder2),
.cin1(adder_cin1),
.result1 (adder_result1),
.cout1(adder_cout1)
); 
assign adder_cin = sw_cin; 
assign adder_cin1 = sw_cin1;
assign led_cout  = ~adder_cout; 
assign led_cout1 = ~adder_cout1;


reg [15:0]mul31;
reg [15:0]mul32;
wire [31:0]result3;
wire count3;
multi multi_module(mul31,mul32,result3,count3);

reg [31:0]div1;
reg [15:0]div2;
wire [31:0]result4;
wire cout4;
div div_module(div1,div2,result4,cout4);




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
lcd_module lcd_module( 
.clk  (clk    ),   //10Mhz 
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
always @(posedge clk) 
begin 
if (!resetn) 
 begin 
  adder_operand1 <= 32'd0; 
 end 
else if (input_valid && input_sel == 0 && input_sel2 == 0 && input_sel3 == 0) 
 begin 
  adder_operand1 <= input_value; 
 end 
end 
 //当input_sel为1时，表示输入数为加数2，即operand2 
always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
adder_operand2 <= 32'd0; 
end 
 else if (input_valid && input_sel == 0 && input_sel2 == 0 && input_sel3 == 1) 
begin 
  adder_operand2 <= input_value; 
 end 
end 

always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
adder1 <= 32'd0; 
end 
 else if (input_valid && input_sel == 0 && input_sel2 == 1 && input_sel3 == 0) 
begin 
  adder1 <= input_value; 
 end 
end 


always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
adder2 <= 32'd0; 
end 
 else if (input_valid && input_sel == 0 && input_sel2 == 1 && input_sel3 == 1) 
begin 
  adder2 <= input_value; 
 end 
end 

always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
mul31 <= 32'd0; 
end 
 else if (input_valid && input_sel == 1 && input_sel2 == 0 && input_sel3 == 0) 
begin 
 mul31 <= input_value; 
 end 
end 

always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
mul32 <= 32'd0; 
end 
 else if (input_valid && input_sel == 1 && input_sel2 == 0 && input_sel3 == 1) 
begin 
mul32 <= input_value; 
 end 
end 

always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
div1 <= 32'd0; 
end 
 else if (input_valid && input_sel == 1 && input_sel2 == 1 && input_sel3 == 0) 
begin 
 div1 <= input_value; 
 end 
end 

always @(posedge clk) 
begin 
 if (!resetn) 
 begin 
div2 <= 32'd0; 
end 
 else if (input_valid && input_sel == 1 && input_sel2 == 1 && input_sel3 == 1) 
begin 
  div2 <= input_value; 
 end 
end 



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
 display_name  <= "ADD_1"; 
 display_value <= adder_operand1; 
end 
 6'd2 : 
 begin 
display_valid <= 1'b1; 
 display_name  <= "ADD_2"; 
 display_value <= adder_operand2; 
 end 
6'd3 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "RESUL"; 
 display_value <= adder_result; 
end 
6'd5 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "SUB_1"; 
 display_value <= adder1; 
end 
6'd6 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "SUB_2"; 
 display_value <= adder2; 
end 
6'd7 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "RESUL"; 
 display_value <= adder_result1; 
end 

6'd9 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "MUL_1"; 
 display_value <= mul31; 
end

6'd10 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "MUL_2"; 
 display_value <= mul32; 
end

6'd11 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "RESUL"; 
 display_value <= result3; 
 end
 
 6'd13 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "DIV_1"; 
 display_value <= div1; 
 end
 6'd14 : 
begin 
 display_valid <= 1'b1; 
 display_name  <= "DIV_2"; 
 display_value <= div2; 
 end
 6'd15: 
begin 
 display_valid <= 1'b1; 
 display_name  <= "RESUL"; 
 display_value <= result4; 
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


