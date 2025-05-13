section .data
    ; Mensajes de salida
    msg_result   db "5! = ", 0
    len_result   equ $ - msg_result
    newline      db 0xA

section .bss
    output      resb 32    ; Buffer para almacenar el resultado en ASCII

section .text
    global _start

_start:
    ; --- Calcular factorial de 5 (predefinido) ---
    mov rax, 5             ; n = 5
    call factorial         ; RAX = 5!

    ; --- Convertir resultado (RAX) a ASCII ---
    mov rdi, output        ; Donde guardar el resultado
    call int_to_ascii

    ; --- Mostrar "5! = " ---
    mov rax, 1             ; sys_write
    mov rdi, 1             ; stdout
    mov rsi, msg_result
    mov rdx, len_result
    syscall

    ; --- Mostrar el resultado ---
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, 32            ; Longitud máxima
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

; ===== FUNCIONES =====
factorial:
    ; Calcula RAX! (predefinido)
    mov rcx, rax           ; RCX = n
    mov rax, 1             ; RAX = 1 (resultado)
    cmp rcx, 0
    je end_fact            ; Si n=0, retorna 1

fact_loop:
    imul rax, rcx          ; RAX *= RCX
    dec rcx                ; RCX--
    jnz fact_loop          ; Repetir si RCX > 0

end_fact:
    ret

int_to_ascii:
    ; Convierte RAX a ASCII y guarda en RDI
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
