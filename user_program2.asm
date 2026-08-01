# Base Address: 0x1000 (User RAM)

# -- Initialization --
addi $1, $0, 6         # 0x20010006 | number 5 changed to 6
ori  $2, $0, 10        # 0x3402000A
xori $3, $2, 15        # 0x3843000F

# -- ALU Operations --
add  $4, $1, $2        # 0x00222020
sub  $5, $2, $1        # 0x00412822
and  $6, $4, $5        # 0x00853024
or   $7, $1, $2        # 0x00223825
xor  $8, $1, $2        # 0x00224026
slt  $9, $1, $2        # 0x0022482A

# -- Memory Data Operations --
addi $10, $0, 0x1000   # 0x200A1000
sw   $4, 128($10)      # 0xAD440080
lw   $11, 128($10)     # 0x8D4B0080

# -- Branch and Jump Operations --
beq  $1, $5, label_neq # 0x10250001
add  $12, $0, $0       # 0x00006020

label_neq:
bne  $1, $2, label_end # 0x14220001
add  $12, $0, $0       # 0x00006020

label_end:
j    label_end         # 0x08000410