module Mux(
    input [31:0] input0,
    input [31:0] input1,
    input sel,
    output [31:0] out
);
    assign out = sel ? input1 : input0;
endmodule