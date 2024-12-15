module Reg_PC(
    input clk, 
    input rst,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 32'b0;
        end
        else begin
            pc <= next_pc;
        end
    end
endmodule