.data 
	msg_1: .asciiz "Por favor ingrese el primer entero: "
	msg_2: .asciiz "Por favor ingrese el segundo entero: "
	msg_diff: .asciiz "La diferencia es: "
	msg_par: .asciiz " (Par)"
	msg_impar: .asciiz " (Impar)"
	msg_primer_entero: .asciiz "Nuevo primer entero: "
	msg_segundo_entero: .asciiz "Nuevo segundo entero: "
	msg_salto_linea: .asciiz "\n"
	
.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Solicitar primer entero
		la $a0, msg_1 # Carga la direccion de la cadena de texto
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		# Leer primer entero
		jal leer_integer # Llamada a subrutina leer_integer
		move $s0, $v0 # $s0=$v0
		
		# Solicitar segundo entero
		la $a0, msg_2 # Carga la direccion de la cadena de texto
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		# Leer segundo entero
		jal leer_integer # Llamada a subrutina leer_integer
		move $s1, $v0 # $s1=$v0
		
		move $a1, $s0 # $a1=$s0 (copia valor primer entero ingresado)
		move $a2, $s1 # $a2=$s1 (copia valor segun entero ingresado)
		jal diferencia_absoluta #calcular diferencia absoluta
		
		move $t0, $v0 # $t0=$v0 (copia valor diferencia_absoluta)
		la $a0, msg_diff # Carga la direccion de la cadena de texto
		jal imprimir_string # Llamada a subrutina imprimir_string
		
		move $a0, $t0 # $a0=$t0 (copia valor)
		jal imprimir_integer # Llamada a subrutina imprimir_integer
		
		move $a3, $t0 # $a3=$t0 (copia valor diferencia_absoluta)
		jal par_impar # Llamada a subrutina par_impar
		
		move $a0, $t0 # $a0=$t0 (copia valor diferencia_absoluta)
		move $a1, $s0 # $a1=$s0 (copia valor primer entero ingresado)
		move $a2, $s1 # $a2=$s1 (copia valor segun entero ingresado)
		move $a3, $v0 # $a3=$v0 (copia valor par_impar (0=par, 1=impar))
		jal primer_segundo_entero # Llamada a subrutina primer_segundo_entero
		
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
			jr $ra # Retorno
		end_if:
			sub $v0, $a2, $a1 # $v0=$a2-$a1
			jr $ra # Retorno
	
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
			li $v0, 0 # $v0=0 (par)
			jr $ra # Retorno
		end_if_par_impar:
			li $v0, 4 # Carga codigo 4 (print_string) en $v0
			la $a0, msg_impar # Carga la direccion de la cadena de texto
			syscall # Imprime la cadena de texto
			li $v0, 1 # $v0=1 (impar)
			jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: primer_segundo_entero
	# Args: $a0 (diferencia_absoluta), $a1 (primer entero ingresado), $a2 (segundo entero ingresado), $a3 (flag par/impar)
	# Efecto Secundario: Imprime texto y valor de nuevo primer/segundo entero
	#----------------------------------------------------	
	primer_segundo_entero:
		move $t2, $a0 # $t2=$a0 (copia valor diferencia_absoluta)
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, msg_salto_linea # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		if_primer_entero:
			beq $a3, 1, end_if_primer_entero # ($a3==1) => (impar) -> end_if_primer_entero
			li $v0, 4 # Carga codigo 4 (print_string) en $v0
			la $a0, msg_primer_entero # Carga la direccion de la cadena de texto
			syscall # Imprime la cadena de texto
			add $t5, $a1, $t2 # $t5=$a1+$t2 (primer_entero_ingresado + diferencia_absoluta)
			li $v0, 1 # Carga codigo 1 (print_int) en $v0
			move $a0, $t5 # $a0=$t5 (copia valor)
			syscall # Imprime $t5
			jr $ra # Retorno
		end_if_primer_entero:
			li $v0, 4 # Carga codigo 4 (print_string) en $v0
			la $a0, msg_segundo_entero # Carga la direccion de la cadena de texto
			syscall # Imprime la cadena de texto
			add $t5, $a2, $t2 # $t5=$a2+$t2 (segundo_entero_ingresado + diferencia_absoluta)
			li $v0, 1 # Carga codigo 1 (print_int) en $v0
			move $a0, $t5 # $a0=$t5 (copia valor)
			syscall # Imprime $t5
			jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: imprimir_string
	# Args: $a0 (msj)
	# Efecto Secundario: Imprime mensaje
	#----------------------------------------------------
	imprimir_string:
    		li $v0, 4 # Carga codigo 4 (print_string) en $v0
    		syscall # Imprime la cadena de texto
    		jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: imprimir_integer
	# Args: $a0 (numero)
	# Efecto Secundario: Imprime numero
	#----------------------------------------------------
	imprimir_integer:
    		li $v0, 1 # Carga codigo 1 (print_int) en $v0
    		syscall # Imprime numero
    		jr $ra # Retorno
	
	#----------------------------------------------------
	# Subrutina: leer_integer
	# Ret: $v0 (valor ingresado por usuario
	#----------------------------------------------------
	leer_integer:
    		li $v0, 5 # Carga codigo 5 (read_int) en $v0
    		syscall # Carga entero 
    		jr $ra # Retorno
		
		
				
		
