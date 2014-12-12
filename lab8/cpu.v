module cpu(input clock, input reset);
 reg [31:0] PC;
 reg [31:0] IFID_PCplus4;
 reg [31:0] IFID_instr;
 reg [31:0] IDEX_rdA, IDEX_rdB, IDEX_signExtend;
 reg [4:0]  IDEX_instr_rt, IDEX_instr_rs, IDEX_instr_rd;
 reg        IDEX_RegDst, IDEX_ALUSrc;
 reg [1:0]  IDEX_ALUcntrl;
 reg        IDEX_Branch, IDEX_MemRead, IDEX_MemWrite;
 reg        IDEX_MemToReg, IDEX_RegWrite;
 reg [4:0]  EXMEM_RegWriteAddr, EXMEM_instr_rd;
 reg [31:0] EXMEM_ALUOut;
 reg [31:0] EXMEM_MemWriteData;
 reg        EXMEM_Branch, EXMEM_MemRead, EXMEM_MemWrite, EXMEM_RegWrite, EXMEM_MemToReg;
 reg [31:0] MEMWB_DMemOut;
 reg [4:0]  MEMWB_RegWriteAddr, MEMWB_instr_rd;
 reg [31:0] MEMWB_ALUOut;
 reg        MEMWB_MemToReg, MEMWB_RegWrite;
 reg [31:0]  ALUInA, ALUInB;
 wire [31:0] instr, ALUInBMux, ALUOut, rdA, rdB, signExtend, DMemOut, wRegData, PCIncr;
 wire Zero, RegDst, MemRead, MemWrite, MemToReg, ALUSrc, RegWrite, Branch;
 wire [5:0] opcode, func;
 wire [4:0] instr_rs, instr_rt, instr_rd, RegWriteAddr;
 wire [3:0] ALUOp;
 wire [1:0] ALUcntrl;
 wire [15:0] imm;
 wire [1:0] ForwardA, ForwardB;
 wire Stall, StallCtrl, StallMem;
 reg MemRead_new, MemWrite_new, MemToReg_new, Branch_new, ALUSrc_new, RegDst_new, RegWrite_new;
 reg [1:0] ALUcntrl_new;
 wire [1:0] PCScr;
 reg [31:0] branch_rdA, branch_rdB;
 wire CtrlForwardA, CtrlForwardB;

