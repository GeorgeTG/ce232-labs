/*****************************************
 *           ALUControl Module           *
 *          George T. Gougoudis          *
 *****************************************/

module ALUControl
(
        input wire [5 : 0] Function,
        input wire [1 : 0] ALUOp,

        output reg [3 : 0] ALUCtrl
);

    always @(Function or ALUOp) begin
        case (ALUOp)
            //Lw, SW (add)
            2'b00 : ALUCtrl = 4'b0010;

            //Beq (substract)
            2'b01 : ALUCtrl = 4'b0110;

            //R-Type
            2'b10 :
                begin
                    case (Function)
                        // add
                        6'b100000 : ALUCtrl = 4'b0010;

                        // substract
                        6'b100010 : ALUCtrl = 4'b0110;

                        //AND
                        6'b100100 : ALUCtrl = 4'b0000;

                        //OR
                        6'b100101 : ALUCtrl = 4'b0001;

                        //slt
                        6'b101010 : ALUCtrl = 4'b0111;

                        default:
                            begin
                                ALUCtrl = 4'bx;
                                $display("[ALUCONTROL][%2d] Warning unkown function [%2d]",
                                    $time, Function);
                            end //default
                    endcase
                end //2'b10

            default:
                begin
                    ALUCtrl = 4'bx;
                    $display("[ALUCONTROL][%2d] Warning unkown operation [%2d]",
                        $time, ALUOp);
                end
        endcase
    end //always
endmodule

