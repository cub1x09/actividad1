section .bss
    input_num_str resb 6
    vectorA resd 4
    vectorB resd 4
    print_buffer resb 12      

section .data
    msgA db "Ingresa 4 numeros para el Vector A (uno por linea):", 10, 0
    lenA equ $ - msgA
    msgB db 10, "Ingresa 4 numeros para el Vector B (uno por linea):", 10, 0
    lenB equ $ - msgB
    msgR db 10, "Resultados de la multiplicacion (A[i] * B[i]):", 10, 0
    lenR equ $ - msgR
    newline db 10
    len_newline equ $ - newline

section .text
    global _start

read_int:
    push rbx                    
    mov rax, 0
    mov rdi, 0
    mov rsi, input_num_str
    mov rdx, 5
    syscall
    xor eax, eax
    mov rsi, input_num_str
    mov rcx, 0
.read_loop:
    mov cl, byte [rsi]
    inc rsi
    cmp cl, 10
    je .read_done
    cmp cl, '0'
    jl .read_done_err
    cmp cl, '9'
    jg .read_done_err
    sub cl, '0'
    mov ebx, 10                 
    imul eax, ebx
    add eax, ecx
    jmp .read_loop
.read_done_err:
.read_done:
    pop rbx                     
    ret


print_int_debug:
    push rbx                    

    mov rdi, print_buffer
    mov rcx, 10
.fill_spaces_loop:
    mov byte [rdi], ' '
    inc rdi
    dec rcx
    jnz .fill_spaces_loop

    mov byte [print_buffer+10], 10 ; Salto de línea

    mov rdi, print_buffer + 9

    cmp eax, 0
    je .L_debug_print_zero_char

.L_debug_convert_loop:
    mov ebx, 10                 
    xor edx, edx
    div ebx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    cmp rdi, print_buffer-1     
    je .L_debug_print_now
    test eax, eax
    jnz .L_debug_convert_loop
    jmp .L_debug_print_now

.L_debug_print_zero_char:
    mov byte [rdi], '0'

.L_debug_print_now:
    mov rax, 1
    mov rdi, 1
    mov rsi, print_buffer
    mov rdx, 11                 
    syscall

    pop rbx                     
    ret

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msgA
    mov rdx, lenA
    syscall
    mov rbx, 0
.leerA_loop:
    call read_int
    mov [vectorA + rbx], eax
    add rbx, 4
    cmp rbx, 16
    jne .leerA_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, msgB
    mov rdx, lenB
    syscall
    mov rbx, 0
.leerB_loop:
    call read_int
    mov [vectorB + rbx], eax
    add rbx, 4
    cmp rbx, 16
    jne .leerB_loop

    mov rax, 1
    mov rdi, 1
    mov rsi, msgR
    mov rdx, lenR
    syscall

    mov rbx, 0                  
.mul_loop:
    mov eax, [vectorA + rbx]
    imul eax, [vectorB + rbx]

    call print_int_debug      

    add rbx, 4
    cmp rbx, 16
    jne .mul_loop

    mov rax, 60
    xor rdi, rdi
    syscall
