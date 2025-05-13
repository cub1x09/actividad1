section .data
    msg1   db '3 x ', 0
    msg2   db ' = ', 0
    salto  db 0xA, 0

section .bss
    num_str  resb 3     ; Para el número multiplicador (1-10)
    res_str  resb 4     ; Para el resultado (hasta 30)

section .text
    global _start

_start:
    mov esi, 1          ; contador (1 al 10)

bucle:
    ; Imprimir "3 x "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 4
    int 0x80

    ; Mostrar multiplicador (esi)
    mov eax, esi
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, num_str
    mov edx, 2
    int 0x80

    ; Imprimir " = "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 3
    int 0x80

    ; Calcular 3 * esi
    mov eax, 3
    mov ebx, esi
    mul ebx         ; resultado en eax

    ; Mostrar resultado
    call int_to_str
    mov eax, 4
    mov ebx, 1
    mov ecx, num_str
    mov edx, 3
    int 0x80

    ; Imprimir salto de línea
    mov eax, 4
    mov ebx, 1
    mov ecx, salto
    mov edx, 1
    int 0x80

    ; Incrementar contador
    inc esi
    cmp esi, 11
    jle bucle

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; -----------------------------
; Convierte valor en EAX a ASCII
; Guarda en [num_str]
int_to_str:
    mov edi, num_str
    xor edx, edx
    mov ebx, 10
    div ebx           ; eax = eax / 10, edx = resto (unidad)
    add dl, '0'
    mov [edi+1], dl   ; unidad

    add al, '0'
    mov [edi], al     ; decena

    ret
