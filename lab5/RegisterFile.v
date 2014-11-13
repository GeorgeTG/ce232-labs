module RegisterFile (
        input wire Clock,
        input wire Reset,
        input wire [4 : 0] ReadAddressA,
        input wire [4 : 0] ReadAddressB,
        input wire [4 : 0] WriteAddress,
        input wire WriteEnable,
        input wire [31 : 0]WriteData,

        output reg [31 : 0] ReadDataA ,
        output reg [31 : 0] ReadDataB
    );

    integer i;
    reg [31 : 0] Registers[31 : 0];

    //Asynchronous Reset, negative edge triggered.
    always @(negedge Reset) begin
        for(i = 0; i < 32; i = i + 1)// y u no i++??
            Registers[i] = 0;
    end //Reset

    //Asynchronous read, Re-read when clock goes high
    always @(ReadAddressA or ReadAddressB or posedge Reset) begin
        ReadDataA = Registers[ReadAddressA];
        ReadDataB = Registers[ReadAddressB];

        $display("[REGFILE] [%4d] ReadDataA %d,ReadDataB%d )\n",
            $time, ReadDataA, ReadDataB);

    end

    //Negative Clock edge triggered, write(WriteEnable and Clock HIGH)
    always @(negedge Clock) begin
        if( WriteEnable && Reset) begin
            Registers[WriteAddress] <= WriteData;

            $display("[REGFILE] [%4d] Wrote data %2d, to %2d (WriteEnable: %d)\n",
                $time, WriteData, WriteAddress, WriteEnable);
        end
    end

endmodule


