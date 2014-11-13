/**********************************************
 * Main CPU module, with inline basic modules *
 *          George T. Gougoudis               *
 **********************************************/

module CPU
#( parameter INSTRUCTION_MEMORY_SIZE = 4096, parameter DATA_MEMORY_SIZE = 4096)
(
        input wire Clock,
        input wire Reset
);

        wire [31 : 0] pc;
        wire [31 : 0] pc_new;

        ProgramCounter ProgramCounter_0(
            .Clock(Clock),
            .Reset(Reset),
            .PC_new(pc_new),
            .PC(pc)
        );

        wire [31 : 0] pc_plus4;
        assign pc_plus4 = pc + 4;

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

        assign write_address_in = (reg_dst) ? instruction[15 : 11] : instruction[20 : 16];

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

        assign alu_input_b = (alu_src)? sign_extended : read_data_out_b;

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

        assign pc_mux_select = alu_zero && branch;

        wire [31 : 0] pc_new_adder_shifted_input;

        assign pc_new_adder_shifted_input = sign_extended << 2;

        wire [31 : 0] pc_mux_input_b;

        assign pc_mux_input_b = pc_plus4 + pc_new_adder_shifted_input;

        assign pc_new = (pc_mux_select) ? pc_mux_input_b : pc_plus4;

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

        assign write_data_in = (mem_to_reg) ? memory_read_data : alu_out;

endmodule

