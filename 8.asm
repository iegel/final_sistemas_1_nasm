; Se ingresa una matriz de NxN componentes enteras. La computadora muestra la matriz transpuesta.

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

filaStr:
	db    "Fila:", 0	 ;  Cadena Fila:
	
columnaStr:
	db    " Columna:", 0	 ;  Cadena Columna:

cadenaStr:
        db    "Matriz Original: ", 0  


cadenaStr2:
        db    "Matriz Transpuesta: ", 0  




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
	mov esi, 0                ; Inicializa el registro `esi` en 0 (posiblemente utilizado como índice o contador).
	mov ebx, 0                ; Inicializa el registro `ebx` en 0 (posiblemente utilizado como índice o puntero).

copiaAcadena1:			 
	mov al, [ebx+nStr]        ; Copia el carácter actual de la cadena `nStr` a `al` (registro que guarda un byte temporalmente).
	mov [ebx+cadena], al      ; Copia el contenido de `al` al arreglo `cadena` en la posición `ebx`.
	inc ebx                   ; Incrementa el valor de `ebx` (apunta al siguiente carácter en la cadena).
	cmp al, 0                 ; Compara el carácter actual con `0` (indica el fin de la cadena).
	jne copiaAcadena1         ; Si no es el final de la cadena, repite el bucle.
	call mostrarCadena        ; Llama a la subrutina que muestra la cadena almacenada.
	call leerNumero           ; Llama a la subrutina que lee un número ingresado por el usuario.
		
	mov eax, [numero]         ; Mueve el valor de la variable `numero` al registro `eax`.
	cmp eax, 0                ; Compara el valor del número ingresado con 0.
	jg seguir1                ; Si el número es mayor que 0, salta a la etiqueta `seguir1`.
	jmp main                  ; De lo contrario, vuelve a la etiqueta `main`.

seguir1:			             ; VALIDA QUE EL NÚMERO INGRESADO SEA MENOR QUE 11
	cmp eax, 11               ; Compara el número ingresado con 11.
	jl seguir2                ; Si es menor que 11, salta a la etiqueta `seguir2`.
	jmp main                  ; De lo contrario, vuelve a la etiqueta `main`.

seguir2:			             ; GUARDA EL NÚMERO VÁLIDO EN LA VARIABLE `n`.
	mov [n], eax              ; Mueve el valor de `eax` (el número válido) a la variable `n`.
		
	mov [f], dword 0          ; Inicializa la variable `f` con el valor 0.

proximoF:
	mov [c], dword 0          ; Inicializa la variable `c` con el valor 0.

proximoC:
	mov ebx, 0                ; Inicializa `ebx` en 0 nuevamente (contador para la siguiente operación).

copiaAcadena2:
	mov al, [ebx+filaStr]     ; Copia el carácter actual de la cadena `filaStr` al registro `al`.
	mov [ebx+cadena], al      ; Copia el contenido de `al` al arreglo `cadena` en la posición `ebx`.
	inc ebx                   ; Incrementa el valor de `ebx` (apunta al siguiente carácter en la cadena).
	cmp al, 0                 ; Compara el carácter actual con `0` (indica el fin de la cadena).
	jne copiaAcadena2         ; Si no es el final de la cadena, repite el bucle.
	call mostrarCadena        ; Llama a la subrutina que muestra la cadena almacenada.
		
	mov eax, [f]              ; Mueve el valor de la variable `f` al registro `eax`.
	mov [numero], eax         ; Copia el valor de `eax` a la variable `numero`.
	call mostrarNumero        ; Llama a la subrutina para mostrar el número almacenado.
	
	mov ebx, 0                ; Inicializa `ebx` nuevamente en 0 (contador para la próxima operación).


