module Memory_Router
(
    input [31:0] address,
    input MemRead,
    input MemWrite,
    input Mode_Bit,
    output reg RAM_Write,
    output reg RAM_Read,
    output reg ROM_Read,
    output reg Crypto_Read,
    output reg Crypto_Write
);

    always @(*) begin
        RAM_Write = 1'b0;
        RAM_Read = 1'b0;
        ROM_Read = 1'b0;
        Crypto_Read = 1'b0;
        Crypto_Write = 1'b0;

        if (address >= 32'h0000 && address <= 32'h0FFF) begin
            if (Mode_Bit == 1'b1) begin
                ROM_Read = MemRead;
            end
        end
        else if (address >= 32'h1000 && address <= 32'h1FFF) begin
            RAM_Read = MemRead;
            RAM_Write = MemWrite;
        end
        else if (address >= 32'h2000 && address <= 32'h20FF) begin
            if (Mode_Bit == 1'b1) begin
                Crypto_Read = MemRead;
                Crypto_Write = MemWrite;
            end
        end
    end
endmodule