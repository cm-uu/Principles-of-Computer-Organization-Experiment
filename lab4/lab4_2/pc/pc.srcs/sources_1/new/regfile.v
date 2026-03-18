module regfile(
    input  wire        clk,
    input  wire [ 4:0] raddr1,
    output wire [31:0] rdata1,
    input  wire [ 4:0] raddr2,
    output wire [31:0] rdata2,
    input  wire        we,       //write enable, HIGH valid
    input  wire [ 4:0] waddr,
    input  wire [31:0] wdata,
    input  [ 4:0] test_addr, 
    output [31:0] test_data
    );
reg [31:0] rf[31:0];

//Ìí¼Ó´úÂë
always@(posedge clk)begin
    if(we)begin
        rf[waddr] = wdata;
        end
 end
assign rdata1 = rf[raddr1];
assign rdata2 = rf[raddr2];
assign test_data = rf[test_addr];
endmodule

