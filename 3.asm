        global main              ; Punto de inicio de la ejecución del programa
        global _start

        extern printf            ; Importa función para imprimir
        extern scanf             ; Importa función para leer datos
        extern exit              ; Importa función para terminar el programa
        extern gets              ; (Peligrosa) Solo se usa en ejercicios básicos

section .bss                     ; Sección de variables

numero:
        resd    1                ; Reserva espacio de 4 bytes para el número (1 dword)
         
cadena:
        resb    0x0100           ; Reserva espacio de 256 bytes para la cadena de texto

section .data                    ; Sección de constantes

fmtInt:
        db    "%d", 0            ; Formato para imprimir números enteros

fmtString:
        db    "%s", 0            ; Formato para imprimir cadenas

fmtChar:
        db    "%c", 0            ; Formato para imprimir caracteres

fmtLF:
        db    0xA, 0             ; Salto de línea (LF)

nStr:
        db    "N: ", 0           ; Cadena N: 

anioStr:
        db    "Ingrese Anio: ", 0 ; Cadena de texto para pedir el año

bisiestoStr:
        db    " es Bisiesto ", 0  ; Cadena de texto para indicar que el año es bisiesto

noBisiestoStr:
        db    " no es Bisiesto ", 0  ; Cadena de texto para indicar que el año no es bisiesto

section .text                    ; Sección de las instrucciones

leerNumero:                      ; Rutina para leer un número entero usando scanf
        push numero              ; Apila la dirección de la variable donde se almacenará el número
        push fmtInt              ; Apila el formato para número entero
        call scanf               ; Llama a la función scanf para leer el número
        add esp, 8               ; Ajusta el puntero de la pila después de la llamada
        ret                       ; Regresa a la ejecución principal
    
mostrarCadena:                   ; Rutina para mostrar una cadena usando printf
        push cadena              ; Apila la dirección de la cadena a mostrar
        push fmtString           ; Apila el formato para cadena
        call printf              ; Llama a la función printf para mostrar la cadena
        add esp, 8               ; Ajusta el puntero de la pila
        ret                       ; Regresa a la ejecución principal

mostrarNumero:                   ; Rutina para mostrar un número entero usando printf
        push dword [numero]      ; Apila el valor del número almacenado en la variable
        push fmtInt              ; Apila el formato para número entero
        call printf              ; Llama a la función printf para mostrar el número
        add esp, 8               ; Ajusta el puntero de la pila
        ret                       ; Regresa a la ejecución principal

mostrarSaltoDeLinea:             ; Rutina para mostrar un salto de línea usando printf
        push fmtLF               ; Apila el formato de salto de línea
        call printf              ; Llama a la función printf para mostrar el salto
        add esp, 4               ; Ajusta el puntero de la pila
        ret                       ; Regresa a la ejecución principal

modulo:                         ; Función para calcular el residuo de una división
        mov edx, 0              ; Limpia el registro EDX (parte alta de la división)
        idiv ebx                ; Divide EDX:EAX entre EBX, coloca el cociente en EAX y el residuo en EDX
        ret                       ; Regresa a la ejecución principal

salirDelPrograma:                ; Punto de salida del programa usando exit
        push 0                   ; Apila el valor 0 (indicando salida exitosa)
        call exit                ; Llama a la función exit para terminar el programa

_start:                           ; Inicio del programa principal
main:
        mov ebx, 0              ; Inicializa EBX a 0 (puntero para trabajar con cadenas)

copiaAcadena:                     ; Copia la cadena "Ingrese Anio: " en la variable 'cadena'
        mov al, [ebx+anioStr]    ; Carga un byte de la cadena "Ingrese Anio: " en AL
        mov [ebx+cadena], al     ; Guarda el byte de AL en la dirección de 'cadena'
        inc ebx                  ; Incrementa el puntero de EBX para copiar el siguiente byte
        cmp al, 0                ; Compara AL con 0 (fin de la cadena)
        jne copiaAcadena         ; Si no es 0, continúa copiando el siguiente byte
        call mostrarCadena       ; Llama a la función para mostrar la cadena
        call leerNumero          ; Llama a la función para leer el número (año)

divisible1:                        ; Comprueba si el año es divisible por 400
        mov ebx, 0              ; Inicializa EBX a 0
        mov eax, [numero]       ; Carga el número (año) en EAX
        mov ebx, 400            ; Carga 400 en EBX
        push eax                 ; Apila el valor de EAX para preservarlo
        call mostrarNumero      ; Muestra el número
        pop eax                  ; Restaura el valor de EAX
        call modulo             ; Llama a la función modulo para calcular EAX mod EBX
        cmp edx, 0              ; Compara el residuo (EDX) con 0
        je EsBisiesto           ; Si el residuo es 0, el año es bisiesto

divisible2:                        ; Comprueba si el año es divisible por 4
        mov eax, [numero]       ; Carga el número (año) en EAX
        mov ebx, 4              ; Carga 4 en EBX
        call modulo             ; Llama a la función modulo para calcular EAX mod EBX
        cmp edx, 0              ; Compara el residuo (EDX) con 0
        jne NoEsBisiesto        ; Si el residuo no es 0, el año no es bisiesto

divisible3:                        ; Comprueba si el año es divisible por 100
        mov eax, [numero]       ; Carga el número (año) en EAX
        mov ebx, 100            ; Carga 100 en EBX
        call modulo             ; Llama a la función modulo para calcular EAX mod EBX
        cmp edx, 0              ; Compara el residuo (EDX) con 0
        je NoEsBisiesto         ; Si el residuo es 0, el año no es bisiesto

EsBisiesto:                        ; Si el año es bisiesto, se imprime el mensaje
        mov ebx, 0
copiaAcadena2:
        mov al, [ebx+bisiestoStr] ; Carga un byte de " es Bisiesto "
        mov [ebx+cadena], al     ; Guarda el byte en 'cadena'
        inc ebx                  ; Incrementa el puntero de EBX para copiar el siguiente byte
        cmp al, 0                ; Compara AL con 0 (fin de la cadena)
        jne copiaAcadena2         ; Si no es 0, continúa copiando el siguiente byte
        call mostrarCadena       ; Muestra la cadena " es Bisiesto "
        call finPrograma         ; Termina el programa

NoEsBisiesto:                     ; Si el año no es bisiesto, se imprime el mensaje
        mov ebx, 0
copiaAcadena3:
        mov al, [ebx+noBisiestoStr] ; Carga un byte de " no es Bisiesto "
        mov [ebx+cadena], al     ; Guarda el byte en 'cadena'
        inc ebx                  ; Incrementa el puntero de EBX para copiar el siguiente byte
        cmp al, 0                ; Compara AL con 0 (fin de la cadena)
        jne copiaAcadena3         ; Si no es 0, continúa copiando el siguiente byte
        call mostrarCadena       ; Muestra la cadena " no es Bisiesto "
        call finPrograma         ; Termina el programa

finPrograma:                      
        jmp salirDelPrograma     ; Salta a la función que termina el programa
