; Se ingresa N. La computadora muestra los primeros N términos de la Secuencia de Connell.

global main              ; Punto de inicio de la ejecución del programa
global _start

extern printf            ; Funciones externas de C
extern scanf             ;
extern exit              ;
extern gets              ; (Nota: gets es peligrosa, no usar en proyectos reales)

section .bss                     ; Sección para las variables

numero:
        resd    1                ; Reservar un entero (4 bytes) para el número ingresado por el usuario
         
cadena:
        resb    0x0100           ; Reservar 256 bytes para la cadena

section .data                    ; Sección de las constantes

fmtInt:
        db    "%d", 0            ; Formato para imprimir números enteros

fmtString:
        db    "%s", 0            ; Formato para imprimir cadenas de texto

fmtChar:
        db    "%c", 0            ; Formato para imprimir caracteres

fmtLF:
        db    0xA, 0             ; Salto de línea (LF)

nStr:
        db    "N: ", 0           ; Cadena que solicita el número N al usuario

divisor:                        
        dd    2                  ; Valor constante 2, usado para la división

total:                        
        dd    0                  ; Variable para almacenar la cantidad total de términos (N)

section .text                    ; Sección de instrucciones

leerNumero:                      ; Rutina para leer un número entero usando scanf
        push numero              ; Pone la dirección de la variable 'numero' en la pila
        push fmtInt              ; Pone el formato de número entero en la pila
        call scanf               ; Llama a la función scanf para leer el número
        add esp, 8               ; Libera espacio en la pila
        ret                       ; Retorna de la función

mostrarCadena:                   ; Rutina para mostrar una cadena usando printf
        push cadena              ; Pone la dirección de la cadena en la pila
        push fmtString           ; Pone el formato de cadena en la pila
        call printf              ; Llama a la función printf para mostrar la cadena
        add esp, 8               ; Libera espacio en la pila
        ret                       ; Retorna de la función

mostrarNumero:                   ; Rutina para mostrar un número entero usando printf
        push dword [numero]      ; Pone el número en la pila
        push fmtInt              ; Pone el formato de número entero en la pila
        call printf              ; Llama a printf para mostrar el número
        add esp, 8               ; Libera espacio en la pila
        ret                       ; Retorna de la función

mostrarSaltoDeLinea:             ; Rutina para mostrar un salto de línea usando printf
        push fmtLF               ; Pone el formato de salto de línea en la pila
        call printf              ; Llama a printf para mostrar el salto de línea
        add esp, 4               ; Libera espacio en la pila
        ret                       ; Retorna de la función

salirDelPrograma:                ; Punto de salida del programa usando exit
        push 0                   ; Pone el código de salida (0) en la pila
        call exit                ; Llama a exit para terminar el programa

_start:
main:                                   ; Punto de inicio del programa

        mov dword [cadena], "N: "       ; Asigna la cadena N:  a la variable 'cadena'
        call mostrarCadena              ; Muestra la cadena solicitando N
        call leerNumero                 ; Llama a la rutina para leer el número N
        mov edx, [numero]               ; Mueve el valor de N a edx
        mov [total], edx                ; Guarda N en la variable total (cantidad de términos a generar)

        mov edx, 0                      ; Inicializa el contador de términos (edx)
        mov ecx, 0                      ; Inicializa el valor para el cálculo (ecx)

primeraMult:
        mov edi, 1                      ; Inicializa el contador 'edi' para cada iteración del ciclo (empieza en 1)
        mov esi, -1                     ; Inicializa el contador 'esi' (empieza en -1)

        inc edx                         ; Aumenta el contador de iteraciones
        mov ecx, edx                    ; Copia el contador de iteraciones a ecx
        imul ecx, ecx, 2                ; Calcula 2 * N, donde N es el valor de edx (iteración actual)

operacionDentroRaiz:
        mov eax, edx                    ; Copia el valor de edx (N actual) a eax
        imul eax, 8                     ; Multiplica N por 8
        sub eax, 7                      ; Resta 7 de 8 * N, obteniendo (8 * N) - 7

raiz:
        sub eax, edi                    ; Resta el valor de edi (que comienza en 1 y se incrementa en 2) de la operación anterior
        add edi, 2                      ; Aumenta 'edi' de 1 en 1, para la próxima resta de número impar
        inc esi                         ; Aumenta el contador 'esi' que está contando la cantidad de restas

        cmp eax, 0                      ; Compara si el resultado es mayor o igual a 0
        jge raiz                        ; Si el resultado es mayor o igual a 0, repite el ciclo de resta

suma:
        add esi, 1                      ; Incrementa el valor final al término de la raíz

segundaMult:
        mov ebx, [divisor]              ; Carga el valor 2 (el divisor) en ebx
        mov eax, esi                    ; Mueve el resultado de la raíz (es decir, el valor de 'esi') a eax
        push edx                         ; Guarda el valor de edx en la pila
        mov edx, 0                       ; Limpia el valor de edx antes de la división
        idiv ebx                         ; Realiza la división de 'esi' entre 2, el valor de 'eax' se divide por 2
        pop edx
                
operacionFinal:
        sub ecx, eax                    ; Calcula 2 * N - el valor obtenido de la división

secuenciaConell:
        push eax                        ; Preserva el valor actual de 'eax'
        push ecx                        ; Preserva el valor actual de 'ecx'
        push edx                        ; Preserva el valor actual de 'edx'
        mov [numero], ecx               ; Mueve el resultado final (de secuencia) a la variable 'numero'
        call mostrarNumero              ; Muestra el número en la secuencia
        call mostrarSaltoDeLinea        ; Muestra un salto de línea

        pop edx                         ; Restaura el valor de 'edx'
        pop ecx                         ; Restaura el valor de 'ecx'
        pop eax                         ; Restaura el valor de 'eax'

        cmp edx, [total]                ; Compara si el número de iteraciones alcanzó el valor total de N
        jl primeraMult                  ; Si no se ha alcanzado el total, continúa con la siguiente iteración
        je finPrograma                  ; Si ya se alcanzó N, termina el programa

finPrograma:              
        jmp salirDelPrograma            ; Salta al final del programa y termina la ejecución

