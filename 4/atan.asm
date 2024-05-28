bits 64
default rel
global main
extern printf, scanf, fopen, fclose, fprintf, atan

section .data
fmtInt:     db "%d", 0
fmtDouble: db "%lf", 0
file_name: db "members.txt", 0

num_of_terms: db 4

cur_pow dw 1  ; текущая степень
cur_num dw 1   ; текущий номер члена ряда
cur_term: dq 0.0

section .bss
inputX: resq 1
atanC: resq 1
atanNasm: resq 1

section .text
main:
    sub     rsp, 8

    lea     rdi, [fmtDouble]
    lea     rsi, [inputX]
    mov     al, 0     
    call    scanf wrt ..plt
   
    ;lea     rdi, [fmtInt]
    ;lea     rsi, [num_of_terms]
    ;mov     al, 0    
    ;call    scanf wrt ..plt

    add     rsp, 8
    sub     rax, rax

    fld qword [inputX]
    fld1    
	fpatan
    fst qword [atanC]

    ret