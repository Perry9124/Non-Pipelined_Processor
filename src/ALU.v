`include "./src/define.v"
module ALU (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg signed [31:0] alu_out,
    output reg branch
);
    wire [31:0] add_result, sub_result, shiftl_result, shiftr_result, sra_result;
    wire [31:0] sra_offset, sra_sign;
    assign shiftl_result = operand1 << operand2[4:0];
    assign shiftr_result = operand1 >> operand2[4:0];
    assign sra_sign = {32{operand1[31]}} << sra_offset;
    Adder add(
        .a(operand1),
        .b(operand2),
        .sum(add_result)
    );
    Adder sub(
        .a(operand1),
        .b(~operand2 + 32'b1),
        .sum(sub_result)
    );
    Adder offset(
        .a(32'd32),
        .b(~operand2 + 32'b1),
        .sum(sra_offset)
    );
    Adder sra(
        .a(sra_sign),
        .b(shiftr_result),
        .sum(sra_result)
    );
    always@(*) begin
        case(opcode)
        `LUI: begin
            alu_out = operand2;    // imm << 12
            branch = 1'b0;
        end
        `AUIPC: begin
            alu_out = operand1 + operand2;  // PC + imm
            branch = 1'b0;
        end
        `JAL: begin
            alu_out = operand1 + 32'b100;   // PC + 4
            branch = 1'b1;
        end
        `JALR: begin
            alu_out = operand1 + 32'b100;   // PC + 4
            branch = 1'b1;
        end
        `BTYPE: begin
            case(func3)
            `BEQ: begin
                branch = operand1 == operand2 ? 1'b1 : 1'b0;
            end
            `BNE: begin
                branch = operand1 != operand2 ? 1'b1 : 1'b0;
            end
            `BLT: begin
                branch = $signed(operand1) < $signed(operand2) ? 1'b1 : 1'b0;
            end
            `BGE: begin
                branch = $signed(operand1) >= $signed(operand2) ? 1'b1 : 1'b0;
            end
            `BLTU: begin
                branch = operand1 < operand2 ? 1'b1 : 1'b0;
            end
            `BGEU: begin
                branch = operand1 >= operand2 ? 1'b1 : 1'b0;
            end
            endcase
        end
        `ITYPE: begin
            case(func3)
            `ADD_SUB: begin
                alu_out = add_result;
            end
            `SLT: begin
                alu_out = $signed(operand1) < $signed(operand2) ? 32'b1 : 32'b0;
            end
            `SLTU: begin
                alu_out = operand1 < operand2 ? 32'b1 : 32'b0;
            end
            `XOR: begin
                alu_out = operand1 ^ operand2;
            end
            `OR: begin
                alu_out = operand1 | operand2;
            end
            `AND: begin
                alu_out = operand1 & operand2;
            end
            `SHIFTL: begin
                alu_out = shiftl_result;
            end
            `SHIFTR: begin
                case(func7)
                `SRA: begin
                    alu_out = sra_result;
                end
                `SRL: begin
                    alu_out = shiftr_result;
                end
                default: begin
                    alu_out = 32'b0;
                end
                endcase
            end
            default: begin
                alu_out = 32'b0;
            end
            endcase
        end
        `RTYPE: begin
            case(func3)
            `ADD_SUB: begin
                case(func7)
                `ADD: begin
                    alu_out = add_result;
                end
                `SUB: begin
                    alu_out = sub_result;
                end
                default: begin
                    alu_out = 32'b0;
                end
                endcase
            end
            `SLT: begin
                alu_out = $signed(operand1) < $signed(operand2) ? 32'b1 : 32'b0;
            end
            `SLTU: begin
                alu_out = operand1 < operand2 ? 32'b1 : 32'b0;
            end
            `XOR: begin
                alu_out = operand1 ^ operand2;
            end
            `OR: begin
                alu_out = operand1 | operand2;
            end
            `AND: begin
                alu_out = operand1 & operand2;
            end
            `SHIFTL: begin
                alu_out = shiftl_result;
            end
            `SHIFTR: begin
                case(func7)
                `SRA: begin
                    alu_out = sra_result;
                end
                `SRL: begin
                    alu_out = shiftr_result;
                end
                default: begin
                    alu_out = 32'b0;
                end
                endcase
            end
            default: begin
                alu_out = 32'b0;
            end
            endcase
        end
        `STYPE: begin
            alu_out = operand1 + operand2;  // rs1 + imm
        end
        `LOAD: begin
            alu_out = operand1 + operand2;  // rs1 + imm
        end
        default: begin
            alu_out = 32'b0;
            branch = 1'b0;
        end
        endcase
    end
endmodule