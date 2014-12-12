`include "constants.h"

/************** Main FSM in ID pipe stage  *************/
module fsm_main(output reg RegDst,
                output reg Branch,
                output reg MemRead,
                output reg MemWrite,
                output reg MemToReg,
                output reg ALUSrc,
                output reg RegWrite,
                output reg [1:0] ALUcntrl,
                output reg [1:0] PCScr,

                input wire Zero,
                input [5:0] opcode);

  always @(*) begin
    case (opcode)
      `R_FORMAT:
          begin
            RegDst = 1'b1;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl  = 2'b10; // R
          end
       `LW :
           begin
            RegDst = 1'b0;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
        `SW :
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b0;
            Branch = 1'b0;
            ALUcntrl  = 2'b00; // add
           end
       `BEQ:
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            Branch = 1'b1;
            ALUcntrl = 2'b01; // sub
        end

        `BNE:
         begin
             RegDst = 1'b0;
             MemRead = 1'b0;
             MemWrite = 1'b0;
             MemToReg = 1'b0;
             ALUSrc = 1'b0;
             RegWrite = 1'b0;
             Branch = 1'b1;
             ALUcntrl = 2'b01;
         end

        `ADDI:
        begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b1;
            RegWrite = 1'b1;
            Branch = 1'b0;
            ALUcntrl = 2'b00; //add
        end

        `J:
        begin
             RegDst = 1'b0;
             MemRead = 1'b0;
             MemWrite = 1'b0;
             MemToReg = 1'b0;
             ALUSrc = 1'b0;
             RegWrite = 1'b0;
             Branch = 1'b0;
             ALUcntrl = 2'b00;
         end

       default:
           begin
            RegDst = 1'b0;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            ALUSrc = 1'b0;
            RegWrite = 1'b0;
            ALUcntrl = 2'b00;
         end
      endcase
    end // always

    always@(opcode, Branch, Zero)
        if (opcode == `J)
            PCScr = 2'b10;
        else if ((opcode == `BNE) && (~Zero && Branch))
            PCScr = 2'b01;
        else if ((opcode == `BEQ) &&(Zero && Branch))
            PCScr = 2'b01;
        else
            PCScr = 2'b00;


endmodule


/************** FSM for ALU control in EX pipe stage  *************/
module fsm_alu(output reg [3:0] ALUOp,
               input [1:0] ALUcntrl,
               input [5:0] func);

  always @(ALUcntrl or func)
    begin
      case (ALUcntrl)
        2'b10:
           begin
             case (func)
              6'b100000: ALUOp  = 4'b0010; // add
              6'b100010: ALUOp = 4'b0110; // sub
              6'b100100: ALUOp = 4'b0000; // and
              6'b100101: ALUOp = 4'b0001; // or
              6'b100111: ALUOp = 4'b1100; // nor
              6'b101010: ALUOp = 4'b0111; // slt
              default: ALUOp = 4'b0000;
             endcase
          end
        2'b00:
              ALUOp  = 4'b0010; // add
        2'b01:
              ALUOp = 4'b0110; // sub
        default:
              ALUOp = 4'b0000;
     endcase
    end
endmodule
