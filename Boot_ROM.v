module Boot_ROM(
    input [31:0] pc_address,
    input [31:0] data_address, 
    input ROM_Read,
    output reg [31:0] instruction_out,
    output reg [31:0] data_out
);
    
    reg [31:0] rom [0:1023];

    initial begin
        $readmemh("boot_rom.hex", rom);
    end

    always @(*) begin
        instruction_out = rom[pc_address[11:2]];
    end

    always @(*) begin
        if (ROM_Read == 1'b1) begin
            data_out = rom[data_address[11:2]];
        end else begin
            data_out = 32'd0;
        end
    end

endmodule