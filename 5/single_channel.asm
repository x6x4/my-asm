[bits 64]

section .text 
GLOBAL single_color_channel

;   rdi - pixels
;   rsi - width 
;   rdx - height

single_color_channel:

    mov r12, rdi 
    mov r11, rdx           
    
loop_rows:
  
    mov rcx, rsi 

    loop_cols:

        ;  green is the grey channel
        mov al, byte [r12+1]
        
        mov byte [r12+0], al 
        mov byte [r12+2], al
            
        add r12, 3 

    loop loop_cols

    dec r11     
    mov rcx, r11 
        
loop loop_rows

ret