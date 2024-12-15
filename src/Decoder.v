`include "./src/define.v"
module Decoder(
    input [31:0] instruction,
    output reg [4:0] rd_index,
    output reg [4:0] rs1_index,
    output reg [4:0] rs2_index,
    output [6:0] opcode,
    output reg [2:0] func3,
    output reg [6:0] func7
);
    assign opcode = instruction[6:0];
    always@(*) begin
        case(opcode)
        `RTYPE: begin
            rd_index = instruction[11:7];
            func3 = instruction[14:12];
            rs1_index = instruction[19:15];
            rs2_index = instruction[24:20];
            func7 = instruction[31:25];
        end
        `ITYPE: begin
            rd_index = instruction[11:7];
            func3 = instruction[14:12];
            rs1_index = instruction[19:15];
            rs2_index = 5'b00000;
            case(func3)
            `SHIFTL: begin
                func7 = instruction[31:25];
            end
            `SHIFTR: begin
                func7 = instruction[31:25];
            end
            default: begin
                func7 = 7'b0000000;
            end
            endcase
        end
        `STYPE: begin
            rd_index = 5'b00000;
            func3 = instruction[14:12];
            rs1_index = instruction[19:15];
            rs2_index = instruction[24:20];
            func7 = 7'b0000000;
        end
        `BTYPE: begin
            rd_index = 5'b00000;
            func3 = instruction[14:12];
            rs1_index = instruction[19:15];
            rs2_index = instruction[24:20];
            func7 = 7'b0000000;
        end
        `LUI: begin
            rd_index = instruction[11:7];
            func3 = 3'b000;
            rs1_index = 5'b00000;
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        `AUIPC: begin
            rd_index = instruction[11:7];
            func3 = 3'b000;
            rs1_index = 5'b00000;
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        `JAL: begin
            rd_index = instruction[11:7];
            func3 = 3'b000;
            rs1_index = 5'b00000;
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        `JALR: begin
            rd_index = instruction[11:7];
            func3 = 3'b000;
            rs1_index = instruction[19:15];
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        `LOAD: begin
            rd_index = instruction[11:7];
            func3 = instruction[14:12];
            rs1_index = instruction[19:15];
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        default: begin
            rd_index = 5'b00000;
            func3 = 3'b000;
            rs1_index = 5'b00000;
            rs2_index = 5'b00000;
            func7 = 7'b0000000;
        end
        endcase
    end
endmodule