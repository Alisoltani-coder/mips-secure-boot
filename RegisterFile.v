module RegisterFile
(
    input clk,
    input rst,
    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,
    input [31:0] write_data,
    input reg_write,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);
    reg [31:0] registers [31:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_write) begin
            if(write_reg != 5'd0) begin
                registers[write_reg] <= write_data;
            end
        end
    end
    always @(*) begin
        read_data1 = registers[read_reg1];
        read_data2 = registers[read_reg2];
    end
endmodule