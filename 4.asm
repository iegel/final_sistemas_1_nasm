        global main              ; Se define el punto de entrada principal del programa
        global _start

        extern printf            ; Declaramos la función printf de C para imprimir en consola
        extern scanf             ; Declaramos la función scanf de C para leer entradas del usuario
        extern exit              ; Declaramos la función exit de C para finalizar el programa
        extern gets              ; Declaramos la función gets de C para leer cadenas de texto (aunque insegura)

section .bss                     ; Sección para declarar variables no inicializadas

numero:
        resd    1                ; Reservamos 4 bytes (1 entero) para almacenar un número ingresado

cadena:
        resb    0x0100           ; Reservamos 256 bytes para almacenar una cadena de caracteres

section .data                    ; Sección de datos (para almacenar cadenas y constantes)

fmtInt:
        db    "%d", 0            ; Formato para imprimir y leer números enteros (usado en scanf/printf)

fmtString:
        db    "%s", 0            ; Formato para imprimir y leer cadenas (usado en scanf/printf)

fmtChar:
        db    "%c", 0            ; Formato para imprimir caracteres (usado en printf)

fmtLF:
        db    0xA, 0             ; Salto de línea (0xA representa un carácter de nueva línea en ASCII)

nStr:
        db    "N: ", 0           ; Cadena que muestra el mensaje N: 

pidoNStr:
        db    "Ingrese un numero: ", 0     ; Mensaje para pedir al usuario que ingrese un número

pidoNStr2:
        db    "Suma de los numeros pares: ", 0     ; Mensaje para mostrar la suma de los números pares

pidoNStr3:
        db    "Promedio de los numeros impares: ", 0     ; Mensaje para mostrar el promedio de los números impares

section .text                    ; Sección de código donde se encuentra la lógica del programa

leerNumero:                      ; Rutina para leer un número ingresado por el usuario
        push numero              ; Colocamos la dirección de la variable `numero` en el stack
        push fmtInt              ; Colocamos el formato de entero para `scanf`
        call scanf               ; Llamamos a `scanf` para leer un número entero
        add esp, 8               ; Limpiamos el stack (se eliminarán los 2 argumentos de 4 bytes)
        ret                       ; Regresamos a la función principal

mostrarCadena:                   ; Rutina para mostrar una cadena de texto en consola
        push cadena              ; Colocamos la dirección de la cadena en el stack
        push fmtString           ; Colocamos el formato de cadena para `printf`
        call printf              ; Llamamos a `printf` para imprimir la cadena
        add esp, 8               ; Limpiamos el stack
        ret                       ; Regresamos a la función principal

mostrarNumero:                   ; Rutina para mostrar un número en consola
        push dword [numero]      ; Colocamos el valor de `numero` en el stack
        push fmtInt              ; Colocamos el formato de entero para `printf`
        call printf              ; Llamamos a `printf` para imprimir el número
        add esp, 8               ; Limpiamos el stack
        ret                       ; Regresamos a la función principal

mostrarSaltoDeLinea:             ; Rutina para mostrar un salto de línea
        push fmtLF               ; Colocamos el salto de línea en el stack
        call printf              ; Llamamos a `printf` para imprimir el salto de línea
        add esp, 4               ; Limpiamos el stack
        ret                       ; Regresamos a la función principal

salirDelPrograma:                ; Rutina para salir del programa
        push 0                   ; Colocamos el código de salida 0 en el stack
        call exit                ; Llamamos a `exit` para terminar el programa

_start:
main:                                   ; Entrada principal del programa
        mov edi, 0                      ; Inicializamos el contador de números procesados (edi)
        mov esi, 0                      ; Inicializamos el contador de números impares (esi)

pidoN:
        mov dword [cadena], "N: "       ; Preparamos la cadena N:  para mostrarla
        call mostrarCadena             ; Mostramos la cadena "N: "
        call leerNumero                 ; Llamamos a la rutina para leer un número del usuario

        mov eax, [numero]               ; Cargamos el valor ingresado en `numero` a `eax`
        mov ecx, 0                      ; Inicializamos el acumulador de la suma de números pares
        mov edx, 0                      ; Inicializamos el acumulador de la suma de números impares

