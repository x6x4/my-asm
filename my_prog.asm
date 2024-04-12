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
    mov r8, [a]
    mov r9d, [b]
    mov r10d, [c]
    mov dl, [d]
    mov r12w, [e]
	mov r13w, r12w
	mov r14w, r13w

    ; Calculate the intermediate values
    ; ((e-b)*c)
    sub r12d, r9d
    imul r12d, r10d

    ; (e+d)
    add r13w, dx

    ; (d+b)/e
    add edx, r9d
    cqo
    idiv r14d
	call check_divzero

    ; (a * ((e-b)*c)) / (e+d) - ((d+b)/e)
    imul r8, r12
    cqo
    idiv r13
	call check_divzero

	sub r13, r14

    ; Store the result
    mov qword [res], r13

    ; Exit the program
    mov rax, 60         ; sys_exit
    mov edi, SUCCESS    ; exit code
    syscall

check_divzero:
	pushf
	pop rdi
	and edi, 0x10
	jnz divzero
	ret

divzero:
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
