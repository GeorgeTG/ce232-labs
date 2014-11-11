module CPU
#( parameter INSTRUCTION_MEMORY_SIZE = 4096, parameter DATA_MEMORY_SIZE = 4096)
(
        input wire Clock,
        input wire Reset
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
            .PC(pc),
            .PC_plus4(pc_plus4)
        );

        wire [31 : 0] instruction;

        InstructionMemory #(.SIZE(INSTRUCTION_MEMORY_SIZE)) InstructionMemory_0
        (
            .ReadAddress(pc),
            .Instruction(instruction)
        );

        wire reg_write, reg_dst, alu_src, branch;
        wire mem_write, mem_read, mem_to_reg;
        wire [1 : 0] alu_op;

        Control Control_0(
            .Op(instruction[31 : 26]),
            .RegWrite(reg_write),
            .RegDst(reg_dst),
            .ALUSrc(alu_src),
            .Branch(branch),
            .MemWrite(mem_write),
            .MemRead(mem_read),
            .MemToReg(mem_to_reg),
            .ALUOp(alu_op)
        );

        wire [4 : 0] write_address_in;

        mux2to1 #( .DATA_WIDTH(5)) RegDstMux
        (
            .InputA(instruction[20 : 16]),
            .InputB(instruction[15 : 11]),
            .Select(reg_dst),
            .Out(write_address_in)
        );

        wire [31 : 0] write_data_in, read_data_out_a, read_data_out_b;

        RegisterFile RegisterFile_0(
            .Clock(Clock),
            .Reset(Reset),
            .ReadAddressA(instruction[25 : 21]),
            .ReadAddressB(instruction[20 : 16]),
            .WriteAddress(write_address_in),
            .WriteData(write_data_in),
            .WriteEnable(reg_write),
            .ReadDataA(read_data_out_a),
            .ReadDataB(read_data_out_b)
        );

        wire [31 : 0] sign_extended;

        SignExtender SignExtender_0(
            .Immediate(instruction[15 : 0]),
            .Extended(sign_extended)
        );

        wire [3 : 0] alu_ctrl;

        ALUControl ALUControl_0(
            .ALUOp(alu_op),
            .Function(instruction[5 : 0]),
            .ALUCtrl(alu_ctrl)
        );

        wire [31 : 0] alu_input_b;

        mux2to1 #( .DATA_WIDTH(32) ) ALUInputBMux
        (
            .InputA(read_data_out_b),
            .InputB(sign_extended),
            .Select(alu_src),
            .Out(alu_input_b)
        );

        wire alu_zero;
        wire [31 : 0] alu_out;

        ALU ALU_0(
            .InputA(read_data_out_a),
            .InputB(alu_input_b),
            .Op(alu_ctrl),
            .Zero(alu_zero),
            .Out(alu_out)
        );

        wire pc_mux_select;

        and PcMuxSelectAnd (
            pc_mux_select,
            pc_plus4,
            branch
        );

        wire [31 : 0] pc_new_adder_shifted_input;

        LeftShifter PcNewAdderShifter(
            .Input(sign_extended),
            .Out(pc_new_adder_shifted_input)
        );

        wire [31 : 0] pc_mux_input_b;
        wire z_carry;

        FullAdder PcNewAdder(
            .InputA(pc_plus4),
            .InputB(pc_new_adder_shifted_input),
            .Sum(pc_mux_input_b),
            .Carry(z_carry)
        );

        mux2to1 #( .DATA_WIDTH(32) ) PcNewMux
        (
            .InputA(pc_plus4),
            .InputB(pc_mux_input_b),
            .Select(pc_mux_select),
            .Out(pc_new)
        );

        wire [31 : 0] memory_read_data;

        Memory #( .SIZE(DATA_MEMORY_SIZE) ) Memory_0
        (
            .ReadEnable(mem_read),
            .WriteEnable(mem_write),
            .Clock(Clock),
            .Address(alu_out),
            .DataIn(read_data_out_b),
            .DataOut(memory_read_data)
        );

        mux2to1 #( .DATA_WIDTH(32) ) MemOutMux
        (
            .InputB(memory_read_data),
            .InputA(alu_out),
            .Select(mem_to_reg),
            .Out(write_data_in)
        );

endmodule

