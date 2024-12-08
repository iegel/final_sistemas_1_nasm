; Se ingresa una matriz de NxM componentes. La computadora la muestra girada 90° en sentido antihorario.


        global main              ; ETIQUETAS QUE MARCAN EL PUNTO DE INICIO DE LA EJECUCION
        global _start

        extern printf            ;
        extern scanf             ; FUNCIONES DE C (IMPORTADAS)
        extern exit              ;
        extern gets              ; GETS ES MUY PELIGROSA. SOLO USARLA EN EJERCICIOS BASICOS, JAMAS EN EL TRABAJO!!!



section .bss                     ; SECCION DE LAS VARIABLES

numero:
        resd    1                ; 1 dword (4 bytes)

cadena:
        resb    0x0100           ; 256 bytes


caracter:
        resb    1                ; 1 byte (dato)
        resb    3                ; 3 bytes (relleno)

matriz:
	resd	100		 ;  matriz como maximo de 10x10
		
n:
	resd	1		 ;  lado de la matriz (cuadrada)

m:
	resd	1		 ;  lado de la matriz (cuadrada)

f:
	resd	1		 ; fila
		
c:
	resd	1		 ; columna



section .data                    ; SECCION DE LAS CONSTANTES

fmtInt:
        db    "%d", 0            ; FORMATO PARA NUMEROS ENTEROS

fmtString:
        db    "%s", 0            ; FORMATO PARA CADENAS

fmtChar:
        db    "%c", 0            ; FORMATO PARA CARACTERES

fmtLF:
        db    0xA, 0             ; SALTO DE LINEA (LF)

nStr:
	db    "N: ", 0		 ; Cadena N: 

mStr:
	db    "M: ", 0		 ; Cadena N: 

filaStr:
	db    "Fila:", 0	 ;  Cadena Fila:
	
columnaStr:
	db    " Columna:", 0	 ;  Cadena Columna:

cadenaStr:
        db    "Matriz Original: ", 0  


cadenaStr2:
        db    "Matriz girada 90 grados en sentido antihorario: ", 0  



section .text                    ; SECCION DE LAS INSTRUCCIONES
 
leerCadena:                      ; RUTINA PARA LEER UNA CADENA USANDO GETS
        push cadena
        call gets
        add esp, 4
        ret

leerNumero:                      ; RUTINA PARA LEER UN NUMERO ENTERO USANDO SCANF
        push numero
        push fmtInt
        call scanf
        add esp, 8
        ret
    
mostrarCadena:                   ; RUTINA PARA MOSTRAR UNA CADENA USANDO PRINTF
        push cadena
        push fmtString
        call printf
        add esp, 8
        ret

mostrarNumero:                   ; RUTINA PARA MOSTRAR UN NUMERO ENTERO USANDO PRINTF
        push dword [numero]
        push fmtInt
        call printf
        add esp, 8
        ret

mostrarCaracter:                 ; RUTINA PARA MOSTRAR UN CARACTER USANDO PRINTF
        push dword [caracter]
        push fmtChar
        call printf
        add esp, 8
        ret

mostrarSaltoDeLinea:             ; RUTINA PARA MOSTRAR UN SALTO DE LINEA USANDO PRINTF
        push fmtLF
        call printf
        add esp, 4
        ret

salirDelPrograma:                ; PUNTO DE SALIDA DEL PROGRAMA USANDO EXIT
        push 0
        call exit


_start:
main:                            ; PUNTO DE INICIO DEL PROGRAMA
	mov esi, 0                  ; Inicializa el registro `esi` en 0 (usado para índices en matrices).
	mov ebx, 0                  ; Inicializa el registro `ebx` en 0 (contador general).

copiaAcadena1:			 
	mov al, [ebx+nStr]          ; Copia el carácter actual de `nStr` al registro `al`.
	mov [ebx+cadena], al        ; Almacena el carácter copiado en `cadena`.
	inc ebx                     ; Incrementa el índice `ebx` para leer el siguiente carácter.
	cmp al, 0                   ; Compara si el carácter leído es el final de la cadena (0).
	jne copiaAcadena1           ; Si no es 0, sigue copiando caracteres.
	call mostrarCadena          ; Llama a la función para mostrar la cadena copiada.
	call leerNumero             ; Llama a la función para leer un número ingresado.

	mov eax, [numero]           ; Carga el número leído en `eax`.
	cmp eax, 0                  ; Compara el número con 0.
	jg seguir1                  ; Si es mayor a 0, sigue al siguiente bloque.
	jmp main                    ; Si no, reinicia desde el inicio.

	mov ebx, 0                  ; Reinicia `ebx` a 0 para reutilizarlo.

