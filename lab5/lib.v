
module mux2to1
#( parameter N = 1 )
(
        input wire [N -1 : 0] InputA,
        input wire [N -1 : 0] InputB,
        input wire Select,

        output reg [N -1 : 0] Out
);

    always @(InputA, InputB, Select) begin
        case(Select)
            0 : Out = InputA;
        1 : Out = InputB;

            default: Out = InputA;
        endcase
    end
endmodule

module PCPlus4(
        input wire [31 : 0] PC,

        output wire [31 : 0] PC_plus4
    );

    assign PC_plus4 = PC + 4;
endmodule
