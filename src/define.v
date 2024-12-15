`define RTYPE 7'b0110011 // reg
`define ITYPE 7'b0010011 // imm
`define STYPE 7'b0100011 // store
`define BTYPE 7'b1100011 // branch
`define LUI 7'b0110111   // lui
`define AUIPC 7'b0010111 // pc + imm
`define JAL 7'b1101111   // jump and link
`define JALR 7'b1100111  // jump and link register
`define LOAD 7'b0000011  // load

`define ADD_SUB 3'b000   // add or sub
`define SLT 3'b010       // set less than
`define SLTU 3'b011      // set less than unsigned
`define XOR 3'b100
`define OR 3'b110
`define AND 3'b111
`define SHIFTL 3'b001    // shift left
`define SHIFTR 3'b101    // shift right

`define ADD 7'b0000000
`define SUB 7'b0100000
`define SRL 7'b0000000
`define SRA 7'b0100000

// Load and Store
`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101
`define SB 3'b000
`define SH 3'b001
`define SW 3'b010

// Branch
`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define BLTU 3'b110
`define BGEU 3'b111

// operand1, operand2 select
`define REG 1'b0
`define IMM 1'b1
`define PC 1'b1