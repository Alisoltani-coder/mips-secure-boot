module Top_System(
    input clk,
    input rst_button
);

    wire sys_rst;
    wire Watchdog_rst;
    
    wire [31:0] pc, alu_result, write_data, instruction, read_data;
    wire MemWrite, MemRead, RegWrite, MemtoReg, ALUSrc, RegDst, Branch, Bne, Mode_Bit;
    wire [2:0] ALUControl;
    
    wire RAM_Write, RAM_Read, ROM_Read, Crypto_Read, Crypto_Write;
    
    wire [31:0] rom_inst_out, rom_data_out;
    wire [31:0] ram_inst_out, ram_data_out;
    wire [31:0] crypto_data;

    assign sys_rst = rst_button | Watchdog_rst;

     assign instruction = (pc >= 32'h0000 && pc <= 32'h0FFF) ? rom_inst_out :
                     (pc >= 32'h1000 && pc <= 32'h1FFF) ? ram_inst_out : 32'd0;

    // مسیر خواندن داده: انتخاب داده خروجی بر اساس مجوزهای روتر
    assign read_data = (ROM_Read == 1'b1) ? rom_data_out :
                       (RAM_Read == 1'b1) ? ram_data_out :
                       (Crypto_Read == 1'b1) ? crypto_data : 32'd0;
    
    Mips_Core core (
        .clk(clk),
        .rst(sys_rst),
        .instruction(instruction),
        .read_data(read_data),
        .pc(pc),
        .alu_result(alu_result),
        .write_data(write_data),
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

    Memory_Router data_router (
        .address(alu_result),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Mode_Bit(Mode_Bit),
        .RAM_Write(RAM_Write),
        .RAM_Read(RAM_Read),
        .ROM_Read(ROM_Read),
        .Crypto_Read(Crypto_Read),
        .Crypto_Write(Crypto_Write)
    );

    Boot_ROM rom_inst (
        .pc_address(pc),
        .data_address(alu_result),
        .ROM_Read(ROM_Read), 
        .instruction_out(rom_inst_out),
        .data_out(rom_data_out)
    );

    User_RAM ram_inst (
        .clk(clk),
        .rst(sys_rst),
        .pc_address(pc),
        .data_address(alu_result),
        .write_data(write_data),
        .RAM_Read(RAM_Read),
        .RAM_Write(RAM_Write),
        .instruction_out(ram_inst_out),
        .data_out(ram_data_out)
    );

    Crypto_Accelerator crypto_inst (
        .clk(clk),
        .rst(sys_rst),
        .address(alu_result),
        .write_data(write_data),
        .Crypto_Read(Crypto_Read),
        .Crypto_Write(Crypto_Write),
        .read_data(crypto_data)
    );

    Hardware_Execution_Watchdog watchdog_inst (
        .Mode_Bit(Mode_Bit),
        .pc(pc),
        .Watchdog_rst(Watchdog_rst)
    );

endmodule