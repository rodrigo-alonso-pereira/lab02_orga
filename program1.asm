.data 
	D: .space 40 # Espacion para 10 enteros
	inicio: .asciiz "["
	mensaje: .asciiz "] Loop finalizado"
	espacio: .asciiz ", "

.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Inicializacion de variables
		addi $s0, $zero, 0 # a=0
		addi $s1, $zero, 5 # b=5
		la $s2, D # base_address D[]
		addi $t0, $zero, 10 # temporal = 10
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, inicio # Carga la direccion de la cadena de texto en mensaje
		syscall # Imprime la cadena de texto
		while:
			bge $s0, $t0, end_while # a >= 10
			sll $t1, $s0, 2 # $t1 = 4 * a (byte offset)
			add $t2, $s2, $t1 # Address of array D[a] = Base + (4 * Posicion)
			add $t3, $s1, $s0 # b + a
			sw $t3, 0($t2) # D[a] = b + a
			addi $s0, $s0, 1 # a += 1
			jal imprimirNumero
			j while # va a etiqueta while	
		end_while:
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, mensaje # Carga la direccion de la cadena de texto en mensaje
		syscall # Imprime la cadena de texto
		# Fin programa
		li $v0, 10 # Carga codigo 10 (exit) en $v0
		syscall # Termina el programa
	
	#----------------------------------------------------
	# Subrutina: imprimirNumero
	# Args: $a0 (numero)
	# Efecto Secundario: Imprime numero e imprime un texto
	#----------------------------------------------------	
	imprimirNumero:
		li $v0, 1 # Carga codigo 1 (print_int) en $v0
		add $a0, $t3, $zero # Imprime registro $t3
		syscall # Imprime el entero
		
		# Imprime espacio
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, espacio # Carga la direccion de la cadena de texto en espacio
		syscall # Imprime la cadena de texto
		
		jr $ra	 