copiaAcadena3:
	mov al, [ebx+columnaStr]     ; Copia el carácter actual de la cadena `columnaStr` en el registro `al`.
	mov [ebx+cadena], al         ; Copia el valor de `al` en la dirección `ebx+cadena`.
	inc ebx                      ; Incrementa `ebx` para apuntar al siguiente carácter en la cadena.
	cmp al, 0                    ; Compara si el valor de `al` es 0 (fin de la cadena).
	jne copiaAcadena3            ; Si no es 0, repite el proceso de copiar la cadena.
	call mostrarCadena           ; Llama a la subrutina que muestra la cadena copiada.

	mov eax, [c]                 ; Mueve el valor de la variable `c` a `eax`.
	mov [numero], eax            ; Mueve el valor de `eax` a la variable `numero`.
	call mostrarNumero           ; Llama a la subrutina para mostrar el número en `numero`.

	mov eax, 32                  ; Mueve el valor 32 (espacio en ASCII) a `eax`.
	mov [caracter], eax          ; Almacena el valor 32 en la variable `caracter`.
	call mostrarCaracter         ; Llama a la subrutina que muestra un espacio.
	call mostrarCaracter         ; Llama nuevamente para mostrar otro espacio.
	call leerNumero              ; Llama a la subrutina que lee un número ingresado por el usuario.
	mov eax, [numero]            ; Mueve el valor almacenado en `numero` a `eax`.
	mov [esi+matriz], eax        ; Almacena el valor de `eax` en la matriz en la posición indicada por `esi`.
	add esi, 4                   ; Aumenta `esi` en 4 (se avanza a la siguiente posición de la matriz).

	inc dword [c]                ; Incrementa el valor de `c` (contador de columnas).
	mov eax, [c]                 ; Mueve el valor de `c` a `eax`.
	cmp eax, [n]                 ; Compara `c` con `n`.
	jb proximoC                  ; Si `c` es menor que `n`, salta a `proximoC` (sigue procesando columnas).

	inc dword [f]                ; Si terminó con las columnas, incrementa el valor de `f` (contador de filas).
	mov eax, [f]                 ; Mueve el valor de `f` a `eax`.
	cmp eax, [n]                 ; Compara `f` con `n`.
	jb proximoF                  ; Si `f` es menor que `n`, salta a `proximoF` (sigue procesando filas).

copiaAcadena4:
	mov al, [ebx+cadenaStr]      ; Copia el siguiente carácter de la cadena `cadenaStr` a `al`.
	mov [ebx+cadena], al         ; Almacena el valor de `al` en la variable `cadena` en la posición `ebx`.
	inc ebx                      ; Incrementa `ebx` para apuntar al siguiente carácter en la cadena.
	cmp al, 0                    ; Compara el valor de `al` con 0 (fin de la cadena).
	jne copiaAcadena4            ; Si no es el final, repite el proceso.
	call mostrarCadena           ; Llama a la subrutina para mostrar la cadena copiada.
	call mostrarSaltoDeLinea     ; Llama a la subrutina para mostrar un salto de línea.

recorroMatriz:
	mov esi, 0                   ; Inicializa `esi` (contador de filas) en 0.

muestroFila:
	mov edi, 0                   ; Inicializa `edi` (contador de columnas) en 0.

muestroColumna:
	mov ebx, esi                 ; Copia el valor de `esi` (fila) a `ebx`.
	imul ebx, [n]                ; Multiplica `ebx` por `n` (número de columnas).
	imul ebx, 4                  ; Multiplica `ebx` por 4 (tamaño de un entero en la matriz).
	mov edx, edi                 ; Copia el valor de `edi` (columna) a `edx`.
	imul edx, 4                  ; Multiplica `edx` por 4 (tamaño de un entero en la matriz).
	add ebx, edx                 ; Suma los valores de `ebx` y `edx` para obtener la posición en la matriz.

	mov eax, 0                   ; Inicializa `eax` a 0 (por seguridad).
	mov eax, [ebx+matriz]        ; Copia el valor en la matriz en la dirección `ebx` a `eax`.
	mov [numero], eax            ; Mueve el valor de `eax` a la variable `numero`.
	call mostrarNumero           ; Llama a la subrutina para mostrar el número en `numero`.
	mov eax, 0                   ; Inicializa `eax` a 0.
	mov al, 32                   ; Mueve el valor 32 (espacio en ASCII) a `al`.
	call mostrarCaracter         ; Llama a la subrutina para mostrar un espacio.

	inc edi                      ; Incrementa `edi` (columna).
	cmp edi, dword [c]           ; Compara `edi` con el valor de `c` (número de columnas).
	jl muestroColumna            ; Si `edi` es menor que `c`, sigue mostrando la columna.

	inc esi                      ; Incrementa `esi` (fila).
	call mostrarSaltoDeLinea     ; Llama a la subrutina para mostrar un salto de línea.
	cmp esi, dword [f]           ; Compara `esi` con el valor de `f` (número de filas).
	jl muestroFila               ; Si `esi` es menor que `f`, sigue mostrando la fila.

