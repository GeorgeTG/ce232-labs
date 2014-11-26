`include "constants.h"
`timescale 1ns/1ps

// Small ALU. Inputs: inA, inB. Output: out.
// Operations: bitwise and (op = 0)
//             bitwise or  (op = 1)
//             addition (op = 2)
//             subtraction (op = 6)
//             slt  (op = 7)
//             nor (op = 12)
module ALU (out, inA, inB, op);
  parameter N = 8;
  output [N-1:0] out;
  input  [N-1:0] inA, inB;
  input    [3:0] op;

  assign out =
			(op == 4'b0000) ? inA & inB :
			(op == 4'b0001) ? inA | inB :
			(op == 4'b0010) ? inA + inB :
			(op == 4'b0110) ? inA - inB :
			(op == 4'b0111) ? ((inA < inB)?1:0) :
			(op == 4'b1100) ? ~(inA | inB) :
			'bx;

  assign zero = (out == 0);
endmodule


// Memory (active 1024 words, from 10 address lsbs).
// Read : disable wen, enable ren, address addr, data dout
// Write: enable wen, disable ren, address addr, data din.
module Memory (clock, reset, ren, wen, addr, din, dout);
  input  clock, reset;
  input  ren, wen;
  input  [31:0] addr, din;
  output [31:0] dout;

  reg [31:0] data[4095:0];
  wire [31:0] dout;

  always @(ren or wen)
    if (ren & wen)
      $display ("\nMemory ERROR (time %0d): ren and wen both active!\n", $time);

  always @(posedge ren or posedge wen) begin
    if (addr[31:10] != 0)
      $display("Memory WARNING (time %0d): address msbs are not zero\n", $time);
  end

  assign dout = ((wen==1'b0) && (ren==1'b1)) ? data[addr[9:0]] : 32'bx;

  /* Write memory in the negative edge of the clock */
   always @(negedge clock) begin
       if (reset == 1'b1 && wen == 1'b1 && ren==1'b0) begin
            $display("[%4d] [MEMORY]  Writing: %0d at [%0d]", $time, din, addr[9:0]);
            data[addr[9:0]] = din;
        end
   end

endmodule


// Register File. Read ports: address raA, data rdA
//                            address raB, data rdB
//                Write port: address wa, data wd, enable wen.
module RegFile (clock, reset, raA, raB, wa, wen, wd, rdA, rdB);
  input clock, reset;
  input   [4:0] raA, raB, wa;
  input         wen;
  input  [31:0] wd;
  output [31:0] rdA, rdB;

  reg [31:0] data[31:0];

  wire [31:0] rdA = data[raA];
  wire [31:0] rdB = data[raB];

  // Make sure  that register file is only written at the negative edge of the clock
  always @(negedge clock) begin
       if (reset == 1'b1 && wen == 1'b1 && wa != 5'b0) begin
            $display("[%4d] [REGFILE] Writing: %0d at [%0d]", $time, wd, wa);
            data[wa] =  wd;
        end
   end

endmodule


// Forwarding Unit. Read ports: iD/EX RegisterRt
//                              ID/EX RegisterRS
//                              EX/MEM RegisterRd
//                              EX/MEM RegWrite
//                              MEM/WB RegisterRd
//                              MEM/WB RegWrite
//                 Write Ports: ForwardA
//                              ForwardB

module ForwardingUnit
(
        input wire [4:0] ID_EX_RegisterRt,
        input wire [4:0] ID_EX_RegisterRs,
        input wire [4:0] EX_MEM_RegisterRd,
        input wire EX_MEM_RegWrite,
        input wire MEM_WB_RegWrite,
        input wire [4:0] MEM_WB_RegisterRd,
        output reg [1:0] ForwardA,
        output reg [1:0] ForwardB
);

    always @*
        if (MEM_WB_RegWrite &&
                MEM_WB_RegisterRd &&
                (MEM_WB_RegisterRd == ID_EX_RegisterRs) &&
                ((EX_MEM_RegisterRd != ID_EX_RegisterRs) ||
                (~EX_MEM_RegWrite)))
            ForwardA = 2'b01;

        else if( EX_MEM_RegWrite &&
            EX_MEM_RegisterRd &&
            (EX_MEM_RegisterRd == ID_EX_RegisterRs))
            ForwardA = 2'b10;

        else
            ForwardA = 2'b00;

    always @*
        if (MEM_WB_RegWrite &&
                MEM_WB_RegisterRd &&
                (MEM_WB_RegisterRd == ID_EX_RegisterRt) &&
                ((EX_MEM_RegisterRd != ID_EX_RegisterRt) ||
                (~EX_MEM_RegWrite) ))
            ForwardB = 2'b01;


        else if ( EX_MEM_RegWrite &&
            EX_MEM_RegisterRd &&
            (EX_MEM_RegisterRd == ID_EX_RegisterRt))
            ForwardB = 2'b10;

        else
            ForwardB = 2'b00;

endmodule


module ControlHazardDetectionUnit
(
       input wire Branch,
       input wire ID_EX_RegWrite,
       input wire [4:0] IF_ID_RegisterRs,
       input wire [4:0]  IF_ID_RegisterRt,
       input wire [4:0] ID_EX_RegisterRd,

       output reg Stall
);

    always@*
        if ( ID_EX_RegWrite &&
            Branch &&
            ((IF_ID_RegisterRt == ID_EX_RegisterRd) ||
             (IF_ID_RegisterRs == ID_EX_RegisterRd))   )
                Stall = 1'b1;
        else
            Stall = 1'b0;
endmodule

module ControlForwardingUnit
(
        input wire Branch,
        input wire EX_MEM_RegWrite,
        input wire [4:0] EX_MEM_RegWriteAdress,
        input wire [4:0] IF_ID_RegisterRs,
        input wire [4:0] IF_ID_RegisterRt,

        output reg ControlForwardA,
        output reg ControlForwardB
);

    always@(Branch, EX_MEM_RegWriteAdress,EX_MEM_RegWrite, IF_ID_RegisterRs)
        if ( Branch && EX_MEM_RegWrite &&
         (EX_MEM_RegWriteAdress == IF_ID_RegisterRs))
            ControlForwardA = 1'b1;
        else
            ControlForwardA = 1'b0;

    always@(Branch, EX_MEM_RegWriteAdress, EX_MEM_RegWrite, IF_ID_RegisterRt)
        if ( Branch && EX_MEM_RegWrite &&
         (EX_MEM_RegWriteAdress == IF_ID_RegisterRs))
            ControlForwardB = 1'b1;
        else
            ControlForwardB = 1'b0;


endmodule

// Hazard Detection. Read ports: iD/EX RegisterRt
//                              IF/ID RegisterRS
//                              IF/ID RegisterRt
//                              ID/EX MemRead
//                 Write Ports: ForwardA
//                              ForwardB

module HazardDetectionUnit
(
        input wire [4:0] ID_EX_RegisterRt,
        input wire  ID_EX_MemRead,
        input wire [4:0] IF_ID_RegisterRt,
        input wire [4:0] IF_ID_RegisterRs,


        output reg Stall
);
    always@*
        if (ID_EX_MemRead &&
           ( (ID_EX_RegisterRt == IF_ID_RegisterRs) ||
             (ID_EX_RegisterRt == IF_ID_RegisterRt) ))
                Stall = 1'b1;
        else
            Stall = 1'b0;

endmodule

