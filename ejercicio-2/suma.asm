section .text
    global _start   ; Punto de entrada para el enlazador

_start:
    ; --- Programa Principal ---

    ; 1. Colocar los números a sumar en registros
    mov eax, 5     ; Ponemos el primer número (5) en el registro EAX
    mov ebx, 10    ; Ponemos el segundo número (10) en el registro EBX

    ; 2. Realizar la suma
    add eax, ebx   ; Suma el contenido de EBX al de EAX.
                   ; El resultado (5 + 10 = 15) queda almacenado en EAX.

    ; 3. Preparar la salida del programa
    ; Usaremos la llamada al sistema 'sys_exit'.
    ; El resultado de la suma (que está en EAX) lo moveremos a EBX,
    ; ya que 'sys_exit' espera el código de salida en EBX.
    mov ebx, eax   ; Mueve el resultado (15) de EAX a EBX.

    ; 4. Llamar al sistema para terminar (sys_exit)
    mov eax, 1     ; Número de la llamada al sistema sys_exit (finalizar programa)
    int 0x80       ; Llama al kernel para ejecutar la syscall.
                   ; El programa terminará y devolverá el valor de EBX (15) como código de salida.

; --- Fin del Programa ---
