.data
.text
.align 2
.globl main
main:
	addi $sp, $0, 65408 # FF80

	addi $s0, $0, 128  #screenw = 128
	addi $s1, $0, 126  #screenh = 126

	addi $s2, $0, 64   #snakex = 64
	addi $s3, $0, 63   #snakey = 63

	addi $s4, $0, 1   #xdirection = 1
	addi $s5, $0, 0   #ydirection = 0

	#mult $s0, $s1
	#mflo $t0
	#sll $t0, $t0, 2
	#addi $v0, $0, 9
	#syscall

loop:
    #check for keypress
    lw $t0, 65408($0) #0xFF80 = keyboard ready
    #if keypress, update x,y coordinate
    lw $t0, 65412($0) #0xFF84 = read keyboard character
    addi $t1, $0, 119 #ascii w
    bne $t0, $t1, notw
    beq $s3, $0, endkeypress #if y coord = 0, do nothing
    addi $s4, $0, 0  #xdirection = 0
    addi $s5, $0, -1   #ydirection = -1
    
notw:
    addi $t1, $0, 97 #ascii a
    bne $t0, $t1, nota
    beq $s2, $0, endkeypress #if x coord = 0, do nothing
    addi $s4, $0, -1  #xdirection = -1
    addi $s5, $0, 0   #ydirection = 0
    j endkeypress
nota:
    addi $t1, $0, 115 #ascii s
    bne $t0, $t1, nots
    addi $t2, $0, 126 #assuming monitor width = 126
    beq $s3, $t2, endkeypress #if y coord = 126, do nothing
    addi $s4, $0, 0  #xdirection = 0
    addi $s5, $0, 1   #ydirection = 1
    j endkeypress
nots:
    addi $t1, $0, 100 #ascii d
    bne $t0, $t1, endkeypress
    addi $t2, $0, 128 #assuming monitor width = 128
    beq $s2, $t2, endkeypress #if x coord = 128, do nothing
    addi $s4, $0, 1  #xdirection = 1
    addi $s5, $0, 0   #ydirection = 0
endkeypress:
    sw $0, 65408($0) #set keyboard ready to 0 to get next character

    add $s2, $s2, $s4   #snakex += xdirection
    add $s3, $s3, $s5   #snakey += ydirection

    addi $t1, $0, 1
    addi $t0, $0, 0
    slt $t0, $s2, $0
    beq $t0, $t1, game_over   #snakex < 0
    slt $t0, $s0, $s2
    beq $t0, $t1, game_over   #screenw < snakex
    slt $t0, $s3, $0
    beq $t0, $t1, game_over   #snakey < 0
    slt $t0, $s1, $s3
    beq $t0, $t1, game_over   #screenh < snakey


    #display pixel
    sw $s2, 65424($0) #0xFF90 = monitor x coordinate
    sw $s3, 65428($0) #0xFF94 = monitor y coordinate
    sw $t0, 65432($0) #0xFF98 = monitor color
    sw $0, 65436($0)  #0xFF9c = write pixel
    j loop

game_over:
    j game_over
















