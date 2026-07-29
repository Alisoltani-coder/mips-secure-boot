module Controller
(
    input [5:0] opcode,
    input [5:0] funct,
    input clk,
    input rst,
    output reg MemWrite,
    output reg MemRead,
    output reg RegWrite,
    output reg MemtoReg,
    output reg ALUSrc,
    output reg RegDst,
    output reg Branch,
    output reg Bne,
    output reg Mode_Bit,
    output reg [2:0] ALUControl
);

    always @(*) begin
        MemWrite = 1'b0;
        MemRead = 1'b0;
        RegWrite = 1'b0;
        MemtoReg = 1'b0;
        ALUSrc = 1'b0;
        RegDst = 1'b0;
        Branch = 1'b0;
        Bne = 1'b0;
        ALUControl = 3'b000;

        case (opcode)
            6'b000000: begin // R-type
            if (funct != 6'b001100) begin 
                RegWrite = 1'b1;
            end
                RegDst = 1'b1;
                case (funct)
                    6'b100000: ALUControl = 3'b000; // add
                    6'b100010: ALUControl = 3'b110; // sub
                    6'b100100: ALUControl = 3'b010; // and
                    6'b100101: ALUControl = 3'b001; // or
                    6'b100110: ALUControl = 3'b100; // xor
                    default: ALUControl = 3'b000;
                endcase
            end
            6'b100011: begin // lw
                MemRead = 1'b1;
                RegWrite = 1'b1;
                MemtoReg = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = 3'b000; // add
            end
            6'b101011: begin // sw
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = 3'b000; // add
            end
            6'b000100: begin // beq
                Branch = 1'b1;
                ALUControl = 3'b110; // sub
            end
            6'b001000: begin // addi
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = 3'b000; // add
            end
            6'b001101: begin // ori
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = 3'b001; // or
            end
            6'b001110: begin // xori
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
                ALUControl = 3'b100; // xor
            end
            6'b000101: begin // bne
                Bne = 1'b1;
                ALUControl = 3'b110; // sub
            end
            6'b000010: begin // j
                // jump control is handled outside the controller
            end
            default: begin
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            Mode_Bit <= 1'b1;
        end else begin
            if(Mode_Bit == 1'b1 && opcode == 6'b000000 && funct == 6'b001100) begin
                Mode_Bit <= 1'b0;
            end
        end
    end
endmodule