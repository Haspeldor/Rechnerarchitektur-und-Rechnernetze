.text	
	la $a0,ask 			# lädt ask string in register
        li $v0,4			# bereitet syscall vor, um string anzuzeigen
        syscall				# ruft syscall auf
        
        li $v0,5			# bereitet syscall vor, zahl einzulesen
        syscall				# ruft syscall auf
        
        beq $v0, $zero, exit1		# überprüft ob eingegebene zahl 0 ist, dann zu exit1
        
        slt $t1, $v0, $zero		# überprüft ob eingegebene zahl kleiner 0 ist
        bne $t1, $zero, exit2		# wenn ja zu exit2
        
        la $a0,ret3			# lädt ret3 string in register
        li $v0,4			# bereitet syscall vor, um string anzuzeigen
        syscall				# ruft syscall auf
        j exit3				# springt zu exit3 um das programm zu beenden
        
        exit1:
        	la $a0,ret1			# lädt ret1 string in register
        	li $v0,4			# bereitet syscall vor, um string anzuzeigen
        	syscall				# ruft syscall auf
        	j exit3				# springt zu exit3 um das programm zu beenden
        	
        exit2:
        	la $a0,ret2			# lädt ret2 string in register
        	li $v0,4			# bereitet syscall vor, um string anzuzeigen
        	syscall				# ruft syscall auf
        
        exit3:					# ende des programms
	
.data
	ask:   .asciiz "Bitte geben sie eine ganze Zahl ein:\n"
      	ret1:  .asciiz "Gleich 0"	
      	ret2:  .asciiz "Kleiner als 0"	
      	ret3:  .asciiz "Größer als 0"	