section .data
    num1        dq 8       ; Primer número (cambiable)
    num2        dq 5       ; Segundo número (cambiable)
    msg_mayor   db "El mayor es: ", 0
    len_mayor   equ $ - msg_mayor
    newline     db 0xA

section .bss
    output      resb 32    ; Buffer para almacenar el número en ASCII

section .text
    global _start

_start:
    ; --- Comparar num1 y num2 ---
    mov rax, [num1]
    mov rbx, [num2]
    cmp rax, rbx
    jg mayor_num1          ; Si num1 > num2
    ; Si no, num2 es mayor o igual
    mov rax, rbx           ; RAX = num2 (mayor)

mayor_num1:
    ; RAX ya contiene el mayor (num1 o num2)

    ; --- Convertir el mayor (RAX) a ASCII ---
    mov rdi, output
    call int_to_ascii

    ; --- Mostrar "El mayor es: " ---
    mov rax, 1             ; sys_write
    mov rdi, 1             ; stdout
    mov rsi, msg_mayor
    mov rdx, len_mayor
    syscall

    ; --- Mostrar el número mayor ---
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, 32
    syscall

    ; --- Nueva línea ---
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Salir ---
    mov rax, 60            ; sys_exit
    xor rdi, rdi           ; status 0
    syscall

; ===== FUNCIÓN PARA CONVERTIR NÚMERO A ASCII =====
int_to_ascii:
    push rdi
    push rsi
    push rcx
    mov rbx, 10            ; Base 10
    xor rcx, rcx           ; Contador de dígitos

    ; Caso especial para 0
    test rax, rax
    jnz convert
    mov byte [rdi], '0'
    inc rdi
    jmp done

convert:
    xor rdx, rdx
    div rbx                ; RDX = residuo, RAX = cociente
    add dl, '0'            ; Convertir a ASCII
    push rdx               ; Guardar dígito en pila
    inc rcx                ; Incrementar contador
    test rax, rax
    jnz convert

    ; Extraer dígitos en orden correcto
store:
    pop rdx
    mov [rdi], dl          ; Guardar en buffer
    inc rdi
    loop store

done:
    mov byte [rdi], 0      ; Null-terminator
    pop rcx
    pop rsi
    pop rdi
    ret
