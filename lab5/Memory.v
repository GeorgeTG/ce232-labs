/*****************************************
 *             Data Memory               *
 *          George T. Gougoudis          *
 *****************************************/

module Memory #( parameter SIZE = 1024 ) (
        input wire ReadEnable,
        input wire WriteEnable,
        input wire Clock,
        input wire [31 : 0]Address,
        input wire [31 : 0]DataIn,

        output wire [31 : 0]DataOut
    );

    reg [31 : 0] data[SIZE-1 : 0];

    assign DataOut =
        (~WriteEnable && ReadEnable) ?
            data[Address[11:0]] : 32'bx; //TODO: add log2(SIZE)

    always @(negedge Clock) begin
        if( ~ReadEnable && WriteEnable) begin
            data[Address[11:0]] <= DataIn;

            $display("[MEMORY][%4d] : Wrote %2d to %2d",
                $time,
                DataIn,
                Address
            );
        end
    end

endmodule









