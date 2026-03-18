module div( 
input [31:0]div1,
input [15:0]div2,
output [31:0]result1,
output cout1
   ); 
assign {cout1,result1} = div1 / div2; 
endmodule 