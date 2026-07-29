module User_RAM(
    input clk,
    input rst,
    input [31:0] address,
    input [31:0] write_data,
    input RAM_Read,
    input RAM_Write,
    output reg [31:0] read_data
);
    
    reg [31:0] ram [0:1023];

    always @(*) begin
        if (RAM_Read == 1'b1) begin
            read_data = ram[address[11:2]];
        end else begin
            read_data = 32'd0;
        end
    end

    integer i;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            
            for (i = 0; i < 1024; i = i + 1) begin
                ram[i] <= 32'd0;
            end
        end else if (RAM_Write == 1'b1) begin
            ram[address[11:2]] <= write_data;
        end
    end

endmodule