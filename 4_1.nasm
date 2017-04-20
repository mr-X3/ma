;Pratical no:4    successive Addition
%macro read 2
	mov edx,%2
	mov esi,%1
	mov edi,0
	mov eax,0
	syscall
%endmacro

%macro write 2
	mov edx,%2
	mov esi,%1
	mov edi,1
	mov eax,1
	syscall
%endmacro

%macro exit 0
mov eax,60
syscall
%endmacro	

section .data	
	
		msg db 'Enter 1st Number :'
		len equ $-msg
		
		msg1 db 'Enter 2nd number :'
		len1 equ $-msg1
		
		msg2 db 'The muliplication using successive addition is :',10,13
		len2 equ $-msg2
		
		msg3 db '',10,13
		len3 equ $-msg3



section .bss

	n1 resb 14
	n2 resb 14
	m1 resb 14
	m2 resb 14

	 
section .txt
global _start
	_start:
	
	 write msg,len
 	 read n1,3
 	 mov rsi,n1
 	 call accept
 	 mov [m1],bl
 	 
 	write msg1,len1
 	 read n2,3
 	 mov rsi,n2
 	 call accept
 	 mov [m2],bl
 	 
 	 mov bl,00
 	 
 	 mov al,[m1]
 	 mov cl,[m2]
 	 
 	 
      l5:add bl,al
 	 dec cl
 	 jnz l5
 	 
 	write msg2,len2
 	 call display
 	 
exit
         
accept: 	 
	mov bl,00
	mov rcx,02
	
     l1: rol bl,4	
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
	mov rcx,04
	mov rdi,n2
	
	
     l3: rol bx,04	
        mov al,bl
        and al,0Fh
        cmp al,09h
        jbe l4
        add al,07h
     l4: add al,30h
        mov [rdi],al
        inc rdi
        dec rcx
        jnz l3
        
         write n2,4
 	write msg3,len3
        
ret
;1st :05 2nd :02 output:0A
