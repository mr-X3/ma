;Positive And Negative

%macro write  2
        mov rax,1
        mov rdi,1 
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro

section .data
        arr dq 123456789ABCDDFh,-123444400000000Ah,-123444400000000Ah, -7FFFFFFFFFFFFFFFh
        n equ 4
        pmsg db "The Count of Positive No: ",10
        plen equ $-pmsg
        nmsg db "The Count of Negative No: ",10
        nlen equ $-nmsg
        nwline db 10
    
section .bss

        pcnt resq 1
        ncnt resq 1
        num resb 16
    
section .text
        global _start
        _start:
                mov rsi,arr       	; rsi points to arrar "ar"
                mov rdi,n		; rdi points to "n" which is initialised to 4 number in array
                mov rbx,0		; initialised to "0"
                mov rcx,0		; count initialised to "0"
        
        up:    mov rax,[rsi]
               cmp rax,0000000000000000h
               js negative
    
        positive:    inc rbx
                     jmp next
        negative:    inc rcx
    
        next:    add rsi,8
                 dec rdi
                 jnz up   
                 mov [pcnt],rbx
                 mov [ncnt],rcx
                 write   pmsg,plen
                 mov rax,[pcnt]

                 call display

                write   nwline,1

                 write   nmsg,nlen
                 mov rax,[ncnt]
                 call display

                write   nwline,1 

                 mov rax,60
                 mov rbx,0
                 syscall
        
        
   
display:
        mov rsi,num
        mov rcx,16

        cnt:    rol rax,4
                mov dl,al
                and dl,0FH
                cmp dl,09h
                jbe add30
                add dl,07h
        add30:  add dl,30h
                mov [rsi],dl
                inc rsi
                loop cnt
               
        write   num,16
ret
