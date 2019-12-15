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

    bne $a1, $zero, calculate_pow   # wenn exponent gleich 0, gib 1 zurück
    move $v0, $t1
    jr $ra

    bne $a1, $zero, calculate_pow   # wenn exponent gleich 1, gib basis zurück                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    move $v0, $a0
    jr $ra

    calculate_pow:

    mult $a0, $a0
    mflo $a0
    slr $a1, $a1, 1

    addi $sp, $sp, -12            # Stack fuer 4 Eintraege reservieren
    sw $a0, 8($sp)                # $a0,
    sw $a1, 4($sp)                # $a1 und
    sw $ra, 0($sp)                # $ra auf dem Stack sichern

    jal pow1

    lw $a2, 0($sp)                # $a2,
    lw $a1, 4($sp)                # $a1,
    lw $ra, 8($sp)                # $ra wieder laden

    addi $t2, $t2, 1
    addi $t2, $t2, 2
    div $a1, $t2                  # i mod 2
    mfhi $t3                      # temp for the mod

    bne $t3, $t1, skip_multiply_pow
    mult $v0, $a0

    skip_multiply_pow:
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
