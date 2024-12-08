        global main              ; Marca el inicio del programa principal
        global _start            ; Marca el punto de entrada del programa

        extern printf            ; Importa la función printf de C
        extern scanf             ; Importa la función scanf de C
        extern exit              ; Importa la función exit de C
        extern gets              ; Importa la función gets de C (no recomendado por problemas de seguridad)

section .bss                     ; Sección para variables no inicializadas

numero:
        resd    1                ; Reserva un dword (4 bytes) para almacenar un número entero

cadena:
        resb    0x0100           ; Reserva 256 bytes para almacenar una cadena

section .data                    ; Sección para constantes y datos inicializados

fmtInt:
        db    "%d", 0            ; Formato de printf para números enteros

fmtString:
        db    "%s", 0            ; Formato de printf para cadenas

fmtChar:
        db    "%c", 0            ; Formato de printf para caracteres

fmtLF:
        db    0xA, 0             ; Salto de línea (carácter de nueva línea)

nStr:
        db    "N: ", 0           ; Cadena que se muestra antes de solicitar un número al usuario

divisor:                        
        dd    2                  ; Inicializa el divisor en 2 (primer número primo)

section .text                    ; Sección para el código del programa

leerNumero:                      ; Subrutina para leer un número entero usando scanf
        push numero              ; Dirección de la variable 'numero' para almacenar el valor ingresado
        push fmtInt              ; Formato para números enteros
        call scanf               ; Llama a scanf
        add esp, 8               ; Limpia la pila
        ret                      ; Retorna al punto de llamada

mostrarCadena:                   ; Subrutina para mostrar una cadena con printf
        push cadena              ; Dirección de la cadena a mostrar
        push fmtString           ; Formato para cadenas
        call printf              ; Llama a printf
        add esp, 8               ; Limpia la pila
        ret                      ; Retorna al punto de llamada

mostrarNumero:                   ; Subrutina para mostrar un número entero almacenado en 'numero'
        push dword [numero]      ; Valor de la variable 'numero'
        push fmtInt              ; Formato para números enteros
        call printf              ; Llama a printf
        add esp, 8               ; Limpia la pila
        ret                      ; Retorna al punto de llamada

mostrarDivisor:                  ; Subrutina para mostrar el valor actual del divisor
        push dword [divisor]     ; Valor de la variable 'divisor'
        push fmtInt              ; Formato para números enteros
        call printf              ; Llama a printf
        add esp, 8               ; Limpia la pila
        ret                      ; Retorna al punto de llamada

mostrarSaltoDeLinea:             ; Subrutina para mostrar un salto de línea
        push fmtLF               ; Formato para salto de línea
        call printf              ; Llama a printf
        add esp, 4               ; Limpia la pila
        ret                      ; Retorna al punto de llamada

modulo:                         ; Subrutina para calcular el módulo (resto de la división) de EAX entre EBX
        mov edx, 0              ; Limpia los bits altos para preparar EDX:EAX
        idiv ebx                ; Divide EDX:EAX por EBX; el cociente queda en EAX y el resto en EDX
        ret                     ; Retorna al punto de llamada con el resto en EDX

muestraFactor:                   ; Subrutina para mostrar el número inicial N y el signo '='
        call mostrarNumero       ; Muestra el número almacenado en 'numero'
        mov dword [cadena], " = " ; Prepara el signo '=' como texto a mostrar
        call mostrarCadena       ; Muestra el signo '='
        ret                      ; Retorna al punto de llamada

salirDelPrograma:                ; Subrutina para salir del programa usando exit
        push 0                   ; Código de salida 0
        call exit                ; Llama a exit
        ret                      ; (Nunca se ejecuta, exit termina el programa)

_start:                          ; Punto de entrada del programa
main:                            ; Inicio del programa principal
        mov word [cadena], "N:"  ; Muestra N: para pedir un número
        call mostrarCadena       ; Llama a la rutina para mostrar la cadena
        call leerNumero          ; Llama a la rutina para leer el número ingresado por el usuario

        mov eax, [numero]       ; Carga el valor ingresado en EAX
        mov ebx, [divisor]      ; Carga el divisor inicial (2) en EBX
        push eax                ; Guarda el valor de EAX en la pila
        call muestraFactor      ; Muestra "N = "
        pop eax                 ; Recupera el valor original de EAX

While:                          ; Inicio del bucle principal
        cmp eax, ebx            ; Compara EAX (N) con EBX (divisor)
        je Iguales              ; Si son iguales, salta a Iguales
        jle finPrograma         ; Si N < divisor, termina el programa

        push eax                ; Guarda el valor de EAX en la pila
        call modulo             ; Calcula el módulo de EAX entre EBX
        cmp edx, 0              ; Compara el resto (EDX) con 0
        jne Else                ; Si el resto no es 0, salta a Else
        add esp, 4              ; Descarta el valor de EAX de la pila
        push eax                ; Guarda nuevamente el valor de EAX
        call mostrarDivisor     ; Muestra el divisor como un factor primo

        mov dword [cadena], " x " ; Prepara el texto  x
        call mostrarCadena        ; Muestra " x "
        pop eax                   ; Recupera el valor original de EAX
        jmp While                 ; Regresa al inicio del bucle

Else:                           ; Incrementa el divisor si no es factor primo
        pop eax                 ; Recupera el valor original de EAX
        inc ebx                 ; Incrementa el divisor
        mov [divisor], ebx      ; Actualiza el divisor en memoria
        jmp While               ; Regresa al inicio del bucle

Iguales:                        ; Caso en el que N es igual al divisor
        call mostrarDivisor     ; Muestra el divisor como último factor primo

finPrograma:              
        jmp salirDelPrograma     ; Termina el programa
