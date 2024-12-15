`include "./src/define.v"
module SRAM(
    input clk,
    input [2:0] func3,
    input [3:0] w_en,
    input [15:0] addr,
    input [31:0] write_data,
    output [31:0] read_data
);
    reg [7:0] mem [0:65535];
    always @(posedge clk) begin
        if (w_en[0]) begin
            mem[addr] <= write_data[7:0];
        end
        if (w_en[1]) begin
            mem[addr + 1] <= write_data[15:8];
        end
        if (w_en[2]) begin
            mem[addr + 2] <= write_data[23:16];
        end
        if (w_en[3]) begin
            mem[addr + 3] <= write_data[31:24];
        end
    end
    // always@(*) begin
    //     read_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    // end
    assign read_data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
endmodule