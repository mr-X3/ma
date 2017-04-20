;Assignment No:
;Title: Write X86/64 ALP to 5-digit BCD number into its equivalent HEX number.
;Make your program user friendly to accept the choice from user.
;Div: SE(A)
;Batch: SE_1
;Roll No: 


%macro write 2
	mov edx,%1
	mov esi,%2
	mov edi,1
	mov eax,1
	syscall
%endmacro

%macro read 2
	mov edx,%1
	mov esi,%2
	mov edi,0
	mov eax,0
	syscall
%endmacro

section .data
	msg4 db 'Enter the 5 digit BCD number : ',10,13
	len4 equ $-msg4

	msg5 db 'Conversion from BCD to  hexadecimalno is : ',10,13
	len5 equ $-msg5

	msg6 db ' ',10,13
	len6 equ $-msg6

section .bss
	num4 resb 10
	num5 resb 10
	result resb 20
	
section .text

global _start
_start:	
	write len4,msg4
	read 6,num4
	
	mov eax,0
	mov ebx,0Ah

	mov ecx,5
	mov edx,00
	mov r8,num4
	
L5:
	mul ebx
	mov edx,00
	mov dl,[r8]
	sub dl,30h
	add eax,edx
	inc r8
	dec cl
	jnz L5
	mov ebx,eax
	call disp
	
	write len5,msg5
	write 4,num4

	write len6,msg6

	
	
mov eax,60
syscall

disp:
			
			mov ecx,05
			mov edi,num4
			
	L11:
			rol bx,04
			mov al,bl
			and al,0fh
			cmp al,09h
			jbe L10
			add al,07h
	L10:
			add al,30h
			mov [edi],al
			inc edi
			dec ecx
			jnz L11
			
		ret

;==================output===================
;administrator@administrator-OptiPlex-3010:~/Desktop/A13$ nasm -f elf64 bh.nasm
;administrator@administrator-OptiPlex-3010:~/Desktop/A13$ ld -o bh bh.o
;administrator@administrator-OptiPlex-3010:~/Desktop/A13$ ./bh
;Enter the 5 digit BCD number : 
;01024
;Conversion from BCD to  hexadecimalno is : 
;0400 
;administrator@administrator-OptiPlex-3010:~/Desktop/A13$ 

