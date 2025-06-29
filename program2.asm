.data 
	arr: .word 11, 22, 33, 44
	end:
	suma: .asciiz " + "
	igual: .asciiz " = "

.text
	#----------------------------------------------------
	# Rutina Principal
	#----------------------------------------------------
	main:
		# Inicializacion de variables
		la $s0, arr # base_address arr[] en $s0
		la $s1, end # end_address arr[]
		subu $s1, $s1, $s0 # $s1 - $s0 = Diferencias de direccion fin arr[] e inicial arr[]
		srl $s1, $s1, 2 # $s1 = arrlen, numero de elementos en arr[] (Division por 2^n y n=2, $s1 se divide por 2^2=4)
		addi $t0, $zero, 0 # evensum=0
		addi $s2, $zero, 0 # i=0
		
		for_loop: 
			bge $s2, $s1, end_for_loop # i>=arrlen -> end_for *(i<arrlen)
			
			if: 
				sll $t1, $s2, 2 # $t1 = 4 * a (byte offset)
				add $t2, $s0, $t1 # Address of array D[a] = Base + (4 * Posicion)
				lw $t3, 0($t2) # $t3=arr[i]
				andi $t4, $t3, 1 # $t4 = arr[i]&1 (Comparacion and bit a bit entre $t3 e 1)
				beq $t4, 1, end_if # ((arr[i]&1) == 1) => (impar) -> end_if  *((arr[i]&1)==0)
				add $t0, $t0, $t3 # evensum += arr[i]
				jal imprimirNumero # llamado subrutina
			end_if:
			addi $s2, $s2, 1 # i++
			j for_loop
			
		end_for_loop:
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, igual # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		
		li $v0, 1 # Carga codigo 1 (print_int) en $v0
		add $a0, $t0, $zero # $a0=$t1=evensum
		syscall # Imprime evensum
		
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
		
		li $v0, 4 # Carga codigo 4 (print_string) en $v0
		la $a0, suma # Carga la direccion de la cadena de texto
		syscall # Imprime la cadena de texto
		
		jr $ra	 
		
		
		
		
