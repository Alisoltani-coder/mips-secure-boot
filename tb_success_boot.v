`timescale 1ns / 1ps

module tb_success_boot();

    reg clk;
    reg rst_button;

    Top_System uut (
        .clk(clk),
        .rst_button(rst_button)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst_button = 1;

        $readmemh("user_program1.hex", uut.ram_inst.ram);

        #20 rst_button = 0;

        $monitor("Time = %0t | PC = %h | Mode_Bit = %b | Watchdog_Rst = %b", 
                 $time, uut.core.pc, uut.core.Mode_Bit, uut.Watchdog_rst);

        #2000;

        $display("---------------------------------------------------");
        $display("--- Test Completed: Successful Boot Scenario ---");
        $display("---------------------------------------------------");
        
        $stop;
    end

endmodule