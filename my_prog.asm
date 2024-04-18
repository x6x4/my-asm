section .data
    res:        dq 0

    d:			db 2
    e:			dw 0
    b:			dd 3
    c:			dd 100000
    a:			dq 10000000000

section .text
    global main

%define SUCCESS 0
%define DIVZERO 1
%define SGN_OVF 2

%define SIGFPE 8
	
    extern signal

%macro CheckOVF 0
    jo sgn_ovf_handler
%endmacro

main:
	sub rsp, 8   
	lea	rax, [rel divzero_handler]
	mov rsi, rax
	mov edi, SIGFPE
	call signal WRT ..plt
	add rsp, 8

    ; Evaluate the arithmetic expression
    ; a*(e-b)*c/(e+d)-(d+b)/e 

    ; Load the values of a, b, c, d, and e into registers
	mov qword r8, [a]
    xor r9, r9
    mov dword r9d, [b]
    xor r10, r10
    mov dword r10d, [c]
    xor r11, r11
	mov byte r11b, [d]
    xor r12, r12
    mov word r12w, [e]	
	mov r13, r12
	mov r14, r13
chk:
    ; (e-b)*c*a -> r12
    sub r12d, r9d
    CheckOVF
    imul r12d, r10d
    CheckOVF
    imul r12, r8
    CheckOVF

    ; (e+d) -> r13
    add r13w, r11w
    CheckOVF

    ; (d+b)/e -> r14
    add r11d, r9d
    CheckOVF
    mov eax, r11d
	cqo
	idiv r14d
    mov r14d, eax

    ; a*(e-b)*c / (e+d) -> r13
    mov rax, r12
    cqo
    idiv r13
    mov r12, rax

    ; a*(e-b)*c / (e+d) - (d+b)/e -> r13
	sub r12, r14
    CheckOVF

    ; Store the result
    mov qword [res], r12

success:
    mov edi, SUCCESS    
    jmp exit

divzero_handler:
    mov edi, DIVZERO   
    jmp exit
sgn_ovf_handler:
    mov edi, SGN_OVF   
    jmp exit


exit:
    mov rax, 60         
    syscall