main_1:
	mov esi, 0                  ; Inicializa `esi` nuevamente a 0.
	mov ebx, 0                  ; Reinicia `ebx` a 0.

copiaAcadena1_1:			 
	mov al, [ebx+mStr]          ; Copia caracteres de `mStr` de forma similar a `nStr`.
	mov [ebx+cadena], al        
	inc ebx                     
	cmp al, 0                   
	jne copiaAcadena1_1         
	call mostrarCadena          
	call leerNumero             

	mov eax, [numero]           
	cmp eax, 0                  
	jg seguir1_1                
	jmp main_1                  

seguir1:			          
	cmp eax, 11                 ; Verifica si el número ingresado es menor que 11.
	jl seguir2                  ; Si es menor, sigue al siguiente bloque.
	jmp main                    ; Si no, reinicia desde el inicio.

seguir1_1:			          
	cmp eax, 11                 
	jl seguir2_2                
	jmp main_1                  

seguir2:			          
	mov [n], eax                ; Guarda el número válido en `n`.

	mov [f], dword 0            ; Inicializa `f` a 0 (contador de filas).
	jmp main_1                  ; Pasa al siguiente bloque.

seguir2_2:			          
	mov [m], eax                ; Guarda el número válido en `m`.

	mov [f], dword 0            ; Inicializa `f` a 0.
	
proximoF:                      
	mov [c], dword 0            ; Inicializa `c` a 0 (contador de columnas).

proximoC:                      
	mov ebx, 0                  ; Reinicia `ebx` a 0.

copiaAcadena2:
	mov al, [ebx+filaStr]       ; Copia caracteres de `filaStr` a `cadena`.
	mov [ebx+cadena], al        
	inc ebx                     
	cmp al, 0                   
	jne copiaAcadena2           
	call mostrarCadena          

	mov eax, [f]                ; Carga el contador de filas `f` en `eax`.
	mov [numero], eax           ; Mueve el valor de `f` a `numero`.
	call mostrarNumero          ; Muestra el número de la fila.

	mov ebx, 0                  ; Reinicia `ebx`.

copiaAcadena3:
	mov al, [ebx+columnaStr]    ; Copia caracteres de `columnaStr` a `cadena`.
	mov [ebx+cadena], al        
	inc ebx                     
	cmp al, 0                   
	jne copiaAcadena3           
	call mostrarCadena          

	mov eax, [c]                ; Carga el contador de columnas `c` en `eax`.
	mov [numero], eax           ; Mueve el valor de `c` a `numero`.
	call mostrarNumero          ; Muestra el número de la columna.

	mov eax, 32                 ; Carga el carácter espacio (ASCII 32) en `eax`.
	mov [caracter], eax         
	call mostrarCaracter        ; Muestra un espacio.
	call mostrarCaracter        ; Muestra un segundo espacio.
	call leerNumero             ; Lee un número ingresado por el usuario.
	mov eax, [numero]           ; Carga el número leído en `eax`.
	mov [esi+matriz], eax       ; Guarda el número en la matriz en la posición actual.
	add esi, 4                  ; Avanza 4 bytes (una posición en la matriz).

	inc dword [c]               ; Incrementa el contador de columnas.
	mov eax, [c]                
	cmp eax, [m]                ; Compara si se alcanzó el límite de columnas.
	jb proximoC                 ; Si no se alcanzó, sigue con la siguiente columna.

	inc dword [f]               ; Incrementa el contador de filas.
	mov eax, [f]                
	cmp eax, [n]                ; Compara si se alcanzó el límite de filas.
	jb proximoF                 ; Si no se alcanzó, sigue con la siguiente fila.

	mov ebx, 0                  ; Reinicia `ebx` para la impresión de la matriz original.
	call mostrarSaltoDeLinea    ; Muestra un salto de línea.

copiaAcadena4:			; IMPRIMO CARACTERES "MATRIZ ORIGINAL"
        mov al, [ebx+cadenaStr]    ; Carga el carácter actual de la cadena `cadenaStr` en AL
        mov [ebx+cadena], al       ; Copia el carácter leído en `cadena`
        inc ebx                    ; Incrementa el índice (contador) EBX
        cmp al, 0                  ; Compara el carácter con 0 (fin de cadena)
        jne copiaAcadena4          ; Si no es el fin de cadena, repite el bucle
        call mostrarCadena         ; Llama a la función para mostrar la cadena completa

        call mostrarSaltoDeLinea   ; Llama a la función para imprimir un salto de línea

