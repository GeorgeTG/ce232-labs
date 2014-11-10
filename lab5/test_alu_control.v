`timescale 1ns/1ns

module ALUControl_tbench();
    reg [5 : 0] Function;
    reg [1 : 0] ALUOp;
    wire  [3 : 0] ALUCtrl;

    ALUControl ALUControl_t (Function, ALUOp, ALUCtrl);

    initial begin
        Function = 6'bx;
        ALUOp = 2'b00; //Lw, Sw

        #5
        ALUOp = 2'b01; // beq

        #5
        ALUOp = 2'b10; //Rtype
        Function = 6'b100000; //add

        #5
        Function = 6'b100010; //sub

        #5
        Function = 6'b100100; //AND

        #5
        Function = 6'b100101; //OR

        #5
        Function = 6'b101010; //slt
    end
endmodule


