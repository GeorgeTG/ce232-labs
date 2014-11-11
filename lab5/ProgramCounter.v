// alwaya
module ProgramCounter
#( parameter DATA_WIDTH = 32 )
(
        input wire Clock,
        input wire Reset,
        input wire [DATA_WIDTH-1 : 0] PC_new,
        output reg [DATA_WIDTH-1 : 0] PC
);

        always @(posedge Clock or negedge Reset) begin
            if (~Reset)
                PC = 0;
            else
                PC = PC_new;
        end

endmodule
