module InstructionMemory
#(parameter SIZE = 4095)
(
        input wire [31:0] ReadAddress,

        output reg [31:0] Instruction
);

        reg [31:0] data[SIZE - 1:0]; //Read-Only

        always @(ReadAddress) begin
            //TODO: maybe check if ReadAddress[31:12]
            Instruction = data[ReadAddress[11:0]];
        end

endmodule
