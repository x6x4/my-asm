
;  swaps values on two addresses in rsi and r11,
;  sets sorted in rax to false

global Swap

Swap: 
    xor r9, r9
    movzx r9, byte [rsi]
    cmp r9b, byte [r11]
%ifdef descend
    jge end_swap
%else
    jle end_swap
%endif
        xor r9, r9
        xor r10, r10
        movzx r9, byte [rsi]
        movzx r10, byte [r11]
        mov [rsi], r10b
        mov [r11], r9b
        mov rax, 0
    end_swap: 
ret 


%macro iterate 2
	add %1, %2
    inc %1
%endmacro

;  takes list head, its length and matrix parameter in rdi, r14, r15
    global OddEvenSort

OddEvenSort:
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx 
    xor rsi, rsi

    mov rax, 0           ; sorted
    mov rdx, r14  ; list length
    sub rdx, 1
    mov rbx, rdi ; list head 
    mov r12, r15 ; matrix parameter

while_loop:
    mov rax, 1

    mov rcx, 1             ; i
    mov rsi, rbx           ; diag 0
    iterate rsi, r12       ; diag 1

for_loop_odd: 
    cmp rcx, rdx       ; i < list.length - 1
    jge end_for_loop_odd
    
    mov r11, rsi        
    iterate r11, r12    ; diag next 

    call Swap 

    add rcx, 2          
    mov rsi, r11        
    iterate rsi, r12    ; diag cur
jmp for_loop_odd

end_for_loop_odd:

    mov rcx, 0             ; i
    mov rsi, rbx           ; list+0

for_loop_even: 
    cmp rcx, rdx       ; i < list.length - 1
    jge end_for_loop_even
    
    mov r11, rsi       
    iterate r11, r12   ; diag next 

    call Swap

    add rcx, 2
    iterate rsi, r12
    jmp for_loop_even  ; diag cur

end_for_loop_even:
  
    cmp rax, 0
je while_loop

ret