bits    64
default rel
global  main
extern  scanf

section .data
    format_3x_lf    db '%lf %lf %lf', 0

section .bss
    array_double    resq 3

section .text
    main:
        sub     rsp, 8

        lea     rcx, [array_double + 16]    ; 4th integer/pointer argument
        lea     rdx, [array_double + 8]     ; 3rd integer/pointer argument
        lea     rsi, [array_double + 0]     ; 2nd integer/pointer argument
        lea     rdi, [format_3x_lf]         ; 1st integer/pointer argument
        mov     al, 0                       ; no floating-point arguments
        call    scanf wrt ..plt

        add     rsp, 8
        sub     rax, rax
        ret