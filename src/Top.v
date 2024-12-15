module Top (
    input clk,
    input rst
);
    wire [31:0] instruction;  // current instruction
    wire [31:0] pc;           // program counter
    wire [31:0] next_pc;      // next program counter
    wire [6:0] opcode;        // opcode
    wire [2:0] func3;         // func3
    wire [6:0] func7;         // func7
    wire [31:0] alu_op1;      // operand1 for ALU
    wire [31:0] alu_op2;      // operand2 for ALU
    wire [31:0] alu_out;      // ALU output
    wire [4:0] rd_index;      // destination register index
    wire [4:0] rs1_index;     // source register 1 index
    wire [4:0] rs2_index;     // source register 2 index
    wire [31:0] rs1_data;     // source register 1 data
    wire [31:0] rs2_data;     // source register 2 data
    wire [31:0] wb_data;      // write back data to register
    wire [31:0] ld_data_in;    // data to be loaded
    wire [31:0] ld_data_out;   // data loaded from memory
    wire [31:0] sext_imme;    // sign extended immediate
    wire [31:0] jb_operand1;  // operand1 for jump
    wire [31:0] jb_pc;        // jump program counter

    wire [3:0] dm_w_en;  // 4'b0000: no write, 4'b0001: byte, 4'b0011: half, 4'b1111: word
    wire wb_en;          // 0: no write, 1: write back to reg
    wire next_pc_sel;    // 0: pc+4, 1: imm
    wire wb_sel;         // 0: alu_out, 1: dm_wb_data
    wire jb_op1_sel;     // 0: rs1_data, 1: pc
    wire alu_op1_sel;    // 0: rs1_data, 1: pc
    wire alu_op2_sel;    // 0: rs2_data, 1: imm
    wire branch;         // 0: pc+4, 1: imm

    SRAM im(
        .clk(clk),
        .func3(func3),
        .w_en(4'b0000),
        .addr(pc[15:0]),
        .write_data(32'b0),
        .read_data(instruction)
    );
    Controller ctrl(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .branch(branch),
        .next_pc_sel(next_pc_sel),
        .wb_en(wb_en),
        .jb_op1_sel(jb_op1_sel),
        .alu_op1_sel(alu_op1_sel),
        .alu_op2_sel(alu_op2_sel),
        .wb_sel(wb_sel),
        .dm_w_en(dm_w_en)
    );
    Mux next_pc_mux(
        .sel(next_pc_sel),
        .input0(pc + 4),
        .input1(jb_pc),
        .out(next_pc)
    );
    Reg_PC reg_pc(
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );
    Decoder dec(
        .instruction(instruction),
        .rd_index(rd_index),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .opcode(opcode),
        .func3(func3),
        .func7(func7)
    );
    Imme_Ext imm(
        .instruction(instruction),
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .sext_imme(sext_imme)
    );
    Mux jb_op1(
        .sel(jb_op1_sel),
        .input0(rs1_data),
        .input1(pc),
        .out(jb_operand1)
    );
    JB_Unit jb(
        .operand1(jb_operand1),
        .operand2(sext_imme),
        .jb_out(jb_pc)
    );
    Reg regfile(
        .clk(clk),
        .wb_en(wb_en),
        .wb_data(wb_data),
        .rd_index(rd_index),
        .rs1_index(rs1_index),
        .rs2_index(rs2_index),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
    Mux rs1(
        .sel(alu_op1_sel),
        .input0(rs1_data),
        .input1(pc),
        .out(alu_op1)
    );
    Mux rs2(
        .sel(alu_op2_sel),
        .input0(rs2_data),
        .input1(sext_imme),
        .out(alu_op2)
    );
    ALU alu(
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .operand1(alu_op1),
        .operand2(alu_op2),
        .alu_out(alu_out),
        .branch(branch)
    );
    SRAM dm(
        .clk(clk),
        .func3(func3),
        .w_en(dm_w_en),
        .addr(alu_out[15:0]),
        .write_data(rs2_data),
        .read_data(ld_data_in)
    );
    LD_Filter filter(
        .func3(func3),
        .ld_data_in(ld_data_in),
        .ld_data_out(ld_data_out)
    );
    Mux wb(
        .sel(wb_sel),
        .input0(alu_out),
        .input1(ld_data_out),
        .out(wb_data)
    );
endmodule