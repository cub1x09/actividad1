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

; --- Función para imprimir una cadena ---
; Entrada: RSI = dirección de la cadena, RDX = longitud (sin NULO)
print_string:
    mov rax, 1          ; syscall sys_write
    mov rdi, 1          ; stdout
    ; RSI y RDX son pasados por el llamador
    syscall
    ret

; --- Función para comparar dos cadenas NULO-terminadas ---
; Entrada:
;   RDI = puntero a la primera cadena
;   RSI = puntero a la segunda cadena
; Salida:
;   RAX = 0 si son iguales
;   RAX = 1 si son diferentes (o si una es prefijo de la otra y tienen distinta longitud)
compare_strings:
    ; RCX y RDX serán usados para los caracteres actuales
.compare_loop:
    mov cl, byte [rdi]      ; Cargar byte de string1 en CL
    mov dl, byte [rsi]      ; Cargar byte de string2 en DL

    cmp cl, dl              ; Comparar los bytes
    jne .strings_are_different ; Si son diferentes, las cadenas son diferentes

    ; Si los bytes son iguales, verificar si hemos llegado al final de AMBAS cadenas
    cmp cl, 0               ; ¿Es el carácter actual NULO (fin de string1)?
    je .strings_are_same    ; Si sí, y eran iguales hasta aquí, y string2 también es NULO, son iguales.
                            ; (Si string1 es NULO y string2 no, cmp cl,dl ya habría fallado antes si string2 tuviera más caracteres)
                            ; (Si string2 es NULO y string1 no, cmp cl,dl fallaría si string1 tiene más caracteres)

    ; Si no es NULO y los caracteres son iguales, avanzar punteros y continuar
    inc rdi
    inc rsi
    jmp .compare_loop

.strings_are_different:
    mov rax, 1              ; Código de retorno para "diferentes"
    ret

.strings_are_same:
    mov rax, 0              ; Código de retorno para "iguales"
    ret

_start:
    ; Configurar argumentos para compare_strings
    mov rdi, string1
    mov rsi, string2
    call compare_strings

    ; Verificar el resultado de la comparación (en RAX)
    cmp rax, 0
    je .imprimir_iguales    ; Si RAX es 0, son iguales

    ; Son diferentes
.imprimir_diferentes:
    mov rsi, msg_diferentes
    mov rdx, len_diferentes -1 ; Longitud sin el NULO para print_string
    call print_string
    jmp .exit

.imprimir_iguales:
    mov rsi, msg_iguales
    mov rdx, len_iguales -1   ; Longitud sin el NULO para print_string
    call print_string
    ; jmp .exit (cae naturalmente)

.exit:
    mov rax, 60             ; syscall sys_exit
    xor rdi, rdi            ; Código de salida 0
    syscall