/***************** Instruction Fetch Unit (IF)  ****************/
 always @(posedge clock or negedge reset)
  begin
    if (reset == 1'b0)
       PC <= -1;
    else if (PC == -1)
       PC <= 0;
    else if (Stall == 1'b0)
        if (PCScr == 2'b01)
            PC <= PCIncr;
        else if (PCScr == 2'b10) begin
           // PC <= PC + 4;
            PC <= {PC[31:28], IFID_instr[25:0]<<2 };
        end
        else
            PC <= PC + 4;
  end

  // IFID pipeline register
 always @(posedge clock or negedge reset)begin
                            //Don't flush when we are stalling
    if (reset == 1'b0 || ( (PCScr != 2'b00) && (Stall == 1'b0) )) begin
       IFID_PCplus4 <= 32'b0;
       IFID_instr <= 32'b0;
    end
    else if (Stall == 1'b0) begin
       IFID_PCplus4 <= PC + 32'd4;
       IFID_instr <= instr;
    end
  end

  assign Zero = (branch_rdA == branch_rdB);
  assign PCIncr = (signExtend << 2) + IFID_PCplus4;

  ControlForwardingUnit control_frwd_unit(Branch, EXMEM_RegWrite, EXMEM_MemRead, EXMEM_RegWriteAddr, instr_rs, instr_rt, CtrlForwardA, CtrlForwardB);

    always@(CtrlForwardA, rdA, EXMEM_ALUOut) begin
        case(CtrlForwardA)
            1'b1:
                branch_rdA = EXMEM_ALUOut;
            default:
                branch_rdA = rdA;
        endcase
    end

    always@(CtrlForwardB, rdB, EXMEM_ALUOut) begin
        case(CtrlForwardB)
            1'b1:
                branch_rdB = EXMEM_ALUOut;
            default:
                branch_rdB = rdB;
        endcase
    end

// Instruction memory 1KB
Memory cpu_IMem(clock, reset, 1'b1, 1'b0, PC>>2, 32'b0, instr);


/***************** Instruction Decode Unit (ID)  ****************/
assign opcode = IFID_instr[31:26];
assign func = IFID_instr[5:0];
assign instr_rs = IFID_instr[25:21];
assign instr_rt = IFID_instr[20:16];
assign instr_rd = IFID_instr[15:11];
assign imm = IFID_instr[15:0];
assign signExtend = {{16{imm[15]}}, imm};

// Register file
RegFile cpu_regs(clock, reset, instr_rs, instr_rt, MEMWB_RegWriteAddr, MEMWB_RegWrite, wRegData, rdA, rdB);


  // IDEX pipeline register
 always @(posedge clock or negedge reset)
  begin
    if (reset == 1'b0)
      begin
       IDEX_rdA <= 32'b0;
       IDEX_rdB <= 32'b0;
       IDEX_signExtend <= 32'b0;
       IDEX_instr_rd <= 5'b0;
       IDEX_instr_rs <= 5'b0;
       IDEX_instr_rt <= 5'b0;
       IDEX_RegDst <= 1'b0;
       IDEX_ALUcntrl <= 2'b0;
       IDEX_ALUSrc <= 1'b0;
       IDEX_Branch <= 1'b0;
       IDEX_MemRead <= 1'b0;
       IDEX_MemWrite <= 1'b0;
       IDEX_MemToReg <= 1'b0;
       IDEX_RegWrite <= 1'b0;
    end
    else
      begin
       IDEX_rdA <= rdA;
       IDEX_rdB <= rdB;
       IDEX_signExtend <= signExtend;
       IDEX_instr_rd <= instr_rd;
       IDEX_instr_rs <= instr_rs;
       IDEX_instr_rt <= instr_rt;

       IDEX_MemRead <= MemRead_new;
       IDEX_MemWrite <= MemWrite_new;
       IDEX_MemToReg <= MemToReg_new;
       IDEX_Branch <= Branch_new;
       IDEX_ALUcntrl <= ALUcntrl_new;
       IDEX_ALUSrc <= ALUSrc_new;
       IDEX_RegDst <= RegDst_new;
       IDEX_RegWrite <= RegWrite_new;
    end // if (reset..)
  end //always

// Main Control Unit
fsm_main fsm_main (RegDst,
                  Branch,
                  MemRead,
                  MemWrite,
                  MemToReg,
                  ALUSrc,
                  RegWrite,
                  ALUcntrl,
                  PCScr,
                  Zero,
                  opcode);

// Instantiation of Control Unit that generates stalls goes here
always @(MemRead, MemWrite, MemToReg, Branch, ALUcntrl, ALUSrc, RegDst, RegWrite, Stall)
    if (Stall == 1'b0) begin
        MemRead_new = MemRead;
        MemWrite_new = MemWrite;
        MemToReg_new = MemToReg;
        Branch_new = Branch;
        ALUSrc_new = ALUSrc;
        RegDst_new = RegDst;
        RegWrite_new = RegWrite;
        ALUcntrl_new = ALUcntrl;
    end
    else begin
        MemRead_new = 1'b0;
        MemWrite_new = 1'b0;
        MemToReg_new = 1'b0;
        Branch_new = 1'b0;
        ALUSrc_new = 1'b0;
        RegDst_new = 1'b0;
        RegWrite_new = 1'b0;
        ALUcntrl_new = 2'b0;
    end

ControlHazardDetectionUnit ctrl_hazard_detector(Branch, IDEX_RegWrite,EXMEM_MemRead, EXMEM_RegWriteAddr, instr_rs, instr_rt, RegWriteAddr, StallCtrl);
HazardDetectionUnit hazard_detector(IDEX_instr_rt, IDEX_MemRead, instr_rt, instr_rs, StallMem);
assign Stall = StallMem || StallCtrl;


/***************** Execution Unit (EX)  ****************/

//assign ALUInA = IDEX_rdA;

//assign ALUInB

//  ALU
ALU  #32 cpu_alu(ALUOut, ALUInA, ALUInBMux, ALUOp);

assign RegWriteAddr = (IDEX_RegDst==1'b0) ? IDEX_instr_rt : IDEX_instr_rd;

 // EXMEM pipeline register
 always @(posedge clock or negedge reset)
  begin
    if (reset == 1'b0)
      begin
       EXMEM_ALUOut <= 32'b0;
       EXMEM_RegWriteAddr <= 5'b0;
       EXMEM_MemWriteData <= 32'b0;
       EXMEM_Branch <= 1'b0;
       EXMEM_MemRead <= 1'b0;
       EXMEM_MemWrite <= 1'b0;
       EXMEM_MemToReg <= 1'b0;
       EXMEM_RegWrite <= 1'b0;
      end
    else
      begin
       EXMEM_ALUOut <= ALUOut;
       EXMEM_RegWriteAddr <= RegWriteAddr;
       EXMEM_MemWriteData <= ALUInB;
       EXMEM_Branch <= IDEX_Branch;
       EXMEM_MemRead <= IDEX_MemRead;
       EXMEM_MemWrite <= IDEX_MemWrite;
       EXMEM_MemToReg <= IDEX_MemToReg;
       EXMEM_RegWrite <= IDEX_RegWrite;
      end
  end

  // ALU FSM
  fsm_alu fsm_alu(ALUOp, IDEX_ALUcntrl, IDEX_signExtend[5:0]);

   // Instantiation of control logic for Forwarding goes here

ForwardingUnit forwarding(IDEX_instr_rt, IDEX_instr_rs, EXMEM_RegWriteAddr, EXMEM_RegWrite, MEMWB_RegWrite, MEMWB_RegWriteAddr, ForwardA, ForwardB);

always @(IDEX_rdA, wRegData, EXMEM_ALUOut, ForwardA) begin
    case(ForwardA)
        0 : ALUInA = IDEX_rdA;
        1 : ALUInA = wRegData;
        2 : ALUInA = EXMEM_ALUOut;
        default: ALUInA = 0;
    endcase
end

always @(IDEX_rdB, wRegData, EXMEM_ALUOut, ForwardB) begin
    case(ForwardB)
        0 : ALUInB = IDEX_rdB;
        1 : ALUInB = wRegData;
        2 : ALUInB = EXMEM_ALUOut;
        default: ALUInB = 0;
    endcase
end

assign ALUInBMux = (IDEX_ALUSrc == 1'b0) ? ALUInB : IDEX_signExtend;

/***************** Memory Unit (MEM)  ****************/

// Data memory 1KB
Memory cpu_DMem(clock, reset, EXMEM_MemRead, EXMEM_MemWrite, EXMEM_ALUOut, EXMEM_MemWriteData, DMemOut);

// MEMWB pipeline register
 always @(posedge clock or negedge reset)
  begin
    if (reset == 1'b0)
      begin
       MEMWB_DMemOut <= 32'b0;
       MEMWB_ALUOut <= 32'b0;
       MEMWB_RegWriteAddr <= 5'b0;
       MEMWB_MemToReg <= 1'b0;
       MEMWB_RegWrite <= 1'b0;
      end
    else
      begin
       MEMWB_DMemOut <= DMemOut;
       MEMWB_ALUOut <= EXMEM_ALUOut;
       MEMWB_RegWriteAddr <= EXMEM_RegWriteAddr;
       MEMWB_MemToReg <= EXMEM_MemToReg;
       MEMWB_RegWrite <= EXMEM_RegWrite;
      end
  end


/***************** WriteBack Unit (WB)  ****************/
assign wRegData = (MEMWB_MemToReg == 1'b0) ? MEMWB_ALUOut : MEMWB_DMemOut;


endmodule
