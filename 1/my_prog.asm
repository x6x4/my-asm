%  testы

in gdb: b success
		print (long long int) res
section .data 
	res:        dq 0

	d:			db 1
	e:			dw 1
	b:			dd -1
	c:			dd 1000000000
	a:			dq 1000000000

in gdb: b success
		print (char) res
section .data 
	res:        dq 0

	d:			db 1
	e:			dw 1
	b:			dd -1
	c:			dd 1
	a:			dq 1

division by zero (return code 1)
section .data 
	res:        dq 0

	d:			db 1
	e:			dw -1
	b:			dd 1
	c:			dd 1
	a:			dq 1

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
	mov r8, qword [a]
	xor r9, r9
	mov r9d, dword [b]
	xor r10, r10
	mov r10d, dword [c]
	xor r11, r11
	movsx r11, byte [d]
	xor r12, r12
	mov r12w, word [e]	
	mov r13, r12
	mov r14, r13

	; (e-b)*c*a -> r12
	sub r12d, r9d
	CheckOVF
	imul r12d, r10d
	CheckOVF
chk:
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
