section .data
    num1        dq 8       
    num2        dq 5       
    msg_mayor   db "El mayor es: ", 0
    len_mayor   equ $ - msg_mayor
    newline     db 0xA

section .bss
    output      resb 32    

section .text
    global _start

_start:
    
    mov rax, [num1]
    mov rbx, [num2]
    cmp rax, rbx
    jg mayor_num1          
    
    mov rax, rbx           

mayor_num1:
    
    mov rdi, output
    call int_to_ascii

    mov rax, 1             
    mov rdi, 1             
    mov rsi, msg_mayor
    mov rdx, len_mayor
    syscall

    
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

    mov rax, 60            ; sys_exit
    xor rdi, rdi           ; status 0
    syscall

int_to_ascii:
    push rdi
    push rsi
    push rcx
    mov rbx, 10            ; Base 10
    xor rcx, rcx           ; Contador de dígitos

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
store:
    pop rdx
    mov [rdi], dl          
    inc rdi
    loop store

done:
    mov byte [rdi], 0      
    pop rcx
    pop rsi
    pop rdi
    ret
