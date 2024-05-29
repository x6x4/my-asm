bits 64
default rel
global main
extern printf, scanf
extern fopen, fclose, fprintf, exit

section .rodata

fmtInt:         db "%d", 0
fmtDouble:      db "%lf", 0
file_name:      db "members.txt", 0
file_mode:      db "w", 0
atanLeftStr:    db "left part: %.15lf", 10, 0
atanMember:     db "%d %.15lf", 10, 0
atanRightStr:   db "right part: %.15lf", 10, 0

section .data

num_of_terms: dq 0

cur_pow: dq 1
cur_num: dq 1       ; текущий номер члена ряда
cur_term: dq 0.0


section .bss
inputX: resq 1
atanLeft: resq 1
atanNasm: resq 1

section .text
main:
    sub     rsp, 8
    
    lea     rdi, [fmtDouble]
    lea     rsi, [inputX]
    mov     al, 0     
    call    scanf wrt ..plt
   
    lea     rdi, [fmtInt]
    lea     rsi, [num_of_terms]
    mov     al, 0    
    call    scanf wrt ..plt

    add     rsp, 8

    fld qword [inputX]
    fld1    
	fpatan
    fst qword [atanLeft]

    push rbp
    lea     rdi, [atanLeftStr]	
    movq    xmm0, qword [atanLeft]
    mov     rax, 1
    call    printf wrt ..plt
    pop	rbp	

    call atanRight

    push rbp
    sub     rsp, 16
    lea rdi, [atanRightStr]
    movsd xmm0, qword [atanNasm]  
    call printf wrt ..plt
    add     rsp, 16
    pop rbp 

    xor rax, rax 
    ret

call exit wrt ..plt

atanRight:
    push rbp
    lea rdi, [file_name]
    lea rsi, [file_mode]
    call fopen wrt ..plt
    pop	rbp	 
    mov rbx, rax                ;    file pointer in rbx

    xor r12, r12               ;    cur_num

    mov r14, 0                 ;    the first sign is plus
    mov r13, 1                 ;    cur_pow in r13
    mov r12, qword [cur_num]    


calculate_series:
    cmp r12w, word [num_of_terms]     
    jg end_calculation            

    fld qword [inputX]           
    mov rcx, r13        
    mov qword[cur_pow], r13     
    xor eax, eax                   

power_loop:
    cmp rcx, 1                      
    je after_power_calculation     

    fmul qword [inputX]                  
    loop power_loop                

after_power_calculation:
    fidiv WORD [cur_pow]  
    cmp r14b, 0x1
    jne plus
        fchs
    plus:

    mov al, 00000001b
    xor r14b, al               ; revert sign bit 
    
    fadd qword [cur_term]
    fstp qword [cur_term]
    
    push rbp
    sub     rsp, 8
    mov rdi, rbx
    lea rsi, [atanMember]
    mov rdx, r12
    movsd xmm0, qword [cur_term]  
    call fprintf wrt ..plt
    add     rsp, 8
    pop rbp 

    inc r12                        
    add r13, 2                     
    jmp calculate_series
	
end_calculation:
    mov rax, qword [cur_term]
    mov qword [atanNasm], rax

    push rbp
    sub     rsp, 8
    mov rdi, rbx
    call fclose wrt ..plt
    add     rsp, 8
    pop rbp

    ret


