/*****************************************
 *           Cpu Test Module             *
 *          George T. Gougoudis          *
 *****************************************/

module cpu_tbench;

    localparam REGISTERS = 32;

    reg clock, reset;
    integer i;

    CPU CPU_0
    (
        .Clock(clock),
        .Reset(reset)
    );

    always begin
        #5
        clock = ~clock;
    end

    initial begin

        clock = 1'b1;
        reset = 1'b0;

        $readmemb("out4.mbin", CPU_0.InstructionMemory_0.data);

        #1
        for( i=0; i < REGISTERS; i = i + 1)
            CPU_0.RegisterFile_0.Registers[i] = i;


        reset = 1'b1;

                #100

        for( i=0; i < REGISTERS; i = i + 1)
            $display(" Register[%d] has value %d", i,
                CPU_0.RegisterFile_0.Registers[i]);

    end

endmodule
