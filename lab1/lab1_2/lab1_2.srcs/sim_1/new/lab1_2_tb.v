module lab1_2_tb;
// Inputs
reg [31:0]A;
reg [31:0]B;
reg op;
// Outputs
wire [31:0] result;
wire cout;
// Instantiate the Unit Under Test (UUT)
buma uut (
.A(A),
.B(B),
.op(op),
.result(result),
.cout(cout)
);
initial begin
// Initialize Inputs
A = 0;
B = 0;
op = 0;
// Wait 100 ns for global reset to finish
#100
A = 10;
B = 5;
op = 1;
#100
A = 10;
B = 5;
op = 0;
end
endmodule