# Base Address: 0x1000 (User RAM)

# -- Initialization --
addi $1, $0, 5         
ori  $2, $0, 10        
xori $3, $2, 15        

# -- ALU Operations --
add  $4, $1, $2        
sub  $5, $2, $1        
and  $6, $4, $5        
or   $7, $1, $2        
xor  $8, $1, $2        
slt  $9, $1, $2        

# -- Memory Data Operations --
addi $10, $0, 0x1000   
sw   $4, 128($10)      
lw   $11, 128($10)     

# -- Branch and Jump Operations --
beq  $1, $5, label_neq 
add  $12, $0, $0       

label_neq:
bne  $1, $2, label_end 
add  $12, $0, $0       

label_end:
j    label_end