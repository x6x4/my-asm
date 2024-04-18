% x/16bd &matrix

section .data
	size:        db 4
	align 1              
    matrix          db    1, 6, 3, 9,   \
						  8, 5, 2, 7,   \
						 10, 4, 9, 8,  \
						 14, 3, 2, 2   \

section .text
	global _start

;  swaps values on two addresses
%macro swap 2 
	xor r9, r9
	xor r10, r10
	movzx r9, byte [%1]
	movzx r10, byte [%2]
    mov [%1], r10
    mov [%2], r9
%endmacro


%macro iterate 1
	add %1, [size]
%endmacro

;  takes list head and its length
    global OddEvenSort

OddEvenSort:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx 
    xor rsi, rsi

    mov rax, 0           ; sorted
    mov rdx, qword [rsp + 8]  ; list length
    sub rdx, 1           ; list.length - 1
    mov rbx, qword [rsp + 16] ; list head 

while_loop:
    mov rax, 1

    mov rcx, 1             ; i
    mov rsi, rbx           ; list+0
    iterate rsi            ; list+1

for_loop_1: 
    cmp rcx, rdx       ; i < list.length - 1
    jge end_for_loop_1
    
    mov r11, rsi        ; list+i
    iterate r11         ; list+i+1

	movzx r9, byte [rsi]
    cmp r9, [r11]
    jle end_cond1
    	swap rsi, r11 
    	mov rax, 0
	end_cond1:

    add rcx, 2
    iterate rsi
    jmp for_loop_1

end_for_loop_1:

    mov rcx, 0             ; i
    mov rsi, rbx           ; list+0
for_loop_2: 
    cmp rcx, rdx       ; i < list.length - 1
    jge end_for_loop_2
    
    mov r11, rsi        ; list+i
    iterate r11         ; list+i+1

    movzx r9, byte [rsi]
    cmp r9, [r11]
    jle end_cond2
    	swap rsi, r11
    	mov rax, 0
	end_cond2:

    add rcx, 2
    iterate rsi
    jmp for_loop_2

end_for_loop_2:
  
cmp rax, 0
je while_loop

ret



_start:

movzx r14, byte [size]
cmp r14, 3
jl exit 

mov rdi, matrix
add rdi, 1
mov r13, matrix
add r13, r14
sub r13, 1

upper_part:
	mov r12, r14
	sub r12, rdi
    push rdi
	push r12
	call OddEvenSort 
	add rdi, 1
	cmp rdi, r13
jl upper_part

mov rdi, r13
mov r13, matrix
xor rax, rax
mov rax, r14
imul r14
add r13, rax
sub r13, r14
sub r13, 1

lower_part:
	mov r12, r14
	sub r12, rdi
    push rdi
	push r12
	call OddEvenSort 
	add rdi, r14
	cmp rdi, r13
jl lower_part



exit:
	mov edi, 0
	mov rax, 60         
	syscall
