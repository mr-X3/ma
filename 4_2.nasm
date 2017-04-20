;Aim:- Write x86/64 ALP to perform multiplication of two 8-bit Hexadecimal numbers. 
; add & shift method.(use of 64-bit registers is expected). 


%macro read 2 
	mov edx,%1 
	mov esi,%2 
	mov edi,0 
	mov eax,0 
	syscall 
%endmacro 

%macro write 2 
	mov edx,%1 
	mov esi,%2 
	mov edi,1 
	mov eax,1 
	syscall 
%endmacro 

%macro exit 0 
mov eax,60 
syscall 
%endmacro	 

section .data	 
	 
		msg db 'Enter 1st Multiplicant :' 
		len equ $-msg 
		 
		msg1 db 'Enter 2nd Multiplicant :' 
		len1 equ $-msg1 
		 
		msg2 db ' :',10,13 
		len2 equ $-msg2 
		 
		msg3 db '',10,13 
		len3 equ $-msg3 



section .bss 

	num1 resb 10 
	num2 resb 10 
	mul1 resb 14 
	mul2 resb 14 
	result resb 14 
	 
section .txt 
global _start 
	_start: 

	write len,msg 
 	read 3,num1 	 
 	call accept 
	mov [mul1],bl 
 	 
 	 
 
 	write len1,msg1 
 	read 3,num1 
 	call accept 
	mov [mul2],bl 
 	 
	 
	mov cl,00 
	mov dl,8 
	 
	mov al,[mul1] 
	mov bl,[mul2] 
	 
    t2:	rcr al,01 
	jnc t1 
	shl bl,cl 
	add [result],bl 
	mov bl,[mul2] 
      
    t1:	inc cl 
	dec dl 
	jnz t2 

	mov bl,[result] 
	call display 
	write 4,num2        
	write len3,msg3 
exit 

accept: 	 
	mov bl,00 
	mov rsi,num1 
	mov rcx,2 
	 
     l1:rol bl,4	 
        mov al,[esi] 
        cmp al,39h 
        
        jbe l2 
        sub al,07h 
     
     l2:sub al,30h 
        add bl,al 
        inc rsi 
        dec rcx 
        jnz l1 
ret 

display: 	 
	mov rcx,4 
	mov rdi,num2 
	 
	 
     l3:rol bx,04	 
        mov al,bl 
        and al,0Fh 
        cmp al,09h 
        jbe l4 
        add al,07h 
     l4:add al,30h 
        mov [rdi],al 
        inc rdi 
        dec rcx 
        jnz l3 
        
        
ret 


;vishal@ubuntu:~/Desktop/FInal_micro$ nasm -f elf64 4_2.nasm
;vishal@ubuntu:~/Desktop/FInal_micro$ ld -o 4_2 4_2.o 
;vishal@ubuntu:~/Desktop/FInal_micro$ ./4_2
;Enter 1st Multiplicant :05
;Enter 2nd Multiplicant :02
;000A

