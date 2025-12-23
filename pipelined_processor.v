// Code your design here
module pipeline_cpu(input clk);

    // -------- Instruction Memory (16 instructions max) ----------
    reg [7:0] imem[0:15];

    // -------- Data Memory ----------
    reg [7:0] dmem[0:15];

    // -------- Register File (4 registers) ----------
    reg [7:0] regfile[0:3];

    // -------- Pipeline Registers ----------
    reg [7:0] IF_ID_instr;

    reg [1:0] ID_EX_opcode, ID_EX_rd, ID_EX_rs1, ID_EX_rs2;
    reg [7:0] ID_EX_val1, ID_EX_val2;

    reg [1:0] EX_WB_rd;
    reg [7:0] EX_WB_result;

    // -------- FETCH Stage ----------
    reg [3:0] PC = 0;

    always @(posedge clk) begin
        IF_ID_instr <= imem[PC];
        PC <= PC + 1;
    end

    // -------- DECODE Stage ----------
    always @(posedge clk) begin
        ID_EX_opcode <= IF_ID_instr[7:6];
        ID_EX_rd     <= IF_ID_instr[5:4];
        ID_EX_rs1    <= IF_ID_instr[3:2];
        ID_EX_rs2    <= IF_ID_instr[1:0];

        ID_EX_val1   <= regfile[IF_ID_instr[3:2]];
        ID_EX_val2   <= regfile[IF_ID_instr[1:0]];
    end

    // -------- EXECUTE Stage ----------
    always @(posedge clk) begin
        EX_WB_rd <= ID_EX_rd;

        case(ID_EX_opcode)
            2'b00: EX_WB_result <= ID_EX_val1 + ID_EX_val2;       // ADD
            2'b01: EX_WB_result <= ID_EX_val1 - ID_EX_val2;       // SUB
            2'b10: EX_WB_result <= dmem[ID_EX_rs2];               // LOAD
            default: EX_WB_result <= 0;
        endcase
    end

    // -------- WRITE BACK Stage ----------
    always @(posedge clk) begin
        regfile[EX_WB_rd] <= EX_WB_result;
    end

endmodule
