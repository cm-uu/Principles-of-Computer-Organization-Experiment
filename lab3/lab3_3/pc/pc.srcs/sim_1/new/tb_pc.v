module tb_pc;
    reg clkk;
    reg resetpc;
    reg reset_rom;
    wire [31:0] rom_data;
    wire [31:0] pcout;
    wire [31:0] offs;
    wire [31:0]rom_raddr;
    pc uut (.clkk(clkk),.rom_data(rom_data),.resetpc(resetpc),.reset_rom(reset_rom),.pcout(pcout),
        .rom_raddr(rom_raddr),.offs(offs));
    initial begin
        clkk = 0;forever #5 clkk = ~clkk; // 100MHz  ±÷”
    end
    initial begin
        resetpc = 1;
        reset_rom = 1;
        #10;
        resetpc = 0;
        reset_rom = 0;
    end
endmodule
