# Base Address: 0x0000 (Boot ROM)

# -- Initialize addresses and variables --
addi $8, $0, 0x1000   # 0x20081000 | $8 = RAM base address
addi $9, $0, 17       # 0x20090011 | $9 = Number of user program instructions (17 lines)
addi $10, $0, 0x2000  # 0x200A2000 | $10 = Accelerator data register address
addi $11, $0, 0x2004  # 0x200B2004 | $11 = Accelerator control register address

# -- Reset the hash accelerator accumulator --
addi $14, $0, 1       # 0x200E0001 | $14 = 1
sw   $14, 0($11)      # 0xAD6E0000 | Write 1 to the control register to clear the hash

# -- Loop to read from RAM and send to hash --
loop_start:
lw   $14, 0($8)       # 0x8D0E0000 | Read one instruction from RAM
sw   $14, 0($10)      # 0xAD4E0000 | Send instruction to accelerator (XOR operation)
addi $8, $8, 4        # 0x21080004 | Go to the next RAM address (four bytes ahead)
addi $14, $0, 1       # 0x200E0001 | $14 = 1
sub  $9, $9, $14      # 0x012E4822 | Decrement loop counter ($9 = $9 - 1)
bne  $9, $0, loop_start # 0x1520FFFA | If counter is not zero, jump back to loop_start

# -- Verify program validity --
lw   $14, 0($10)      # 0x8D4E0000 | Read the final calculated hash from the accelerator
addi $15, $0, 0x004C  # 0x200F004C | $15 = Memory address to read the reference hash
lw   $15, 0($15)      # 0x8DEF0000 | Load the reference hash into $15
bne  $14, $15, halt   # 0x15CF0002 | If hashes are not equal, jump to halt label

# -- Successful Boot Scenario --
# DROP_PRIV instruction (Transition to User Mode)
# This is an R-type instruction with Opcode=0 and Funct=12, equivalent to the following machine code:
.word 0x0000000C      # 0x0000000C | Execute DROP_PRIV instruction
j    0x1000           # 0x08000400 | Jump to the beginning of the user program in RAM

# -- Tampered Program Scenario (System Halt) --
halt:
j    halt             # 0x08000012 | Infinite loop (Halt processor in Secure Mode)

# -- Data --
.word 0x20861C1F      # 0x20861C1F | (Address 0x004C) Reference hash value of the user program