module Boot_ROM(
    input [31:0] address,
    input ROM_Read,
    output reg [31:0] read_data
);
    
    reg [31:0] rom [0:1023];

    initial begin
        $readmemh("boot_rom.hex", rom);
    end

    always @(*) begin
        if (ROM_Read == 1'b1) begin
            read_data = rom[address[11:2]];
        end else begin
            read_data = 32'd0;
        end
    end
endmodule