pidoNumeros:    
        push eax                        ; Guardamos el valor de `eax` antes de llamar a la rutina
        push ecx                        ; Guardamos el valor de `ecx`
        push edx                        ; Guardamos el valor de `edx`
        mov ebx, 0                      ; Inicializamos el índice para la cadena

 copiaAcadena:                         ; Copiamos la cadena "Ingrese un numero: " en la memoria
        mov al, [ebx+pidoNStr]          ; Leemos un byte de la cadena
        mov [ebx+cadena], al            ; Guardamos el byte en la cadena
        inc ebx                         ; Incrementamos el índice
        cmp al, 0                       ; Comprobamos si hemos llegado al final de la cadena
        jne copiaAcadena                ; Si no hemos llegado al final, seguimos copiando
        call mostrarCadena              ; Mostramos la cadena "Ingrese un numero: "
        call leerNumero                 ; Leemos otro número

        pop edx                         ; Restauramos los valores de `edx`
        pop ecx                         ; Restauramos los valores de `ecx`

        mov eax, [numero]               ; Cargamos el número leído en `eax`
        
        test al, 1                      ; Comprobamos si el número es impar (comprobamos el bit menos significativo)
        pop eax                         ; Restauramos el valor de `eax`

        jnz impares                     ; Si el número es impar, saltamos a la sección de números impares
        jz pares                        ; Si el número es par, saltamos a la sección de números pares

pares:
        add ecx, [numero]               ; Sumamos los números pares a `ecx`
        jmp continua                    ; Continuamos con el siguiente número

impares:
        add edx, [numero]               ; Sumamos los números impares a `edx`
        inc esi                         ; Incrementamos el contador de números impares
        jmp continua                    ; Continuamos con el siguiente número

continua:
        inc edi                         ; Incrementamos el contador de números procesados
        cmp edi, eax                    ; Comparamos el contador con el número de iteraciones (N)
        jl pidoNumeros                  ; Si no hemos procesado todos los números, volvemos a pedir otro

muestroAcum:
        mov [numero], ecx               ; Guardamos la suma de los números pares en `numero`

        push eax                        ; Guardamos el valor de `eax`
        push ecx                        ; Guardamos el valor de `ecx`
        push edx                        ; Guardamos el valor de `edx`

        mov ebx, 0
        call mostrarSaltoDeLinea        ; Mostramos un salto de línea

 copiaAcadena2:                         ; Copiamos la cadena "Suma de los numeros pares: "
        mov al, [ebx+pidoNStr2]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena2
        call mostrarCadena

        call mostrarNumero              ; Mostramos la suma de los números pares

        pop edx                         ; Restauramos los valores de `edx`
        pop ecx                         ; Restauramos los valores de `ecx`
        pop eax                         ; Restauramos los valores de `eax`

muestroProm:
        cmp esi, 0                      ; Comprobamos si hubo números impares
        je todosPares                   ; Si no hubo impares, saltamos a `todosPares`

        mov eax, edx                    ; Cargamos la suma de los impares en `eax`
        mov edx, 0                      ; Limpiamos `edx`
        idiv esi                        ; Dividimos la suma de los impares por el número de impares (esi)
        mov [numero], eax               ; Guardamos el promedio de los impares en `numero`

        mov ebx, 0
        call mostrarSaltoDeLinea        ; Mostramos un salto de línea

 copiaAcadena3:                         ; Copiamos la cadena "Promedio de los numeros impares: "
        mov al, [ebx+pidoNStr3]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena3
        call mostrarCadena

        call mostrarNumero              ; Mostramos el promedio de los números impares
        jmp finPrograma

todosPares:                             ; Si solo hubo números pares, mostramos promedio = 0
        mov eax, 0
        mov [numero], eax 

        mov ebx, 0
        call mostrarSaltoDeLinea        ; Mostramos un salto de línea

 copiaAcadena4:                         ; Copiamos la cadena "Promedio de los numeros impares: "
        mov al, [ebx+pidoNStr3]
        mov [ebx+cadena], al
        inc ebx
        cmp al, 0
        jne copiaAcadena4
        call mostrarCadena

        call mostrarNumero              ; Mostramos 0 como el promedio de los impares

finPrograma:
        call mostrarSaltoDeLinea        ; Mostramos un salto de línea
        jmp salirDelPrograma            ; Terminamos el programa
