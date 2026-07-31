module Boot_ROM(
    input [31:0] pc_address,     // پورت اختصاصی برای واکشی دستور
    input [31:0] data_address,   // پورت اختصاصی برای خواندن داده
    input ROM_Read,
    output reg [31:0] instruction_out,
    output reg [31:0] data_out
);
    
    reg [31:0] rom [0:1023]; // فضای 4 کیلوبایتی

    initial begin
        $readmemh("boot_rom.hex", rom);
    end

    // پورت ۱: خواندن دستورات به صورت پیوسته بر اساس PC
    always @(*) begin
        instruction_out = rom[pc_address[11:2]];
    end

    // پورت ۲: خواندن داده‌ها تحت کنترل سیگنال ROM_Read
    always @(*) begin
        if (ROM_Read == 1'b1) begin
            data_out = rom[data_address[11:2]];
        end else begin
            data_out = 32'd0;
        end
    end

endmodule