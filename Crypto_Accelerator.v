module Crypto_Accelerator
(
    input clk,
    input rst,
    input [31:0] address,
    input [31:0] write_data,
    input Crypto_Read,
    input Crypto_Write,
    output reg [31:0] read_data
);

    reg [31:0] accumulator;

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            accumulator <= 32'd0;
        end else if (Crypto_Write == 1'b1) begin
            if (address == 32'h2000) begin
                accumulator <= accumulator ^ write_data;
            end else if (address == 32'h2004) begin
                if (write_data == 32'd1) begin
                    accumulator <= 32'd0;
                end
            end
        end
    end

    always @(*) begin
        if (Crypto_Read == 1'b1 && address == 32'h2000) begin
            read_data = accumulator;
        end else begin
            read_data = 32'd0;
        end
    end

endmodule