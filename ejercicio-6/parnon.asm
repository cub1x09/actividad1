section .data
    msg db "Ingresa un dígito del 0 al 9: ", 0
    len_msg equ $ - msg

    par_msg db "Es par", 10, 0
    len_par equ $ - par_msg

    impar_msg db "Es impar", 10, 0
    len_impar equ $ - impar_msg

    cero_msg db "Es cero", 10, 0
    len_cero equ $ - cero_msg

section .bss
    input resb 2   ; un carácter + enter

section .text
    global _start

_start:
    ; imprimir mensaje
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    mov rsi, msg
    mov rdx, len_msg
    syscall

    ; leer un carácter
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, input
    mov rdx, 2          ; leer máximo 2 bytes (carácter + enter)
    syscall

    ; validar si es número
    mov al, [input]
    cmp al, '0'
    jb _exit
    cmp al, '9'
    ja _exit

    ; comprobar si es cero
    cmp al, '0'
    je mostrar_cero

    ; convertir a número y verificar par/impar
    sub al, '0'
    xor ah, ah          ; AL → AX
    mov bl, 2
    div bl              ; AX / 2
    cmp ah, 0
    je mostrar_par

mostrar_impar:
    mov rax, 1
    mov rdi, 1
    mov rsi, impar_msg
    mov rdx, len_impar
    syscall
    jmp _exit

mostrar_par:
    mov rax, 1
    mov rdi, 1
    mov rsi, par_msg
    mov rdx, len_par
    syscall
    jmp _exit

mostrar_cero:
    mov rax, 1
    mov rdi, 1
    mov rsi, cero_msg
    mov rdx, len_cero
    syscall

_exit:
    mov rax, 60     ; syscall exit
    xor rdi, rdi
    syscall

