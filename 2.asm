        global main              ; Marca el inicio de la ejecución del programa
        global _start

        extern printf            ; Importa la función printf de la biblioteca C
        extern scanf             ; Importa la función scanf de la biblioteca C
        extern exit              ; Importa la función exit de la biblioteca C
        extern gets              ; Importa la función gets de la biblioteca C (peligrosa, no usar en producción)

section .bss                     ; Sección para variables no inicializadas
numero:
        resd    1                ; Reserva 1 dword (4 bytes) para almacenar un número entero

cadena:
        resb    0x0100           ; Reserva 256 bytes para almacenar una cadena de texto

cadenaInicio:
        resb    0x0100           ; Reserva 256 bytes para almacenar la copia inicial de la cadena

caracter:
        resb    1                ; Reserva 1 byte para un carácter
        resb    3                ; Reserva 3 bytes adicionales como relleno (alineación)

section .data                    ; Sección para datos inicializados (constantes)
fmtInt:
        db    "%d", 0            ; Formato para mostrar números enteros

fmtString:
        db    "%s", 0            ; Formato para mostrar cadenas de texto

fmtChar:
        db    "%c", 0            ; Formato para mostrar un carácter

fmtLF:
        db    0xA, 0             ; Salto de línea (line feed)

cadenaStr:
        db    "Ingrese una cadena: ", 0  ; Mensaje a mostrar al usuario

section .text                    ; Sección de código (instrucciones)
leerCadena:                      ; Rutina para leer una cadena de texto
        push cadena              ; Apunta al buffer donde se almacenará la cadena
        call gets                ; Llama a la función gets para leer la cadena
        add esp, 4               ; Ajusta la pila
        ret                      ; Retorna al punto de llamada

mostrarCadenaInicio:             ; Rutina para mostrar la copia inicial de la cadena
        push cadenaInicio        ; Apunta al inicio de la cadena copiada
        push fmtString           ; Usa el formato de cadenas
        call printf              ; Llama a printf para mostrar la cadena
        add esp, 8               ; Ajusta la pila
        ret                      ; Retorna al punto de llamada

mostrarCaracter:                 ; Rutina para mostrar un carácter
        push dword [caracter]    ; Apunta al carácter que se va a mostrar
        push fmtChar             ; Usa el formato de caracteres
        call printf              ; Llama a printf para mostrar el carácter
        add esp, 8               ; Ajusta la pila
        ret                      ; Retorna al punto de llamada

mostrarSaltoDeLinea:             ; Rutina para mostrar un salto de línea
        push fmtLF               ; Apunta al formato de salto de línea
        call printf              ; Llama a printf para mostrar el salto de línea
        add esp, 4               ; Ajusta la pila
        ret                      ; Retorna al punto de llamada

salirDelPrograma:                ; Punto de salida del programa
        push 0                   ; Código de salida (0 indica éxito)
        call exit                ; Llama a exit para finalizar el programa

_start:
main:                            ; Punto de inicio del programa
        mov ebx, 0               ; Inicializa el índice en 0

copiaAcadena:                    ; Rutina para copiar el mensaje inicial
        mov al, [ebx+cadenaStr]  ; Carga el carácter actual de cadenaStr
        mov [ebx+cadenaInicio], al ; Copia el carácter a cadenaInicio
        inc ebx                  ; Incrementa el índice
        cmp al, 0                ; Compara el carácter con el terminador nulo
        jne copiaAcadena         ; Repite hasta llegar al final de la cadena
        call mostrarCadenaInicio ; Muestra la copia inicial de la cadena

        call leerCadena          ; Llama a leer una nueva cadena ingresada por el usuario
        mov edi,1                ; Inicializa el índice en 1 para posiciones pares

seguir:                          ; Rutina para procesar posiciones pares
        mov al, [edi + cadena]   ; Obtiene el carácter en la posición actual
        cmp al, 0                ; Comprueba si es el fin de la cadena
        je seguir2               ; Salta a la siguiente rutina si es el fin

        mov [caracter], al       ; Almacena el carácter actual
        call mostrarCaracter     ; Muestra el carácter
        add edi, 2               ; Incrementa el índice en 2 (siguiente posición par)
        jmp seguir               ; Repite el ciclo

seguir2:                         ; Rutina para procesar posiciones impares
        call mostrarSaltoDeLinea ; Imprime un salto de línea
        mov edi, 0               ; Reinicia el índice en 0 para posiciones impares

seguir3:                         ; Rutina para procesar posiciones impares
        mov al,[edi + cadena]    ; Obtiene el carácter en la posición actual
        cmp al, 0                ; Comprueba si es el fin de la cadena
        je finPrograma           ; Salta al final del programa si es el fin

        mov [caracter], al       ; Almacena el carácter actual
        call mostrarCaracter     ; Muestra el carácter
        add edi, 2               ; Incrementa el índice en 2 (siguiente posición impar)
        jmp seguir3              ; Repite el ciclo

finPrograma:                     ; Punto final del programa
        call mostrarSaltoDeLinea ; Imprime un salto de línea
        jmp salirDelPrograma     ; Finaliza el programa
