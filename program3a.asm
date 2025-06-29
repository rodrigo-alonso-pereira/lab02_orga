.data 
	msg_1: .asciiz "Por favor ingrese el primer entero: "
	msg_2: .asciiz "Por favor ingrese el segundo entero: "
	msg_diff: .asciiz "La diferencia es: "
	msg_par: .asciiz " (Par)"
	msg_impar: .asciiz " (Impar)"
	salto_linea: .asciiz "\n"
	
.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Solicitar primer entero
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, msg_1 # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		
		# Leer primer entero
		li $v0, 5 # Carga codigo 5 (read_int) en $v0
		syscall # Carga primer entero 
		move $s0, $v0 # $s0=$v0
		
		# Solicitar segundo entero
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, msg_2 # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		
		# Leer segundo entero
		li $v0, 5 # Carga codigo 5 (read_int) en $v0
		syscall # Carga primer entero 
		move $s1, $v0 # $s1=$v0
		
		move $a1, $s0 # $a1=$s0 (copia valor)
		move $a2, $s1 # $a2=$s1 (copia valor)
		jal diferencia_absoluta #calcular diferencia absoluta
		
		move $t0, $v0 # $t0=$v0 (copia valor)
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, msg_diff # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		
		li $v0, 1 # Carga codigo 1 (print_int) en $v0
		move $a0, $t0 # $a0=$t1 (copia valor)
		syscall # Imprime $t0
		
		move $a3, $t0 # $a3+$t0 (copia valor)
		
		jal par_impar
		
		# Fin programa
		li $v0, 10 # Carga codigo 10 (exit) en $v0
		syscall # Termina el programa
	
	#----------------------------------------------------
	# Subrutina: diferencia_absoluta
	# Args: $a1 (primer_entero_ingresado), $a2 (segundo_entero_ingresado)
	# Ret: $v0 (abs($a1-$a2))
	#----------------------------------------------------	
	diferencia_absoluta:
		if:
			blt $a1, $a2, end_if # $a1<$a2 -> end_if 
			sub $v0, $a1, $a2 # $v0=$a1-$a2
			jr $ra
		end_if:
			sub $v0, $a2, $a1 # $v0=$a2-$a1
			jr $ra
	
	#----------------------------------------------------
	# Subrutina: par_impar
	# Args: $a3 (diferencia_absoluta)
	# Ret:  $v0 (0 si es par, 1 si es impar)
	# Efecto Secundario: Imprime (Par) o (Impar)
	#----------------------------------------------------		
	par_impar:
		if_par_impar:
			andi $t1, $a3, 1 # $t1 = $a3&1 (Comparacion and bit a bit entre $a1 e 1)
			beq $t1, 1, end_if_par_impar # (($a1&1) == 1) => (impar) -> end_if_par_impar
			li $v0, 4 # Carga codigo 4 (print_string) en $v0
			la $a0, msg_par # Carga la direccion de la cadena de texto
			syscall # Imprime la cadena de texto
			jr $ra
		end_if_par_impar:
			li $v0, 4 # Carga codigo 4 (print_string) en $v0
			la $a0, msg_impar # Carga la direccion de la cadena de texto
			syscall # Imprime la cadena de texto
			jr $ra
