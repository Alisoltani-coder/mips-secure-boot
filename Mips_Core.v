module Mips_Core
(
    input clk,
    input rst,
    input [31:0] instruction,
    input [31:0] read_data,
    output reg [31:0] pc,
    output [31:0] alu_result,
    output [31:0] write_data,
    output MemWrite,
    output MemRead,
    output RegWrite,
    output MemtoReg,
    output ALUSrc,
    output RegDst,
    output Branch,
    output Bne,
    output Mode_Bit,
    output [2:0] ALUControl
);
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire zero;
    wire [31:0] Branch_address;
    wire PCSrc;

    Controller controller (
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .clk(clk),
        .rst(rst),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .RegWrite(RegWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .RegDst(RegDst),
        .Branch(Branch),
        .Bne(Bne),
        .Mode_Bit(Mode_Bit),
        .ALUControl(ALUControl)
    );
    RegisterFile register_file (
        .clk(clk),
        .rst(rst),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .write_reg(RegDst ? instruction[15:11] : instruction[20:16]),
        .write_data(MemtoReg ? read_data : alu_result),
        .reg_write(RegWrite),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
    ALU alu (
        .a(read_data1),
        .b(ALUSrc ? {{16{instruction[15]}}, instruction[15:0]} : read_data2),
        .op(ALUControl),
        .result(alu_result),
        .zero(zero)
    );

    assign write_data = read_data2;
    assign Branch_address = pc + 4 + ({{14{instruction[15]}}, instruction[15:0], 2'b00});
    assign PCSrc = (Branch & zero) | (Bne & ~zero);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            pc <= 32'd0;
        end else begin
            pc <= PCSrc ? Branch_address : pc + 4;
        end
    end
endmodule