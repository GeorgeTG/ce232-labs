//clock
`define clock_period 10

// Opcodes
`define R_FORMAT  6'b0
`define LW  6'b100011
`define SW  6'b101011
`define BEQ  6'b000100
`define BNE  6'b000101
`define J 6'b000010
`define ADDI 6'b00_10_00
`define NOP  32'b0000_0000_0000_0000_0000_0000_0000_0000
