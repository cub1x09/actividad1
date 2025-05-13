section .bss
    input_buffer resb 256
    print_buffer resb 12      ; Movido a .bss

section .data
    prompt_msg db "Introduce una cadena (max 255 caracteres): ", 0
    ; len_prompt equ $ - prompt_msg ; No se usa si usamos print_string_

    count_msg db "Numero de caracteres ingresados (sin Enter): ", 0
    ; len_count_msg equ $ - count_msg ; No se usa

    newline db 10, 0                ; NULO-terminada para print_string_z
    ; len_newline equ $ - newline -1 ; No se usa

; --- print_string_z (Calcula longitud hasta NULO) ---
section .text
    global _start

print_string_z:
    push rsi
    push rdx
    push rax
    push rdi

    mov rdx, 0
.strlen_loop_psz:
    cmp byte [rsi+rdx], 0
    je .strlen_done_psz
    inc rdx
    jmp .strlen_loop_psz
.strlen_done_psz:
    ; RDX tiene la longitud, RSI tiene la dirección
    mov rax, 1
    mov rdi, 1
    syscall

    pop rdi
    pop rax
    pop rdx
    pop rsi
    ret

; --- print_int64 (La versión que funcionó en pruebas aisladas) ---
print_int64:
    push rbx                    ; Preservar RBX
    push r10                    ; Preservar R10
    push rsi                    ; Preservar RSI (ya que lo usaremos para la syscall final)
    push rdx                    ; Preservar RDX (ya que lo usaremos para la syscall final)
    push rdi                    ; Preservar RDI (ya que lo usaremos para la syscall final)
    push rcx                    ; Preservar RCX

    mov r10, print_buffer + 10  ; R10 es el puntero de escritura, apunta a print_buffer[10]
    mov byte [print_buffer + 11], 0 ; Poner NULO al final

    cmp rax, 0
    jne .L_p64_convert_num_final

    ; Caso: RAX es cero
    mov byte [r10], '0'         ; Poner '0' en print_buffer[10]
    mov rsi, r10                ; RSI apunta al '0'
    mov rdx, 1                  ; Longitud es 1
    jmp .L_p64_do_syscall_final

.L_p64_convert_num_final:
.L_p64_conversion_loop_final:
    mov rbx, 10
    xor rdx, rdx                ; Limpiar RDX para div RDX:RAX / RBX
    div rbx                     ; RAX = Cociente, RDX = Resto
    add dl, '0'                 ; Convertir resto a ASCII
    mov [r10], dl               ; Guardar dígito en [R10]
    dec r10                     ; Mover puntero de escritura hacia la izquierda
    test rax, rax               ; ¿Cociente es cero?
    jnz .L_p64_conversion_loop_final ; Si no, continuar

    ; Bucle terminado. R10 apunta a la posición ANTES del primer dígito.
    mov rsi, r10
    inc rsi                     ; RSI ahora apunta al primer dígito de la cadena.
    mov rdx, print_buffer + 11  ; Puntero al NULO (final del buffer + 1)
    sub rdx, rsi                ; Longitud = (final+1) - inicio.

.L_p64_do_syscall_final:
    mov rax, 1                  ; syscall sys_write
    mov rdi, 1                  ; stdout
    ; RSI (dirección) y RDX (longitud) ya están configurados.
    syscall

    pop rcx
    pop rdi
    pop rdx
    pop rsi
    pop r10
    pop rbx
    ret

_start:
    ; 1. Mostrar el mensaje para pedir la cadena
    mov rsi, prompt_msg
    call print_string_z

    ; 2. Leer la cadena del usuario
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 255            ; Leer MÁXIMO 255 caracteres, sys_read pondrá el nulo si hay espacio
                            ; o leerá hasta que se presione Enter.
    syscall
    ; RAX = número de bytes leídos

    ; 3. Calcular el conteo de caracteres
    cmp rax, 0
    jle .set_count_to_zero

    ; Si se leyó algo (RAX > 0)
    dec rax                 ; Restar 1 para quitar el Enter.
                            ; Si solo se presionó Enter, RAX era 1, ahora es 0.
    jmp .count_done

.set_count_to_zero:
    xor rax, rax            ; Establecer conteo a 0

.count_done:
    ; RAX ahora tiene el número de caracteres sin el Enter (y es >= 0).

    ; 4. Mostrar el mensaje del contador
    mov rsi, count_msg
    call print_string_z

    ; 5. Imprimir el contador (que está en RAX)
    call print_int64

    ; 6. Imprimir una nueva línea final
    mov rsi, newline
    call print_string_z

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
