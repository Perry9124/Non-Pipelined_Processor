module Reg(
    input clk, 
    input wb_en,
    input [31:0] wb_data,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
    reg [31:0] registers [31:0];  // x0-x31
    always @(posedge clk) begin
        if (wb_en && rd_index != 0) begin
            registers[rd_index] <= wb_data;
        end
    end
    assign rs1_data = registers[rs1_index];
    assign rs2_data = registers[rs2_index];
endmodule