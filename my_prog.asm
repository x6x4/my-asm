section .text
    global _start

%define SUCCESS 0
%define DIVZERO 1
%define OVERFLOW  2

_start:
	mov eax, 7
    ; Access and use the defined data labels here
	mov rax, 60
	mov rdi, 0
	syscall


section .data
d:			db 64
e:			dw 7451
b:			dd -861213508
c:			dd -1009975939
a:			dq 3962771202563850414
