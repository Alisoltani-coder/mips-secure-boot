module ALU
(
    input [31:0] a,
    input [31:0] b,
    input [2:0] op,
    output reg [31:0] result,
    output reg zero
);
    always @(*) begin
        case (op)
            3'b000: result = a + b;
            3'b001: result = a | b;
            3'b010: result = a & b;
            3'b100: result = a ^ b; //XOR
            3'b110: result = a - b;
            default: result = 32'd0;
        endcase
        zero = (result == 32'd0) ? 1'b1 : 1'b0;
    end
endmodule