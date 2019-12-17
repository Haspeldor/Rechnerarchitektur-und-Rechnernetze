################################################################################
# Funktion multiply: multipliziert 2 Integer-Werte durch Addition
# Parameter: $a0 = Faktor 1, $a1 = Faktor 2
# Rueckgabe: $v0 = Produkt $a0 * $a1
################################################################################

.text

multiply:
    li      $t0, 0                    # $t0 = 0
    li      $t1, 1                    # $t1 = 1
    abs     $t2, $a1                  # $t2 = |b|

mult_loop_begin:
    bgt     $t1, $t2, mult_loop_end   # while (i <= |b|) {
    add     $t0, $t0, $a0             #     p = p + a
    addi    $t1, $t1, 1               #     i = i + 1
    j mult_loop_begin                 # }

mult_loop_end:
    bgez    $a1, mult_loop_ret        # if (b < 0) {
    neg     $t0, $t0                  #     p = -p
                                      # }
mult_loop_ret:
    move    $v0, $t0                  # $v0 = $t0
    jr $ra                            # return

################################################################################
# Funktion pow1: potenziert 2 Integer-Werte
# Parameter: $a0 = Basis, $a1 = Exponent
# Rueckgabe: $v0 = $a0 hoch $a1
################################################################################

.text

pow1:

    addi $t1, $zero, 1

    bne $a1, $t1, check_zero_pow   # wenn exponent gleich 1, gib basis zurÃ¼ck
    move $v0, $a0
    jr $ra

    check_zero_pow:
    
    bne $a1, $zero, calculate_pow   # wenn exponent gleich 0, gib 1 zurÃ¼ck                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    move $v0, $t1
    jr $ra

    calculate_pow:
    
    addi $sp, $sp, -12            # Stack fuer 2 Eintraege reservieren
    sw $ra, 8($sp)		  # $ra,
    sw $a1, 4($sp)		  # $a1,
    sw $a0, 0($sp)                # $a0 sichern
    
    move $a1, $a0		# setze a1 auf a0
    
    jal multiply		  # errechne basis hoch 2
    
    lw $a0, 0($sp)                # $a0,
    lw $a1, 4($sp)               # $a1 ,
    lw $ra, 8($sp)		  # $ra wieder laden
    addi $sp, $sp, 12             # stack wiederherstellen
    
    move $t4, $v0		# setze t4 auf ergebnis basis mal basis

    addi $sp, $sp, -16            # Stack fuer 4 Eintraege reservieren
    sw $t4, 12($sp)		  # $t4,
    sw $a0, 8($sp)                # $a0,
    sw $a1, 4($sp)                # $a1 und
    sw $ra, 0($sp)                # $ra auf dem Stack sichern

    move $a0, $t4		  # wähle x hoch 2 als neue basis
    srl $a1, $a1, 1		  # teile exponent durch 2

    jal pow1

    lw $ra, 0($sp)                # $ra,
    lw $a1, 4($sp)                # $a1,
    lw $a0, 8($sp)                # $a0,
    lw $t4, 12($sp)               # $t4 wieder laden
    addi $sp, $sp, 16             # stack wiederherstellen

    addi $t2, $zero, 2		 
    div $a1, $t2                  # mod 2, test auf gerade / ungerade
    mfhi $t3                      # temp for the mod

    addi $t1, $zero, 1
    bne $t3, $t1, skip_multiply_pow	# wenn ungerade, multipliziere nochmal mit x
    move $a1, $a0			# ursprüngliche basis
    move $a0, $v0			# e
    
    addi $sp, $sp, -4            # Stack fuer 1 Eintrag reservieren
    sw $ra, 0($sp)		  # $ra
    
    jal multiply		  # errechne e * x
    
    lw $ra, 0($sp)               # $ra
    addi $sp, $sp, 4             # stack wiederherstellen

    skip_multiply_pow:			# ausgabe
    jr $ra

################################################################################
# Hauptprogramm
################################################################################

.text
.globl main

main:
    li $v0, 4             # Eingabeaufforderung fuer Basis
    la $a0, strBase
    syscall
    li $v0, 5             # Basis von Tastatur einlesen -> $t0
    syscall
    move $t0, $v0

    li $v0, 4             # Eingabeaufforderung fuer Exponent
    la $a0, strExp
    syscall
    li $v0, 5             # Exponent von Tastatur einlesen -> $t1
    syscall
    move $t1, $v0

    move $a0, $t0         # Argumente ($a0 = Basis, $a1 = Exponent)
    move $a1, $t1         # fuer Aufruf von pow1 vorbereiten
    jal pow1              # Aufruf von pow1
    move $t0, $v0         # Ergebnis -> $t0

    li $v0, 4             # Ergebnis ausgeben
    la $a0, strRes
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, strNewline
    syscall

    li $v0, 10            # Exit
    syscall

.data

strBase:    .asciiz "\nBasis? "
strExp:     .asciiz "\nExponent? "
strRes:     .asciiz "\nErgebnis: "
strNewline: .asciiz "\n"
