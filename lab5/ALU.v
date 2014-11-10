module ALU
#( parameter DATA_WIDTH = 32 )
(
        input wire [DATA_WIDTH-1 : 0] InputA,
        input wire [DATA_WIDTH-1 : 0] InputB,
        input wire [3 : 0] Op,

        output reg [DATA_WIDTH-1 : 0] Out,
        output wire Zero
);

        always @(Op, InputA, InputB) begin
            case (Op)
                0: //bitwise AND
                    Out = InputA & InputB;

                1://bitwise OR
                    Out = InputA | InputB;

                2://add
                    Out = InputA + InputB;

                6://sub
                    Out = InputA - InputB;

                7://slt
                    Out = ((InputA < InputB) ? 1 : 0);

                12://nor
                    Out = ~(InputA | InputB);

                default:
                    begin
                        $display("[ALU] [WARN] Unknown Op code: %4d\n", Op);
                        Out = {DATA_WIDTH{1'bx}};
                    end
            endcase
        end //always

    assign Zero = (Out == 0);

endmodule //ALU


