`timescale 1ns/1ns

module ALU_tbench();
    parameter N = 32;

    reg [31 : 0] inA;
    reg [31 : 0] inB;
    wire  [31 : 0] out;
    reg [3 : 0] op;
    wire zero;

    ALU #(.N( N )) ALU_t (inA, inB, op, out, zero);

    initial begin
        //$dumpfile("alu_dumb.vcd");
        //$dumpvars(0, ALU_tbench)
        op = 4'b0; //AND
        inA = 32'b1;
        inB = 32'b11;
        
        #10 
        op = 4'b1; //OR
        inA = 32'b101;
        inB = 32'b010;
        
        #10 
        op = 4'b10; //ADD
        inA = 32'h3;
        inB = 32'h5;
        
        #10
        op = 4'b110; //SUB
        inA = 32'h7;
        inB = 32'h2;
        
        #10
        op = 4'b111; //SLT
        inA = 32'b1;
        inB = 32'b0;
        
        #10
        op = 4'b1100; //NOR
        inA = 32'b1;
        inB = 32'b0;
        
    end
endmodule


