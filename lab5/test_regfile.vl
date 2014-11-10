`timescale 1ns/1ns

module RegisterFile_tbench();

    reg [4 : 0] raA;
    reg [4 : 0] raB;
    reg [4 : 0] wa;
    reg [31 : 0] wd;
    wire  [31 : 0] rdA;
    wire  [31 : 0] rdB;
    reg wen;
    
    reg reset, clock;
    

    RegisterFile RegisterFile_t (clock, reset, raA, raB, wa, wen, wd, rdA, rdB);

    always begin
      #5
      clock = ~clock;
    end
  
    initial begin
        clock = 1'b0;
        reset = 1'b1;
        
        #2
        reset = 1'b0;
        
        #2
        reset = 1'b1; //normal state
        
        #6
        wen = 1'b1;
        wd = 32'b101101111;
        wa = 5'b10;
        
        
        #5
        wen = 1'b0;
        raA = wa;
        
        
    end
endmodule


