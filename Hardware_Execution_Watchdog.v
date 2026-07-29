module Hardware_Execution_Watchdog
(
    input Mode_Bit,
    input [31:0] pc,
    output reg Watchdog_rst
);
    always @(*) begin
        if(Mode_Bit == 1'b1 && pc >= 32'h1000 && pc <= 32'h1FFF) begin
            Watchdog_rst = 1'b1;
        end else begin
            Watchdog_rst = 1'b0;
        end
    end
endmodule