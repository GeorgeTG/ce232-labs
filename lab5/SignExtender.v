module SignExtender(
    input wire clock,
    input wire [15 : 0] Immediate,
    output reg [31 : 0] Extended
);

        always @(posedge clock)
            Extended[31 : 0] = { {16{Immediate[15]}}, Immediate[15 : 0] };

endmodule
