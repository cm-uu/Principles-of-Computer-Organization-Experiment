module multi( 
input [15:0]mul1,
input [15:0]mul2,
output [31:0]result1,
output cout1
   ); 
assign {cout1,result1} = mul1 * mul2; 
endmodule 