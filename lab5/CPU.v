module CPU
( parameter INSTRUCTION_MEMORY_SIZE = 4096, parameter DATA_MEMORY_SIZE = 4096)
(
        input wire Clock;
        input wire Reset;
);

        wire [31 : 0] pc_new;
        wire [31 : 0] pc;

        ProgramCounter ProgramCounter_0(
            .Clock(Clock),
            .Reset(Reset),
            .PC_new(pc_new),
            .PC(pc)
        );

        wire [31 : 0] pc_plus4;

        PCPlus4 PCPlus4_0 (
            .PC(pc)
            .PC_plus4(pc_plus4)
        );

        wire [31 : 0] instruction;

        InstructionMemory InstructionMemory_0(
            .ReadAddress(pc),
            .Instruction(instruction)
        );

        wire reg_write, reg_dst, alu_src, branch, mem_write, mem_to_reg;
        wire [1 : 0] alu_op;

        Control Control_0(
            .Op(instruction[31 : 26]),
            .RegWrite(reg_write),
            .RegDst(reg_dst),
            .ALUSrc(alu_src),
            .Branch(branch),
            .MemWrite(mem_write),
            .MemToReg(mem_to_reg),
            .ALUOp(alu_op)
        );

        wire write_address_in;

        mux2to1 RegDstMux #( .DATA_WIDTH(5)) (
            .InputA(instruction[20 : 16]),
            .InputB(instruction[15 : 11]),
            .Select(reg_dst),
            .Out(write_address_in)
        );

        wire write_data_in, read_data_out_a, read_data_out_b;

        RegisterFile RegisterFile_0(
            .Clock(Clock)
            .Reset(Reset)
            .ReadAddressA(instruction[25 : 21]),
            .ReadAddressB(instruction[20 : 16]),
            .WriteAddress(write_address_in),
            .WriteData(write_data_in),
            .WriteEnable(reg_write),
            .ReadDataA(read_data_out_a),
            .ReadDataB(read_data_out_b)
        );