copiaAcadena5:
	mov al, [ebx+cadenaStr2]     ; Copia el siguiente carácter de la cadena `cadenaStr2` a `al`.
	mov [ebx+cadena], al         ; Almacena el valor de `al` en la variable `cadena` en la posición `ebx`.
	inc ebx                      ; Incrementa `ebx` para apuntar al siguiente carácter en la cadena.
	cmp al, 0                    ; Compara el valor de `al` con 0 (fin de la cadena).
	jne copiaAcadena5            ; Si no es el final, repite el proceso.
	call mostrarCadena           ; Llama a la subrutina para mostrar la cadena copiada.
	call mostrarSaltoDeLinea     ; Llama a la subrutina para mostrar un salto de línea.

recorroMatrizTranspuesta:
	mov esi, 0                   ; Inicializa `esi` (contador de filas) en 0 para recorrer la transpuesta.

muestroFilaTranspuesta:
	mov edi, 0                   ; Inicializa `edi` (contador de columnas) en 0.

muestroColumnaTranspuesta:
	mov ebx, edi                 ; Copia el valor de `edi` (columna) a `ebx`.
	imul ebx, [n]                ; Multiplica `ebx` por `n` (número de filas).
	imul ebx, 4                  ; Multiplica `ebx` por 4 (tamaño de un entero en la matriz).
	mov edx, esi                 ; Copia el valor de `esi` (fila) a `edx`.
	imul edx, 4                  ; Multiplica `edx` por 4 (tamaño de un entero en la matriz).
	add ebx, edx                 ; Suma `ebx` y `edx` para obtener la posición en la matriz transpuesta.

	mov eax, 0                   ; Inicializa `eax` a 0.
	mov eax, [ebx+matriz]        ; Copia el valor de la matriz transpuesta en la dirección `ebx` a `eax`.
	mov [numero], eax            ; Mueve el valor de `eax` a la variable `numero`.
	call mostrarNumero           ; Llama a la subrutina para mostrar el número en `numero`.
	mov eax, 0                   ; Inicializa `eax` a 0.
	mov al, 32                   ; Mueve el valor 32 (espacio en ASCII) a `al`.
	call mostrarCaracter         ; Llama a la subrutina para mostrar un espacio.

	inc edi                      ; Incrementa `edi` (columna transpuesta).
	cmp edi, dword [c]           ; Compara `edi` con el valor de `c` (número de columnas).
	jl muestroColumnaTranspuesta ; Si `edi` es menor que `c`, sigue mostrando la columna transpuesta.

	inc esi                      ; Incrementa `esi` (fila transpuesta).
	call mostrarSaltoDeLinea     ; Llama a la subrutina para mostrar un salto de línea.
	cmp esi, dword [f]           ; Compara `esi` con el valor de `f` (número de filas).
	jl muestroFilaTranspuesta    ; Si `esi` es menor que `f`, sigue mostrando la fila transpuesta.

finPrograma:
        jmp salirDelPrograma     ; Salta a la etiqueta `salirDelPrograma` para finalizar el programa.

