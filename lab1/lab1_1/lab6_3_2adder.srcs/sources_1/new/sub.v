module sub( 
input [31:0]add1,
input [31:0]add2,
input cin1,
output [31:0]result1,
output cout1
   ); 
assign {cout1,result1} = add1 - add2; 
endmodule 