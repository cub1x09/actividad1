section .data
    msg db "Hola Mundo!", 0xa  ; La cadena de texto y un salto de línea (0xa)
    len equ $ - msg           ; Calcula la longitud de la cadena automáticamente

section .text
    global _start             ; Punto de entrada para el enlazador

_start:
    ; Syscall para escribir en pantalla (sys_write)
    mov eax, 4                ; Número de la llamada al sistema sys_write (32 bits)
    mov ebx, 1                ; Descriptor de archivo 1 (stdout - salida estándar)
    mov ecx, msg              ; Dirección del mensaje a escribir
    mov edx, len              ; Longitud del mensaje
    int 0x80                  ; Llamada al kernel para ejecutar la syscall

    ; Syscall para salir del programa (sys_exit)
    mov eax, 1                ; Número de la llamada al sistema sys_exit (32 bits)
    mov ebx, 0                ; Código de salida 0 (sin errores)
    int 0x80                  ; Llamada al kernel para ejecutar la syscall
