section .text
    global _start

_start:
    mov eax, 5
    mov ebx, 10
    add eax, ebx
    mov ebx, eax
    mov eax, 1
    int 0x80
