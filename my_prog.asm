section .text
    global main

%define SUCCESS 0
%define DIVZERO 1
%define OVERFLOW  2
%define SIGFPE 8

	extern signal

main:
	sub rsp, 8   
	lea	rax, [rel signal_handler]
	mov rsi, rax
	mov edi, SIGFPE
	call signal WRT ..plt
	add rsp, 8

    ; Evaluate the arithmetic expression
    ; a(e-b)c/(e+d)-(d+b)/e 

    ; Load the values of a, b, c, d, and e into registers
	mov qword r8, [a]
    mov dword r9d, [b]
    mov dword r10d, [c]
label:
    xor r11, r11
	mov byte r11b, [d]
    mov word r12w, [e]
	
	mov r13, r12
	mov r14, r13

    ; Calculate the intermediate values
    ; ((e-b)*c)
    sub r12d, r9d
    imul r12d, r10d

    ; (e+d)
    add r13w, r11w

    ; (d+b)/e
    add r11d, r9d
    mov eax, r11d
	cqo
	idiv r14d

    ; (a * ((e-b)*c)) / (e+d) - ((d+b)/e)
    imul r8, r12
    cqo
    idiv r13

	sub r13, r14

    ; Store the result
    mov qword [res], r13

    ; Exit the program
    ret

signal_handler:
   ; Exit the program with error code`
	mov rax, 60         ; sys_exit
    mov edi, DIVZERO    ; error code
    syscall


section .data
res:        dq 0

d:			db 5
e:			dw 0
b:			dd 3
c:			dd 4
a:			dq 2
