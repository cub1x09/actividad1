section .bss
    input_buffer resb 256
    print_buffer resb 12      ; Movido a .bss

section .data
    prompt_msg db "Introduce una cadena (max 255 caracteres): ", 0
    

    count_msg db "Numero de caracteres ingresados (sin Enter): ", 0
    

    newline db 10, 0                

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
    
    mov rax, 1
    mov rdi, 1
    syscall

    pop rdi
    pop rax
    pop rdx
    pop rsi
    ret

print_int64:
    push rbx                    
    push r10                    
    push rsi                    
    push rdx                    
    push rdi                    
    push rcx                    

    mov r10, print_buffer + 10  
    mov byte [print_buffer + 11], 0 

    cmp rax, 0
    jne .L_p64_convert_num_final

    ; Caso: RAX es cero
    mov byte [r10], '0'         
    mov rsi, r10                
    mov rdx, 1                  
    jmp .L_p64_do_syscall_final

.L_p64_convert_num_final:
.L_p64_conversion_loop_final:
    mov rbx, 10
    xor rdx, rdx                
    div rbx                     
    add dl, '0'                 
    mov [r10], dl               
    dec r10                     
    test rax, rax               
    jnz .L_p64_conversion_loop_final 

    
    mov rsi, r10
    inc rsi                     
    mov rdx, print_buffer + 11  
    sub rdx, rsi                

.L_p64_do_syscall_final:
    mov rax, 1                  
    mov rdi, 1                  
    
    syscall

    pop rcx
    pop rdi
    pop rdx
    pop rsi
    pop r10
    pop rbx
    ret

_start:
    
    mov rsi, prompt_msg
    call print_string_z

    
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 255            

    syscall
    

    
    cmp rax, 0
    jle .set_count_to_zero

    ; Si se leyó algo (RAX > 0)
    dec rax                

    jmp .count_done

.set_count_to_zero:
    xor rax, rax            

.count_done:
  
    mov rsi, count_msg
    call print_string_z

  
    call print_int64

  
    mov rsi, newline
    call print_string_z

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
