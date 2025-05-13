section .bss
    input resb 1
    stack resb 6

section .data
    msg1 db 10,10,"LEE SEIS DIGITOS Y LOS INSERTA EN EL STACK",10,0
    len1 equ $ - msg1

    msg2 db "LUEGO LOS EXTRAE EN EL ORDEN LIFO",10,0
    len2 equ $ - msg2

    msg3 db "Ingresa un digito (0–9): ",0
    len3 equ $ - msg3

    msg4 db 10,"Impresion de datos en orden LIFO:",10,0
    len4 equ $ - msg4

section .text
    global _start

_start:

    ; Mostrar mensaje 1
    mov rax, 1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, len1
    syscall

    ; Mostrar mensaje 2
    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, len2
    syscall

    xor rbx, rbx        ; índice = 0

read_loop:
    ; Mostrar mensaje de ingreso
    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, len3
    syscall

wait_input:
    ; Leer 1 byte
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 1
    syscall

    mov al, [input]
    cmp al, 10          ; enter
    je wait_input
    cmp al, '0'
    jb wait_input
    cmp al, '9'
    ja wait_input

    ; Guardar en stack
    mov [stack + rbx], al
    inc rbx
    cmp rbx, 6
    jl read_loop

    ; Mostrar mensaje
    mov rax, 1
    mov rdi, 1
    mov rsi, msg4
    mov rdx, len4
    syscall

    ; Imprimir en orden LIFO
    mov rbx, 6

print_loop:
    dec rbx
    mov al, [stack + rbx]
    mov [input], al

    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, 1
    syscall

    cmp rbx, 0
    jne print_loop

    ; Salto de línea final
    mov byte [input], 10
    mov rax, 1
    mov rdi, 1
    mov rsi, input
    mov rdx, 1
    syscall

    ; Salir
    mov rax, 60
    xor rdi, rdi
    syscall

