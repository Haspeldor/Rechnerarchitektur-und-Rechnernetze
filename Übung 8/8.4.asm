.eqv print_int     1
.eqv print_string  4
.eqv read_int      5
.eqv exit         10
.eqv read_char    12

### Binäre Suche #############################################################
.text
binsearch:
##############################################################################
# $a0 - Zahl n
# $a1 - Untergrenze lo
# $a2 - Obergrenze hi
# $v0 - Position von n in list falls gefunden, -1 falls nicht gefunden
##############################################################################

addi $sp, $sp, -4
sw $ra, 0($sp)				# speichert R�cksprungadresse
bgt $a1, $a2, binsearch_not_found	# falls lo > hi -> nichts gefunden

sub $t0, $a2, $a1			# t0 = hi - lo
srl $t0, $t0, 1				# t0 = t0 / 2
add $t1, $a1, $t0			# t1 = lo + t0
sll $t2, $t1, 2				# t2 = t1 * 4
lw $t3, list($t2)			# t3 = list[t2]
beq $t3, $a0, binsearch_found		# if t3 == a0: found
blt $t3, $a0, binsearch_upper_half	# if t3 < a0: search_upper

binsearch_lower_half:
#####################
subi $a2, $t1, 1
jal binsearch
j binsearch_return

binsearch_upper_half:
#####################
addi $a1, $t1, 1
jal binsearch
j binsearch_return

binsearch_found:
################
move $v0, $t1
j binsearch_return

binsearch_not_found:
####################
li $v0, -1

binsearch_return:
#################
addi $sp, $sp, 4
lw $ra, 0($sp)
jr $ra

### Main #####################################################################
.globl main
main:
##############################################################################

li $v0, print_string
la $a0, input
syscall

li $v0, read_int
syscall
move $a0, $v0

move $a1, $zero
lw $a2, length
subi $a2, $a2, 1
jal binsearch

li $t0, -1
beq $v0, $t0, not_found

found:
######
mul $t0, $v0, 4
lw $a0, list($t0)
li $v0, print_int
syscall

li $v0, print_string
la $a0, success
syscall
j repeat

not_found:
##########
li $v0, print_string
la $a0, failure
syscall

repeat:
#######
li $v0, print_string
la $a0, continue
syscall

# Lese Zeichen
li $v0, read_char
syscall
move $t0, $v0

li $v0, print_string
la $a0, newline
syscall

# Beenden mit 'j'
bne $t0, 'j', main

li $v0, exit
syscall

### Daten ####################################################################
.data
##############################################################################

input:    .asciiz "Welche Zahl? "
continue: .asciiz "Abbrechen? (j/n) "
failure:  .asciiz "Nicht gefunden\n"
success:  .asciiz " gefunden\n"
newline:  .asciiz "\n"

length:   .word 100
list:     .word    1,    4,    9,   16,   25,   36,   49,   64,   81,   100,
          .word  121,  144,  169,  196,  225,  256,  289,  324,  361,   400,
          .word  441,  484,  529,  576,  625,  676,  729,  784,  841,   900,
          .word  961, 1024, 1089, 1156, 1225, 1296, 1369, 1444, 1521,  1600,
          .word 1681, 1764, 1849, 1936, 2025, 2116, 2209, 2304, 2401,  2500,
          .word 2601, 2704, 2809, 2916, 3025, 3136, 3249, 3364, 3481,  3600,
          .word 3721, 3844, 3969, 4096, 4225, 4356, 4489, 4624, 4761,  4900,
          .word 5041, 5184, 5329, 5476, 5625, 5776, 5929, 6084, 6241,  6400,
          .word 6561, 6724, 6889, 7056, 7225, 7396, 7569, 7744, 7921,  8100,
          .word 8281, 8464, 8649, 8836, 9025, 9216, 9409, 9604, 9801, 10000
