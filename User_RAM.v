module User_RAM(
    input clk,
    input rst, 
    input [31:0] pc_address,  
    input [31:0] data_address,
    input [31:0] write_data,
    input RAM_Read,
    input RAM_Write,
    output reg [31:0] instruction_out,
    output reg [31:0] data_out
);
    
    reg [31:0] ram [0:1023];

    always @(*) begin
        instruction_out = ram[pc_address[11:2]];
    end

    always @(*) begin
        if (RAM_Read == 1'b1) begin
            data_out = ram[data_address[11:2]];
        end else begin
            data_out = 32'd0;
        end
    end

    always @(posedge clk) begin
        if (RAM_Write == 1'b1) begin
            ram[data_address[11:2]] <= write_data;
        end
    end

endmodule