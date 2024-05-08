
section .bss

; Define buffers for storing characters and lines.
filename_buffer resb 16
char_buffer resb 1 
word_buffer resb 16 
line_buffer resb 64

%define filename_sz 16
%define lnbuf_sz 64
%define wordbuf_sz 16

section .text

global _start

_start:
    mov rax, 2 
    mov rdi, [rsp+16]
	mov rsi, 0o444 
    mov rdx, 0 
    syscall

    cmp rax, -1
    jle file_error
	
	mov r8, rax
	mov r12, 0
	mov r13, line_buffer

readword_loop:
	cmp r12, 1
	je write_line
	
	mov rdi, word_buffer
    xor rax, rax
	mov rcx, wordbuf_sz
    rep stosb                  ; clean word buffer

	lea r10, [word_buffer] 

readchar_loop:
	mov r12, 0
    ; Read char by char 
    mov rdi, r8 ; file descriptor
	mov rax, 0 
    lea rsi, [char_buffer]
    mov rdx, 1
    syscall

    ; Check if we reached the end of the file.
    cmp rax, 0
    je file_end

	mov al, [rsi]
	cmp al, 10
	je new_line
	cmp al, 32 
	je new_word
	cmp al, 9
	jl continue
	cmp al, 13 
	jl new_word
	continue: 
	mov [r10], al           ; put to word buffer
	inc r10	
jmp readchar_loop

new_line:
	mov r12, 1

new_word:
	mov [r10], byte 0       ; remove whitespace
	dec r10
	lea r11, [word_buffer]  ; from begin
	mov r9, r10
	sub r9, r11
	inc r9                  ; word length

palindrom_check:
	cmp r10, r11 
	jle add_word
	mov al, [r10] 			; from end
	cmp al, byte [r11] 
	jne readword_loop
	dec r10
	inc r11
jmp palindrom_check

add_word:	
    mov rsi, word_buffer
    mov rdi, r13
    mov rcx, r9
    rep movsb

    mov byte [rdi], 32
	mov r13, rdi
	inc r13

    cmp r12, 1
    je write_line

    ; Repeat until we reach the end of the line.
jmp readword_loop

write_line:
	cmp r13, line_buffer
je empty_line
	mov [r13-1], byte 10
	jmp end_padding
empty_line:
	mov [r13], byte 10
	end_padding:    

    mov rax, 1 
    mov rdi, 1 
    mov rsi, line_buffer
	mov rdx, r13
	sub rdx, line_buffer
	inc rdx
    syscall

    ; Clear the line buffer.
    mov rdi, line_buffer
    xor rax, rax
    mov rcx, lnbuf_sz
	rep stosb

    ; Go back to the read loop.
	mov r12, 0
	mov r13, line_buffer
jmp readword_loop

file_end:
    ; Close the file.
    mov rax, 3 ; close() syscall
    mov rdi, rax ; file descriptor
    syscall

    ; Exit the program.
    mov rax, 60 ; exit() syscall
    mov rdi, 0 ; exit code
    syscall

file_error:
    ; Display an error message.
    mov rax, 1 ; write() syscall
    mov rdi, 2 ; file descriptor (stderr)
    lea rsi, [error_message]
    mov rdx, error_message_length
    syscall

    ; Exit the program.
    mov rax, 60 ; exit() syscall
    mov rdi, 1 ; exit code
    syscall


; Error message.
error_message: db "Error opening file.", 10
error_message_length: equ $ - error_message
