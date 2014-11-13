/*****************************************
 *           Main Control Uni            *
 *          George T. Gougoudis          *
 *****************************************/

`include "opcodes.v"

module Control
(
        input wire [5:0] Op,

        output reg RegWrite,
        output reg RegDst,
        output reg ALUSrc,
        output reg Branch,
        output reg MemWrite,
        output reg MemRead,
        output reg MemToReg,
        output reg [1:0] ALUOp
);

        always @(Op) begin
            case (Op)
                `R_TYPE :
                    begin
                        RegWrite = 1'b1;
                        RegDst = 1'b1;
                        ALUSrc = 1'b0;
                        Branch = 1'b0;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemToReg = 1'b0;
                        ALUOp = 2'b10;
                    end

                `LW :
                    begin
                        RegWrite = 1'b1;
                        RegDst = 1'b0;
                        ALUSrc = 1'b1;
                        Branch = 1'b0;
                        MemWrite = 1'b0;
                        MemRead = 1'b1;
                        MemToReg = 1'b1;
                        ALUOp = 2'b00;
                    end

                `SW :
                    begin
                        RegWrite = 1'b0;
                        RegDst = 1'bx;
                        ALUSrc = 1'b1;
                        Branch = 1'b0;
                        MemWrite = 1'b1;
                        MemRead = 1'b0;
                        MemToReg = 1'bx;
                        ALUOp = 2'b00;
                    end

                `BEQ :
                    begin
                        RegWrite = 1'b0;
                        RegDst = 1'bx;
                        ALUSrc = 1'b0;
                        Branch = 1'b1;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemToReg = 1'bx;
                        ALUOp = 2'b01;
                    end

                `BNE :
                    begin
                        RegWrite = 1'b0;
                        RegDst = 1'b0;
                        ALUSrc = 1'b0;
                        Branch = 1'b1;
                        MemWrite = 1'b0;
                        MemRead = 1'b0;
                        MemToReg = 1'b0;
                        ALUOp = 2'b10;
                    end

                 `ADDI :
                    begin
                        RegWrite = 1'b1;
                        RegDst = 1'b0;
                        ALUSrc = 1'b1;
                        Branch = 1'b0;
                        MemWrite = 1'b0;
                        MemToReg = 1'b0;
                        ALUOp = 2'b00;
                    end

                default:
                    begin
                        RegWrite = 1'b0;
                        RegDst = 1'b0;
                        ALUSrc = 1'b0;
                        Branch = 1'b0;
                        MemWrite = 1'b0;
                        MemToReg = 1'b0;
                        ALUOp = 2'b00;
                        $display("[CONTROL][%4d] Unknown OP code: %2d",
                            $time, Op);
                    end
            endcase
         end //always

 endmodule

