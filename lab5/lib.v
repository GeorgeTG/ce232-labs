
module mux2to1
#( parameter DATA_WIDTH = 1 )
(
        input wire [DATA_WIDTH-1 : 0] InputA,
        input wire [DATA_WIDTH-1 : 0] InputB,
        input wire Select,

        output reg [DATA_WIDTH-1 : 0] Out
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
        input wire Reset,
        input wire [31 : 0] PC,

        output wire [31 : 0] PC_plus4
    );

    assign PC_plus4 = ~Reset? 0 : PC + 4;

endmodule

module FullAdder
#( parameter DATA_WIDTH = 32 )
(
        input wire [DATA_WIDTH-1 : 0] InputA,
        input wire [DATA_WIDTH-1 : 0] InputB,

        output reg [DATA_WIDTH-1 : 0] Sum,
        output reg Carry
);

        always @(InputB or InputA) begin
            {Carry, Sum} = InputA + InputB;
        end
endmodule

module LeftShifter
#( parameter DATA_WIDTH = 32, parameter SHIFT_COUNT = 2 )
(
        input wire [DATA_WIDTH-1 : 0] Input,

        output wire [DATA_WIDTH-1 : 0] Out
);

        assign Out = Input << (SHIFT_COUNT);

endmodule


module SignExtender(
    input wire [15 : 0] Immediate,
    output wire [31 : 0] Extended
);

           assign Extended[31 : 0] = { {16{Immediate[15]}}, Immediate[15 : 0] };

endmodule

