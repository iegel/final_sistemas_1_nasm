        global main              ; Definir la etiqueta de inicio del programa
        global _start

        extern printf            ; Funciones externas de la librería C (para imprimir y leer)
        extern scanf             
        extern exit              
        extern gets              ; La función gets se utiliza para leer la entrada del usuario (aunque es peligrosa, no se recomienda en programas reales)

section .bss                     ; Sección de variables no inicializadas

numero:
        resd    1                ; Reservar 1 dword (4 bytes) para almacenar un número

cadena:
        resb    0x0100           ; Reservar 256 bytes para almacenar la cadena ingresada por el usuario

cadenaInicio:
        resb    0x0100           ; Reservar 256 bytes para almacenar la cadena inicial (mensaje de inicio)

caracter:
        resb    1                ; Reservar 1 byte para almacenar un carácter
        resb    3                ; Reservar 3 bytes de relleno

section .data                    ; Sección de constantes de datos

fmtInt:
        db    "%d", 0            ; Formato para números enteros

fmtString:
        db    "%s", 0            ; Formato para cadenas

fmtChar:
        db    "%c", 0            ; Formato para caracteres

fmtLF:
        db    0xA, 0             ; Salto de línea (LF)

cadenaStr:
        db    "Ingrese una cadena de 100 caracteres: ", 0  ; Mensaje para pedir la entrada

cadenaError:
        db    "Debe ingresar 100 caracteres. Vuelva a empezar!!!", 0  ; Mensaje de error si la cadena no tiene 100 caracteres

indices:    
        dw  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  ; Arreglo para almacenar el número de veces que cada carácter válido aparece

caracteres:    
        db  "!",34,"#$%&",39,"()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0  ; Conjunto de caracteres válidos (símbolos, números, letras)


section .text                           ; Sección de instrucciones

leerCadena:                             ; Rutina para leer una cadena usando gets
        push cadena                    ; Pasar la dirección de la variable cadena como parámetro
        call gets                      ; Llamar a la función gets
        add esp, 4                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

leerNumero:                             ; Rutina para leer un número usando scanf
        push numero                    ; Pasar la dirección de la variable numero
        push fmtInt                    ; Pasar el formato para números enteros
        call scanf                     ; Llamar a la función scanf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina
    
mostrarCadena:                          ; Rutina para mostrar una cadena usando printf
        push cadena                    ; Pasar la dirección de la cadena
        push fmtString                 ; Pasar el formato para cadenas
        call printf                    ; Llamar a la función printf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

mostrarCadenaInicio:                   ; Rutina para mostrar el mensaje inicial con printf
        push cadenaInicio              ; Pasar la dirección del mensaje de inicio
        push fmtString                 ; Pasar el formato para cadenas
        call printf                    ; Llamar a la función printf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

mostrarCadenaError:                   ; Rutina para mostrar el mensaje de error con printf
        push cadenaError               ; Pasar la dirección del mensaje de error
        push fmtString                 ; Pasar el formato para cadenas
        call printf                    ; Llamar a la función printf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

mostrarNumero:                          ; Rutina para mostrar un número usando printf
        push dword [numero]            ; Pasar el número a imprimir
        push fmtInt                    ; Pasar el formato para números enteros
        call printf                    ; Llamar a la función printf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

mostrarCaracter:                        ; Rutina para mostrar un carácter usando printf
        push dword [caracter]          ; Pasar el carácter a imprimir
        push fmtChar                   ; Pasar el formato para caracteres
        call printf                    ; Llamar a la función printf
        add esp, 8                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

mostrarSaltoDeLinea:                    ; Rutina para mostrar un salto de línea usando printf
        push fmtLF                     ; Pasar el formato de salto de línea
        call printf                    ; Llamar a la función printf
        add esp, 4                     ; Limpiar el stack después de la llamada
        ret                            ; Regresar de la rutina

