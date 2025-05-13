section .data
    string1 db "Hola Mundo", 0      
    len1 equ $ - string1 -1         

    string2 db "Hola Mundo", 0      
    len2 equ $ - string2 -1         

    msg_iguales db "Las cadenas son iguales.", 10, 0
    len_iguales equ $ - msg_iguales

    msg_diferentes db "Las cadenas son diferentes.", 10, 0
    len_diferentes equ $ - msg_diferentes

section .text
    global _start


print_string:
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; stdout
    ; RSI y RDX son pasados por el llamador
    syscall
    ret

compare_strings:
    
.compare_loop:
    mov cl, byte [rdi]      
    mov dl, byte [rsi]      

    cmp cl, dl              
    jne .strings_are_different 


    cmp cl, 0               
    je .strings_are_same    


    inc rdi
    inc rsi
    jmp .compare_loop

.strings_are_different:
    mov rax, 1              
    ret

.strings_are_same:
    mov rax, 0              
    ret

_start:
 
    mov rdi, string1
    mov rsi, string2
    call compare_strings

   
    cmp rax, 0
    je .imprimir_iguales    


.imprimir_diferentes:
    mov rsi, msg_diferentes
    mov rdx, len_diferentes -1 
    call print_string
    jmp .exit

.imprimir_iguales:
    mov rsi, msg_iguales
    mov rdx, len_iguales -1   
    call print_string
    

.exit:
    mov rax, 60             
    xor rdi, rdi            
    syscall
