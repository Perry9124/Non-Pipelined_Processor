`include "./src/define.v"
module Imme_Ext(
    input [31:0] instruction,
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output reg [31:0] sext_imme
);
    always@(*) begin
        case(opcode)
        `ITYPE: begin
            case(func3)
            `SHIFTL: begin
                sext_imme = {20'b0, instruction[24:20]};
            end
            `SHIFTR: begin
                case(func7)
                `SRA: begin
                    sext_imme = {20'b0, instruction[24:20]};
                end
                `SRL: begin
                    sext_imme = {20'b0, instruction[24:20]};
                end
                default: begin
                    sext_imme = 32'b0;
                end
                endcase
            end
            default: begin
                sext_imme = {{20{instruction[31]}}, instruction[31:20]};
            end
            endcase
        end
        `RTYPE: begin
            sext_imme = 32'b0;
        end
        `LUI: begin
            sext_imme = {instruction[31:12], 12'b0};
        end
        `AUIPC: begin
            sext_imme = {instruction[31:12], 12'b0};
        end
        `JAL: begin
            sext_imme = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        end
        `JALR: begin
            sext_imme = {{20{instruction[31]}}, instruction[31:20]};
        end
        `STYPE: begin
            sext_imme = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end
        `BTYPE: begin
            sext_imme = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end
        `LOAD: begin
            sext_imme = {{20{instruction[31]}}, instruction[31:20]};
        end
        endcase
    end
endmodule