salirDelPrograma:                       ; Punto de salida del programa usando exit
        push 0                         ; Pasar el código de salida (0)
        call exit                      ; Llamar a la función exit


_start:
main:                                   ; Punto de inicio del programa        
        mov ebx, 0                     ; Inicializar ebx a 0 (contador)

copiaAcadena:                           ; Copiar el mensaje de inicio a la memoria
        mov al, [ebx+cadenaStr]        ; Cargar el siguiente carácter del mensaje
        mov [ebx+cadenaInicio], al     ; Guardar el carácter en la memoria de cadenaInicio
        inc ebx                        ; Incrementar el contador
        cmp al, 0                      ; Verificar si hemos llegado al final del mensaje
        jne copiaAcadena               ; Si no, continuar copiando
        call mostrarCadenaInicio       ; Mostrar el mensaje de inicio

        call leerCadena                ; Leer la cadena de 100 caracteres
        mov edi, 0                     ; Inicializar edi a 0 (índice de la cadena)

seguir1:                                ; Verificar que la cadena tenga exactamente 100 caracteres
        mov al,[edi + cadena]          ; Cargar el siguiente carácter de la cadena
        inc edi                        ; Incrementar el índice
        cmp al, 0                      ; Verificar si hemos llegado al final de la cadena
        jne seguir1                    ; Si no, continuar leyendo
        cmp edi, 101                   ; Comparar la longitud con 101 (100 caracteres + terminador nulo)
        je avanzo                      ; Si es 100, avanzar
        mov ebx, 0                     ; Reiniciar contador si no es de 100 caracteres
        call mostrarSaltoDeLinea       ; Mostrar salto de línea
        call mostrarCadenaError        ; Mostrar mensaje de error
        call mostrarSaltoDeLinea       ; Mostrar salto de línea
        jmp copiaAcadena               ; Volver a pedir la cadena

avanzo:
        mov edi, 0                     ; Inicializar edi a 0 (índice de la cadena)
        mov esi, 0                     ; Inicializar esi a 0 (índice del conjunto de caracteres válidos)
        mov eax, 0                     ; Inicializar eax a 0 (contador general)

seguir:                                ; Procesar cada carácter de la cadena
        mov al,[edi + cadena]          ; Cargar el siguiente carácter de la cadena
        cmp al, 0                      ; Verificar si hemos llegado al final de la cadena
        mov esi, -1                    ; Inicializar esi a -1 (índice de caracteres válidos)
        je salto                        ; Si llegamos al final, saltar

dejar:                                
        cmp al, [esi + caracteres]     ; Comparar el carácter con el conjunto de caracteres válidos
        jne siguiente                  ; Si no es válido, continuar con el siguiente carácter
        inc byte [esi + indices]       ; Si es válido, incrementar el contador de ese carácter

        inc edi                         ; Incrementar el índice de la cadena
        jmp seguir                      ; Volver al inicio del bucle

siguiente:
        inc esi                         ; Incrementar el índice del conjunto de caracteres válidos
        jmp dejar

salto:
        call mostrarSaltoDeLinea        ; Mostrar salto de línea

imprimir:
        inc esi                         ; Incrementar el índice de caracteres válidos
        mov al, byte [esi + indices]    ; Obtener el número de veces que el carácter se ha encontrado
        cmp al, 0                       ; Si el contador es 0, significa que no aparece
        je validaArray                  ; Si el contador es 0, continuar al siguiente carácter

        mov al, byte[esi + caracteres]  ; Cargar el carácter a imprimir
        mov [caracter], al              ; Guardar el carácter
        call mostrarCaracter            ; Mostrar el carácter

validaArray:        
        cmp esi, 95                     ; Comparar si ya hemos procesado todos los caracteres válidos
        jb imprimir                     ; Si no, continuar con el siguiente

finPrograma:
        call mostrarSaltoDeLinea        ; Mostrar salto de línea
        jmp salirDelPrograma            ; Salir del programa
