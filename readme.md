
##### Ejercicios:<br>
1.Dado un entero N, la computadora lo muestra descompuesto en sus factores primos. Ej: 132 = 2 × 2 × 3 × 11<br>
2.Se ingresa una cadena. La computadora muestra las subcadenas formadas por las posiciones pares e impares de la cadena. Ej: FAISANSACRO : ASNAR FIASCO<br>
3.Se ingresa un año. La computadora indica si es,o no, bisiesto.<br>
4.Se ingresan un entero N y, a continuación, N números enteros. La computadora muestra el promedio de los números impares ingresados y la suma de los pares.<br>
5.Se ingresan 100 caracteres. La computadora los muestra ordenados sin repeticiones.<br>
6.Se ingresa N. La computadora muestra los primeros N términos de la Secuencia de Connell.<br>
7.Se ingresa una matriz de NxM componentes. La computadora la muestra girada 90° en sentido antihorario.<br>
8.Se ingresa una matriz de NxNcomponentes enteras. La computadora muestra la matriz transpuesta.<br>


### Pasos para ejecutar ejercicios :

En Windows:<br>
1) `nasm -f win32 numej.asm --PREFIX _`
2) `gcc numej.obj -o numej.exe`
3) `numej`

Ejemplo:<br>
1) `nasm -f win32 1.asm --PREFIX _`
2) `gcc 1.obj -o 1.exe`
3) `1`