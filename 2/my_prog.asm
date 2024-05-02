; x/16bd &matrix

section .data
	size:        db 4
	align 1              
    matrix          db    1, 8, 7, 9,   \
						  8, -5, 2, 3,   \
						 10, -4, 9, 6,  \
						 14, 3, 2, 2   \

;   1  2  3 9
;   2  5  6 7
;   3  4  9 8
;   14 10 8 2

section .text
	global _start

%include "OddEvenSort.asm"

_start:

movzx r14, byte [size]
cmp r14, 3
jl exit 

;  rdi - the second elm of the first line
mov rdi, matrix

;  r13 - the one before last elm of first line
mov r13, matrix
add r13, r14
sub r13, 1

mov r15, r14    ;  size in r15
dec r14

upper_part:
	; move along the row 
	add rdi, 1

	call OddEvenSort
	sub r14, 1

	cmp rdi, r13
jl upper_part

xor rax, rax
mov rax, r15
imul r15        ;  rax - the number of elms in mx

mov rdi, matrix 

mov r13, matrix
add r13, rax
sub r13, r15 
sub r13, r15    ; the 1st elm of one before last line 

mov r14, r15
dec r14

lower_part:
	; move along the column
	iterate rdi, r15 
	sub rdi, 1

	call OddEvenSort
	sub r14, 1

	cmp rdi, r13
jl lower_part



exit:
	mov edi, 0
	mov rax, 60         
	syscall
