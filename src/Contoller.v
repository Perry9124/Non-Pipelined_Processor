`include "./src/define.v"
module Controller(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input branch,
    output reg next_pc_sel,
    output reg wb_en,
    output reg jb_op1_sel,
    output reg alu_op1_sel,
    output reg alu_op2_sel,
    output reg wb_sel,
    output reg [3:0] dm_w_en
);
    always@(*) begin
        case(opcode)
        `RTYPE: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b1;
            jb_op1_sel = 1'b0;
            alu_op1_sel = `REG;
            alu_op2_sel = `REG;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `ITYPE: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b1;
            jb_op1_sel = 1'b0;
            alu_op1_sel = `REG;
            alu_op2_sel = `IMM;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `STYPE: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b0;
            jb_op1_sel = 1'b0;
            alu_op1_sel = `REG;
            alu_op2_sel = `IMM;
            wb_sel = 1'b0;
            case(func3)
            `SB: begin
                dm_w_en = 4'b0001;
            end
            `SH: begin
                dm_w_en = 4'b0011;
            end
            `SW: begin
                dm_w_en = 4'b1111;
            end
            endcase
        end
        `BTYPE: begin
            // pc + imm
            wb_en = 1'b0;
            jb_op1_sel = `PC;
            alu_op1_sel = `REG;
            alu_op2_sel = `REG;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
            if (branch) begin
                next_pc_sel = 1'b1;
            end
            else begin
                next_pc_sel = 1'b0;
            end
        end
        `LUI: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b1;
            jb_op1_sel = `REG;
            alu_op1_sel = `REG;
            alu_op2_sel = `IMM;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `AUIPC: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b1;
            jb_op1_sel = `REG;
            alu_op1_sel = `PC;
            alu_op2_sel = `IMM;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `JAL: begin
            next_pc_sel = 1'b1;
            wb_en = 1'b1;
            jb_op1_sel = `PC;   // pc + imm
            alu_op1_sel = `PC;  // pc + 4
            alu_op2_sel = `REG;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `JALR: begin
            next_pc_sel = 1'b1;
            wb_en = 1'b1;
            jb_op1_sel = `REG;  // rs1 + imm
            alu_op1_sel = `PC;  // pc + 4
            alu_op2_sel = `REG;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        `LOAD: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b1;
            jb_op1_sel = 1'b0;
            alu_op1_sel = `REG;
            alu_op2_sel = `IMM;
            wb_sel = 1'b1;
            dm_w_en = 4'b0000;
        end
        default: begin
            next_pc_sel = 1'b0;
            wb_en = 1'b0;
            jb_op1_sel = 1'b0;
            alu_op1_sel = 1'b0;
            alu_op2_sel = 1'b0;
            wb_sel = 1'b0;
            dm_w_en = 4'b0000;
        end
        endcase
    end
endmodule