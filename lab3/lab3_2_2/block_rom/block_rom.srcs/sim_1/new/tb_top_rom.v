module tb_top_rom;
    reg clk;
    reg [15:0] rom_addr; 
    wire [31:0] rom_rdata; 
    top_rom u_top_sync_rom (.clk(clk),.rom_addr(rom_addr), .rom_rdata(rom_rdata));
    initial begin
        rom_addr = 16'd0;#10;
        rom_addr = 16'd1;#5;
        rom_addr = 16'd2;#5;
        rom_addr = 16'd3;#10;
        rom_addr = 16'd4;#3;
        rom_addr = 16'd5;#2;
        rom_addr = 16'd6;#10;
       end
    initial begin clk = 1;end
    always #5 clk = ~clk;
endmodule
