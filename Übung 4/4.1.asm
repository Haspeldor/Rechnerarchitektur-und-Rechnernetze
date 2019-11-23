.text
.globl main

main: 

la $a0,ret1		# gibt erste eingabeauforderung aus	
li $v0,4
syscall	

li $v0, 5		# liest einen int ein
syscall

move $t0,$v0		# speichert eingegeben wert - n in t1, als zähler für loop1
move $t1,$v0		# speichert eingegeben wert - n in t2, als zähler für loop2

loop:			# erstes loop in dem n zahlen eingelsesen werden
ble $t0,$zero,loop2	# überprüft ob zähler kleiner gleich null ist

la $a0,ret2		# gibt zweite eingabeauforderung aus	
li $v0,4
syscall	

li $v0, 5		# liest eine zahl ein
syscall

addi $sp,$sp,-4		# verschiebt stack pointer, um einen wert speichern zu können
sw $v0,0($sp)		# speichert den eingegebenen wert

addi $t0,$t0,-1		# verringert zähler um 1
j loop			# beginnt loop von vorne

loop2:			# zweites loop in dem alle gespeicherten zahlen rückwärts ausgegeben werden
ble $t1,$zero,exit	# überprüft ob zähler2 kleiner gleich null ist

lw $t2,0($sp)		# lädt den zuletzt eingegebenen wert, welcher noch nicht ausgegeben wurde
addi $sp,$sp,4		# verschiebt den stack pointer, um speicherplatz freizugeben

li $v0, 1		# gibt den geladenen wert aus
move $a0,$t2
syscall

la $a0,space		# gibt eine leere zeile aus, zur besseren lesbarkeit	
li $v0,4
syscall	

addi $t1,$t1,-1		# verringert zähler2 um 1
j loop2			# beginnt loop2 von vorne


exit:			# beendet das programm

.data
space:   .asciiz " "
ret1:   .asciiz "Geben sie ein, wie viele Zahlen sie einlesen wollen "
ret2:   .asciiz "Geben sie die nächste Zahl ein "
