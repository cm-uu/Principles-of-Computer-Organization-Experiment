`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 16:45:47
// Design Name: 
// Module Name: tb_2_1_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_2_1_1;
  reg clk;
	    reg  wen;
	    reg  [4 :0] raddr1;
	    reg  [4 :0] raddr2;
	    reg  [4 :0] waddr;
	    reg  [31:0] wdata;
	    wire  [31:0] rdata1;
	    wire  [31:0] rdata2;
	    wire  [31:0] test_data;  
	    reg  [4 :0] test_addr;
        regfile rf_module(
	        .clk   (clk   ),
	        .wen   (     ),  //补全代码
	        .raddr1(raddr1),
	        .raddr2(raddr2),
	        .waddr (    ),  //补全代码
            .wdata (    ),  //补全代码
            .rdata1(rdata1),
	        .rdata2(rdata2),
            .test_addr(      ), //补全代码
	        .test_data(      )  //补全代码
	    );
  initial 
    begin
        clk = 1'b1;
    end
   always #5 clk = ~clk;
                        
  initial 
    begin
        raddr1 =  5'd0;
        raddr2 =  5'd0;
        waddr  =  5'd0;
        wdata  = 32'd0;
        wen    =  1'b0;	
        test_addr=   raddr1;
        
        #20;      
        wen  =  1'b1;
        waddr = 5'd1;
        wdata = 32'HFFFF1111;
        raddr1 =  5'd1;
        raddr2 =  5'd1;
       
        #20;
        waddr = 5'd2;
        wdata = 32'HFFFF2222;
        wen  = 1'b0;
        raddr1 =  5'd0;
        raddr2 =  5'd2;
       
        #20;
        wen  = 1'b1;
        waddr = 5'd3;
        wdata = 32'HFFFF3333;
        raddr1 =  5'd3;
        raddr2 =  5'd3;   
        #20;  
        waddr = 5'd4;
        wdata = 32'HFFFF4444;
        raddr1 =  5'd4;
        raddr2 =  5'd4;
        #20;  
        waddr = 5'd5;
        wdata = 32'HFFFF5555;
        raddr1 =  5'd5;
        raddr2 =  5'd5;
		wen  = 1'b0;
        
        #10;
        raddr1 =  5'd1;
        raddr2 =  5'd2;
         #10;
        raddr1 =  5'd3;
        raddr2 =  5'd4;
         #10;
        raddr1 =  5'd5;
        raddr2 =  5'd0;
        test_addr=   raddr2;

    end
endmodule

