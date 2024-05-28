

section .text

	fld qword [inputX]
	call atan
	fstp qword [atanC]

    mov     rdi, fmtDouble
    mov     rdi, atanC
    call    printf
    add     rsp, 16

    mov     rax, qword [inputX]
    mov     qword [cur_term], rax
    mov     qword [atanNasm], rax
    call    calcArctan2
    mov     rbx, rax

    push    fmtDouble
    push    rbx
    call    printf
    add     rsp, 16        

    ; Остановка программы
    mov     eax, 0
    ret

; Функция вычисления арктангенса (разложение в ряд Тейлора)

calcArctan2:
    mov rdi, file_name
    mov rsi, "w"
    call fopen
    mov rdx, rax  ; сохраняем указатель на файл в rdx

    mov r11w, word [cur_pow]   
    mov r12w, word [cur_num]    

calculate_series:
    cmp r12w, word [num_of_terms]     
    jg end_calculation            

    fld qword [cur_term]           ; загружаем число x в двойной точности в стек FPU
    mov cx, word [cur_pow]                ; загружаем текущую степень в регистр cx
    xor eax, eax                   ; обнуляем eax для хранения промежуточных результатов

power_loop:
    cmp cx, 0                      ; сравниваем текущую степень с нулем
    je after_power_calculation     ; если текущая степень равна нулю, переходим к завершению вычислений

    fmul                           ; умножение вершины стека на x
    loop power_loop                ; уменьшаем cx и продолжаем цикл

after_power_calculation:
    fidiv WORD [cur_pow]      ; делим результат на текущую степень
    
    fadd qword [cur_term]
    fstp qword [cur_term]
    
    mov rdi, rdx  ; передаем указатель файла
    mov rsi, fmtDouble  ; устанавливаем формат для fprintf
    movsd xmm0, qword [cur_term]  ; загружаем текущий член в xmm0
    call fprintf

    inc r12                        ; увеличиваем текущий номер члена на 1 для следующей итерации
    add r11, 2                     ; увеличиваем текущую степень на 2
    jmp calculate_series
	
end_calculation:
    mov rax, qword [cur_term]
    mov qword [atanNasm], rax

    mov rdi, rdx
    call fclose
    ret
