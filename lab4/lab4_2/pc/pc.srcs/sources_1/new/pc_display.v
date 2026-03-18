`timescale 1ns / 1ps

module pc_display(
    input clk,
    input resetn,    //后缀"n"代表低电平有效
    input input_sel,
    //拨码开关，用于产生写使能和选择输入数
    input clkk,
    input reset_rom_addr,
    input regwr,
    input reg_from_out,
    input alustr,



    //触摸屏相关接口，不需要更改
    output lcd_rst,
    output lcd_cs,
    output lcd_rs,
    output lcd_wr,
    output lcd_rd,
    inout[15:0] lcd_data_io,
    output lcd_bl_ctr,
    inout ct_int,
    inout ct_sda,
    output ct_scl,
    output ct_rstn
);


//-----{调用pc堆模块}begin
       
       wire [31:0]pc;
       wire [31:0]inst;
       wire [31:0]offset;
       reg [4:0]write_addr;
       reg [31:0]write_data;
       wire  [4:0] test_addr; 
       wire [31:0] test_data;
       wire [31:0]add_res;
       wire [4:0]rdd;
       wire [4:0]rjj;
       pc uut_pc(
       .clkk(clkk),
       .clk(clk),
       .reset_rom_addr(reset_rom_addr),
       .regwr(regwr),
       .reg_from_out(reg_from_out),
       .alustr(alustr),
       .write_data(write_data),
       .pc(pc),
       .inst(inst),
       .write_addr(write_addr),
       .test_data(test_data),
       .test_addr(test_addr),
       .add_res(add_res),
       .rdd(rdd),
       .rjj(rjj),
       .offset(offset));
    
   
//-----{调用pc堆模块}end

//---------------------{调用触摸屏模块}begin--------------------//
//-----{实例化触摸屏}begin
//此小节不需要更改
    reg         display_valid;
    reg  [39:0] display_name;
    reg  [31:0] display_value;
    wire [5 :0] display_number;
    wire        input_valid;
    wire [31:0] input_value;

    lcd_module lcd_module(
        .clk            (clk           ),   //10Mhz
        .resetn         (resetn        ),

        //调用触摸屏的接口
        .display_valid  (display_valid ),
        .display_name   (display_name  ),
        .display_value  (display_value ),
        .display_number (display_number),
        .input_valid    (input_valid   ),
        .input_value    (input_value   ),

        //lcd触摸屏相关接口，不需要更改
        .lcd_rst        (lcd_rst       ),
        .lcd_cs         (lcd_cs        ),
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
    //32个寄存器显示在7~38号的显示块，故读地址为（display_number-1）
    assign test_addr = display_number-5'd7; 
    //当input_sel为2'b00时，表示输入数为读地址1，即raddr1
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            write_addr <= 5'd0;
        end
        else if (input_valid && !input_sel)
        begin
            write_addr <= input_value[4:0];
        end
    end
    
    //当input_sel为2'b01时，表示输入数为读地址2，即raddr2
    always @(posedge clk)
    begin
        if (!resetn)
        begin
            write_data <= 32'd0;
        end
        else if (input_valid && input_sel)
        begin
            write_data <= input_value;
        end
    end
    
//-----{从触摸屏获取输入}end

//-----{输出到触摸屏显示}begin
//根据需要显示的数修改此小节，
//触摸屏上共有44块显示区域，可显示44组32位数据
//44块显示区域从1开始编号，编号为1~44，
    always @(posedge clk)
    begin
        if (display_number >6'd6 && display_number <6'd39 )
        begin //块号7~38显示32个通用寄存器的值
            display_valid <= 1'b1;
            display_name[39:16] <= "REG";
            display_name[15: 8] <= {4'b0011,3'b000,test_addr[4]};
            display_name[7 : 0] <= {4'b0011,test_addr[3:0]}; 
            display_value       <= test_data;
          end
        else
        begin
            case(display_number)
                6'd1 : //显示读端口1的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "INSTT";
                    display_value <= inst;
                end
                6'd2 : //显示读端口1读出的数据
                begin
                    display_valid <= 1'b1;
                    display_name  <= "PPCCC";
                    display_value <= pc;
                end
                6'd3 : //显示读端口2的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "OFFSE";
                    display_value <= offset;
                end
                6'd4 : //显示读端口2读出的数据
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WADDR";
                    display_value <= write_addr;
                end
                6'd5 : //显示写端口的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "WDATA";
                    display_value <= write_data;
                end
                6'd6 : //显示写端口的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "ADRES";
                    display_value <= add_res;
                end
                6'd41 : //显示写端口的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RDDDD";
                    display_value <= rdd;
                end
                6'd42 : //显示写端口的地址
                begin
                    display_valid <= 1'b1;
                    display_name  <= "RRJJJ";
                    display_value <= rjj;
                end
                default :
                begin
                    display_valid <= 1'b0;
                    display_name  <= 40'd0;
                    display_value <= 32'd0;
                end
            endcase
        end
    end
//-----{输出到触摸屏显示}end
//----------------------{调用触摸屏模块}end---------------------//
endmodule

