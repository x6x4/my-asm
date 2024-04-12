section .text
    global _start

%define SUCCESS 0
%define DIVZERO 1
%define OVERFLOW  2

section .text
global _start

_start:
    ; Evaluate the arithmetic expression
    ; a(e-b)c/(e+d)-(d+b)/e 

    ; Load the values of a, b, c, d, and e into registers
    mov rax, [a]
    mov rbx, [b]
    mov rcx, [c]
    mov rdx, [d]
    mov rsi, [e]

    ; Calculate the intermediate values
    ; ((e-b)*c)
    sub rsi, rbx
    imul rsi, rcx

    ; (e+d)
    add rsi, rdx

    ; (d+b)/e
    add rdx, rbx
    cqo
    idiv rsi

    ; (a * ((e-b)*c)) / (e+d) - ((d+b)/e)
    imul rax, rsi
    cqo
    idiv rdx

    ; Store the result
    mov qword [res], rax

    ; Handle division by zero exception
    test rdx, rdx
    jz division_by_zero

    ; If no exception, continue

    ; Exit the program
    mov rax, 60         ; sys_exit
    mov edi, SUCCESS    ; exit code
    syscall

division_by_zero:
   ; Exit the program with error code
    mov rax, 60         ; sys_exit
    mov edi, DIVZERO    ; error code
    syscall


section .data
res:        dq 0

d:			db 64
e:			dw 7451
b:			dd -861213508
c:			dd -1009975939
a:			dq 3962771202563850414