recorroMatriz:
	mov esi, 0		 ; Inicializa ESI como contador de filas

muestroFila:
	mov edi, 0 		 ; Inicializa EDI como contador de columnas

muestroColumna:

	mov ebx, esi 		 ; Copia el valor de ESI (fila actual) en EBX
	imul ebx, [m] 		 ; Multiplica EBX por el número de columnas (M)
	imul ebx, 4		 ; Multiplica EBX por 4 (cada valor ocupa 4 bytes)

	mov edx, edi 		 ; Copia el valor de EDI (columna actual) en EDX
	imul edx, 4 		 ; Multiplica EDX por 4

	add ebx, edx 		 ; Suma el desplazamiento de columna al desplazamiento de fila

	mov eax, 0 		 ; Limpia el registro EAX
	mov eax, [ebx+matriz] ; Carga el valor de la matriz en EAX
	mov [numero], eax     ; Copia el valor en `numero`
	call mostrarNumero    ; Llama a la función para mostrar el número
	mov eax, 0 		 ; Limpia EAX
	mov al, 32            ; Carga un espacio (carácter ASCII 32) en AL
	call mostrarCaracter  ; Llama a la función para mostrar el carácter

	inc edi 		 ; Incrementa el contador de columnas (EDI)
	cmp edi, dword [c]     ; Compara EDI con el número total de columnas (C)
	jl muestroColumna      ; Si aún hay columnas por mostrar, continúa el bucle

	inc esi 		 ; Incrementa el contador de filas (ESI)
	call mostrarSaltoDeLinea ; Imprime un salto de línea después de cada fila
	cmp esi, dword [f] 	 ; Compara ESI con el número total de filas (F)
	jl muestroFila	     ; Si aún hay filas por mostrar, continúa el bucle

	mov ebx, 0   		; Reinicia el índice EBX para la impresión de la matriz rotada
        call mostrarSaltoDeLinea ; Imprime un salto de línea antes de la nueva sección

copiaAcadena5:			; IMPRIMO CARACTERES "MATRIZ ROTADA ANTIHORARIO"
        mov al, [ebx+cadenaStr2]  ; Carga el carácter actual de `cadenaStr2` en AL
        mov [ebx+cadena], al      ; Copia el carácter leído en `cadena`
        inc ebx                   ; Incrementa el índice (contador) EBX
        cmp al, 0                 ; Compara el carácter con 0 (fin de cadena)
        jne copiaAcadena5         ; Si no es el fin de cadena, repite el bucle
        call mostrarCadena        ; Muestra la cadena completa

        call mostrarSaltoDeLinea  ; Imprime un salto de línea

recorroMatrizAntihorario:
	mov esi, dword [c]	 ; Inicializa ESI con el número total de columnas (C)
	dec esi 		 ; Decrementa ESI para empezar desde la última columna

muestroFilaAntihorario:
	mov edi, 0 		 ; Inicializa EDI como contador de filas

muestroColumnaAntihorario:

	mov ebx, edi 		 ; Copia el valor de EDI (fila actual) en EBX
	imul ebx, [m] 		 ; Multiplica EBX por el número de columnas (M)
	imul ebx, 4		 ; Multiplica EBX por 4

	mov edx, esi 		 ; Copia el valor de ESI (columna actual) en EDX
	imul edx, 4 		 ; Multiplica EDX por 4

	add ebx, edx 		 ; Suma el desplazamiento de columna al de fila

	mov eax, 0 		 ; Limpia el registro EAX
	mov eax, [ebx+matriz] ; Carga el valor de la matriz en EAX
	mov [numero], eax     ; Copia el valor en `numero`
	call mostrarNumero    ; Muestra el número
	mov eax, 0 		 ; Limpia EAX
	mov al, 32            ; Carga un espacio (carácter ASCII 32) en AL
	call mostrarCaracter  ; Muestra el carácter

	inc edi 		 ; Incrementa el contador de filas (EDI)
	cmp edi, dword [f]     ; Compara EDI con el número total de filas (F)
	jl muestroColumnaAntihorario ; Si aún hay filas por mostrar, continúa el bucle

	dec esi 		 ; Decrementa el contador de columnas (ESI)
	call mostrarSaltoDeLinea ; Imprime un salto de línea después de cada fila
	cmp esi, 0 		 ; Compara ESI con 0 (límite izquierdo)
	jge muestroFilaAntihorario ; Si aún hay columnas por mostrar, continúa el bucle

finPrograma:              
        jmp salirDelPrograma      ; Salta a la etiqueta `salirDelPrograma` para finalizar
