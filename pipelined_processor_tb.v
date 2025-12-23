// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_cpu;
    reg clk;

    pipeline_cpu CPU1(clk);

    // Clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_cpu);

        clk = 0;

        // Initialize instruction memory
        // Format: OPCODE RD RS1 RS2

        // ADD R0 = R1 + R2
        CPU1.imem[0] = 8'b00_00_01_10;

        // SUB R1 = R2 - R3
        CPU1.imem[1] = 8'b01_01_10_11;

        // LOAD R2 = MEM[3]
        CPU1.imem[2] = 8'b10_10_00_11;

        // Initialize registers
        CPU1.regfile[1] = 8'd5;   // R1 = 5
        CPU1.regfile[2] = 8'd3;   // R2 = 3
        CPU1.regfile[3] = 8'd2;   // R3 = 2

        // Initialize memory
        CPU1.dmem[3] = 8'd99;

        #200;
        $finish;
    end
endmodule
