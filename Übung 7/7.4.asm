################################################################################
# mult
# Funktion mult: multipliziert 2 Integer-Werte durch Addition
# Parameter: $a0 = a, $a1 = b
# RÃ¼ckgabe: $v0 = Produkt $a0 * $a1

# pow
# berechnet die Potenz
# Parameter: $a0 = Basis, $a1 = Exponent
# RÃ¼ckgabe: $v0 = Basis hoch Exponent
################################################################################
	.text
multiplikation:
        li      $t0, 0                  # $t0 = 0
        li      $t1, 1                  # $t1 = 1
        abs     $t2, $a1                # $t2 = |b|

mult_loop_begin:
        bgt     $t1, $t2, mult_loop_end # while (i <= |b|) {
        add     $t0, $t0, $a0           #     p = p + a
        addi    $t1, $t1, 1             #     i = i + 1
        j mult_loop_begin               # }

mult_loop_end:
        bgez    $a1, mult_loop_ret      # if (b < 0) {
        neg     $t0, $t0                #     p = -p
                                        # }
mult_loop_ret:
        move    $v0, $t0                # $v0 = $t0        
        jr $ra                          # return
	

pow:
    bne $a1, $zero, pow_not_zero 	# falls der exponent 0 ist, gib sofort 1 zurueck
    addi $v0, $zero, 1
    jr $ra
    
    pow_not_zero:
    addi $sp, $sp, -4			# ich sichere die 4 register s0 bis s3, 
    sw $s0, 0($sp)			# damit beim loop nicht immer wieder temporäre 
    addi $sp, $sp, -4			# register gesichert werden müssen
    sw $s1, 0($sp)
    addi $sp, $sp, -4
    sw $s2, 0($sp)
    addi $sp, $sp, -4
    sw $s3, 0($sp)
    addi $sp, $sp, -4
    sw $ra, 0($sp)			# auch die rücksprungadresse muss gerettet werden
    
    addi $s0, $zero, 1			# s0 ist hier der zaehler für den exponenten, wird auf 1 gesesetzt
    move $s1, $a0 			# s1 soll am ende das ergebnis sein, welches zurueckgegeben wird
    move $s2, $a0 			# s2 nimmt den wert der basis an
    move $s3, $a1 			# s3 nimmt den wert des exponenten an

    pow_loop:				# wiederholt entsprechend oft dem exponenten
    	bge $s0, $s3, pow_loop_exit	# wenn zähler gleich exponent, brich ab
    	
    	move $a0, $s1			# bereite werte für multiplikation vor
    	move $a1, $s2			
    	jal multiplikation		# fuehre multiplikation durch
    	
    	move $s1, $v0			# setze das resultat auf das ergebniss der multiplikation
    	addi $s0, $s0, 1		# erhoehe zaehler um 1
    	j pow_loop			# starte das loop von neuem
    	
    pow_loop_exit:			# ende der prozedur, nach dem loop
    	move $v0, $s1			# setze den ausgabewert auf das gesamtresultat
    	
    	lw $ra, 0($sp)			# die werte die gerettet wurdem müssen wieder geladen werden
    	addi $sp, $sp, 4
    	lw $s3, 0($sp)
    	addi $sp, $sp, 4
    	lw $s2, 0($sp)
    	addi $sp, $sp, 4
    	lw $s1, 0($sp)
    	addi $sp, $sp, 4
    	lw $s0, 0($sp)
    	addi $sp, $sp, 4
    	
    	jr $ra				# rücksprung zum aufruf
    


################################################################################
# Hauptprogramm
################################################################################
	.text
	.globl main
main:

	li      $v0, 4			# Eingabeaufforderung fÃ¼r Basis a ausgeben
	la      $a0, prompt1
	syscall
	li      $v0, 5			# Faktor a von Tastatur einlesen ...
	syscall
	move    $t0, $v0		# ... und in $t0 sichern

	li      $v0, 4			# Eingabeaufforderung fÃ¼r Exponent b ausgeben
	la      $a0, prompt2
	syscall
	li      $v0, 5			# Faktor b von Tastatur einlesen ...
	syscall
	move    $t1, $v0		# ... und in $t1 sichern

	move    $a0, $t0		# Argumente fÃ¼r Aufruf von pow vorbereiten
	move    $a1, $t1         
	jal     pow			# Aufruf von pow
	move    $t0, $v0		# Ergebnis in $t0 sichern

	li      $v0, 1			# Ergebnis ausgeben
	move    $a0, $t0
	syscall

	li      $v0, 10			# Programm beenden
	syscall

	 .data
prompt1: .asciiz "Faktor a = "
prompt2: .asciiz "Faktor b = "
