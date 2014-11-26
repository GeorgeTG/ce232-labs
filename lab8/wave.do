onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/cpu0/clock
add wave -noupdate /cpu_tb/cpu0/reset
add wave -noupdate -divider Branch
add wave -noupdate /cpu_tb/cpu0/Branch
add wave -noupdate /cpu_tb/cpu0/branch_rdA
add wave -noupdate /cpu_tb/cpu0/branch_rdB
add wave -noupdate /cpu_tb/cpu0/CtrlForwardA
add wave -noupdate /cpu_tb/cpu0/CtrlForwardB
add wave -noupdate /cpu_tb/cpu0/StallCtrl
add wave -noupdate -divider Basic
add wave -noupdate /cpu_tb/cpu0/PC
add wave -noupdate /cpu_tb/cpu0/instr
add wave -noupdate /cpu_tb/cpu0/ALUInA
add wave -noupdate /cpu_tb/cpu0/ALUInBMux
add wave -noupdate /cpu_tb/cpu0/ALUOut
add wave -noupdate /cpu_tb/cpu0/rdA
add wave -noupdate /cpu_tb/cpu0/rdB
add wave -noupdate /cpu_tb/cpu0/ForwardA
add wave -noupdate /cpu_tb/cpu0/ForwardB
add wave -noupdate /cpu_tb/cpu0/Stall
add wave -noupdate /cpu_tb/cpu0/PCScr
add wave -noupdate /cpu_tb/cpu0/Flush
add wave -noupdate -divider IF_ID
add wave -noupdate -radix hexadecimal /cpu_tb/cpu0/IFID_PCplus4
add wave -noupdate -radix hexadecimal /cpu_tb/cpu0/IFID_instr
add wave -noupdate -divider ID_EX
add wave -noupdate /cpu_tb/cpu0/IDEX_rdA
add wave -noupdate /cpu_tb/cpu0/IDEX_rdB
add wave -noupdate /cpu_tb/cpu0/IDEX_signExtend
add wave -noupdate /cpu_tb/cpu0/IDEX_instr_rt
add wave -noupdate /cpu_tb/cpu0/IDEX_instr_rs
add wave -noupdate /cpu_tb/cpu0/IDEX_instr_rd
add wave -noupdate /cpu_tb/cpu0/IDEX_RegDst
add wave -noupdate /cpu_tb/cpu0/IDEX_ALUSrc
add wave -noupdate /cpu_tb/cpu0/IDEX_ALUcntrl
add wave -noupdate /cpu_tb/cpu0/IDEX_Branch
add wave -noupdate /cpu_tb/cpu0/IDEX_MemRead
add wave -noupdate /cpu_tb/cpu0/IDEX_MemWrite
add wave -noupdate /cpu_tb/cpu0/IDEX_MemToReg
add wave -noupdate /cpu_tb/cpu0/IDEX_RegWrite
add wave -noupdate -divider Registers
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[31]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[30]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[29]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[28]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[27]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[26]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[25]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[24]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[23]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[22]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[21]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[20]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[19]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[18]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[17]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[16]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[15]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[14]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[13]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[12]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[11]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[10]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[9]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[8]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[7]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[6]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[5]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[4]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[3]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[2]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[1]}
add wave -noupdate {/cpu_tb/cpu0/cpu_regs/data[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {71450 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 292
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {106026 ps} {204946 ps}
