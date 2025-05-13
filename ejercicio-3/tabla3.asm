section .data
    msg1   db '3 x ', 0
    msg2   db ' = ', 0
    salto  db 0xA, 0

section .bss
    num_str  resb 3     
    res_str  resb 4     

section .text
    global _start

_start:
    mov esi, 1          

bucle:
 
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 4
    int 0x80

   
    mov eax, esi
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, num_str
    mov edx, 2
    int 0x80


    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 3
    int 0x80

    
    mov eax, 3
    mov ebx, esi
    mul ebx        

  
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, num_str
    mov edx, 3
    int 0x80

  
    mov eax, 4
    mov ebx, 1
    mov ecx, salto
    mov edx, 1
    int 0x80

  
    inc esi
    cmp esi, 11
    jle bucle

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80


int_to_str:
    mov edi, num_str
    xor edx, edx
    mov ebx, 10
    div ebx          
    add dl, '0'
    mov [edi+1], dl   ; unidad

    add al, '0'
    mov [edi], al     ; decena

    ret
