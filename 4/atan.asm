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
atanLeftStr:    db "left part: %lf", 10
atanMember:     db "%d %lf", 10
atanRightStr:   db "right part: %lf", 10

section .data

num_of_terms: dq 0

cur_pow: dq 1  ; текущая степень
cur_num: dq 1   ; текущий номер члена ряда
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
    lea rdi, [atanRightStr]
    movsd xmm0, qword [atanNasm]  
    call printf wrt ..plt
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
    mov r9, rax                ;    file pointer in r9

    xor r10, r10 
    xor r11, r11 
    xor r12, r12               ;    cur_num

    mov r10, 1                 ;    the first sign is plus
    mov r11, qword [cur_pow]   
    mov r12, qword [cur_num]    

    fld qword [inputX]  

calculate_series:
    cmp r12w, word [num_of_terms]     
    jg end_calculation            

    fld qword [cur_term]           
    mov cx, word [cur_pow]               
    xor eax, eax                   

power_loop:
    cmp cx, 0                      
    je after_power_calculation     

    fmul                           
    loop power_loop                

after_power_calculation:
    fidiv WORD [cur_pow]      

    mov al, 00000001b
    xor r10b, al               ; revert sign bit 
    
    fadd qword [cur_term]
    fstp qword [cur_term]
    
    push rbp
    mov rdi, r9  
    lea rsi, [atanMember]
    mov rdx, r12
    movsd xmm0, qword [cur_term]  
    call fprintf wrt ..plt
    pop rbp 

    inc r12                        
    add r11, 2                     
    jmp calculate_series
	
end_calculation:
    mov rax, qword [cur_term]
    mov qword [atanNasm], rax

    push rbp
    mov rdi, r9
    call fclose wrt ..plt
    pop rbp

    ret


