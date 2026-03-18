module regfile(
    input  wire        clk,
    input  wire [ 4:0] raddr1,
    output wire [31:0] rdata1,
    input  wire [ 4:0] raddr2,
    output wire [31:0] rdata2,
    input  wire        we,     
    input  wire [ 4:0] waddr,
    input  wire [31:0] wdata
);
reg [31:0] rf[31:0];
integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        rf[i] = 32'b0;
    end
end
always @(posedge clk) begin
    if (we) begin
        rf[waddr] <= wdata;
    end
end
assign rdata1 = rf[raddr1];
assign rdata2 = rf[raddr2];
endmodule
