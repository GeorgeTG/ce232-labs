
module mux2to1 #( parameter N = 1 ) (
        input wire [N -1 : 0] inA,
        input wire [N -1 : 0] inB,
        input wire select,

        output reg [N -1 : 0] out
    );

    always @(inA, inB, select) begin
        case(select)
            0 : out = inA;
            1 : out = inB;

            default: out = inA;
        endcase
    end
endmodule

