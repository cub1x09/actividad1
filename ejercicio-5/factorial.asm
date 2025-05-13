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
    mov rdx, 32            
    syscall

    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    
    mov rax, 60            
    xor rdi, rdi           
    syscall

; ===== FUNCIONES =====
factorial:
    ; Calcula RAX! (predefinido)
    mov rcx, rax           
    mov rax, 1             
    cmp rcx, 0
    je end_fact            

fact_loop:
    imul rax, rcx          
    dec rcx                
    jnz fact_loop          

end_fact:
    ret

int_to_ascii:
    
    push rdi
    push rsi
    push rcx
    mov rbx, 10            
    xor rcx, rcx           

    ; Caso especial para 0
    test rax, rax
    jnz convert
    mov byte [rdi], '0'
    inc rdi
    jmp done

convert:
    xor rdx, rdx
    div rbx                
    add dl, '0'            
    push rdx               
    inc rcx                
    test rax, rax
    jnz convert

    
store:
    pop rdx
    mov [rdi], dl          
    inc rdi
    loop store

done:
    mov byte [rdi], 0      ; Null-terminator
    pop rcx
    pop rsi
    pop rdi
    ret
