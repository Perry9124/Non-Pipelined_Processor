`include "./src/define.v"
module LD_Filter(
    input [2:0] func3,
    input [31:0] ld_data_in,
    output reg [31:0] ld_data_out
);
    always@(*) begin
        case(func3)
        `LB: begin
            ld_data_out = {{24{ld_data_in[7]}}, ld_data_in[7:0]};
        end
        `LBU: begin
            ld_data_out = {24'b0, ld_data_in[7:0]};
        end
        `LH: begin
            ld_data_out = {{16{ld_data_in[15]}}, ld_data_in[15:0]};
        end
        `LHU: begin
            ld_data_out = {16'b0, ld_data_in[15:0]};
        end
        `LW: begin
            ld_data_out = ld_data_in;
        end
        default: begin
            ld_data_out = 32'b0;
        end
        endcase
    end
endmodule