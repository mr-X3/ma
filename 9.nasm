;Assignment No:
;Title: Write x86 ALP to find the factorial of a given integer number on a command line by using
;recursion. Explicit stack manipulation is expected in the code 
;Div: SE(A)
;Batch: SE_1
;Roll No: 


%macro read 2			;common macro for input/output
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro write 2			;common macro for input/output
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .data
	num db 00h
	msg db "Factorial is : "
	msglen equ $-msg
	msg1 db "*****Program to find Factorial of a number***** ",0Ah
		db "Enter the number : ",
	msg1len equ $-msg1
	
	zerofact db " 00000001 "
	zerofactlen equ $-zerofact

section .bss
	dispnum resb 16
	result resb 4
	temp resb 3
	

section .text
global _start
_start:
	
	write msg1,msg1len
	read temp,3			;accept number from user
	call accept			;convert number from ascii to hex
	mov [num],dl
	
	write msg,msglen
	
	xor rdx,rdx
	xor rax,rax
	mov al,[num]			;store number in accumulator
	cmp al,01h			
	jbe endfact
	xor rbx,rbx
	mov bl,01h
	call factr			;call factorial procedure
	call display

	call exit
endfact:
	write zerofact,zerofactlen
	call exit

	factr:				;recursive procedure
	
			cmp rax,01h
			je calc1
			push rax			
			dec rax
			
			call factr

		calc:
			pop rbx
			mul ebx
			jmp endfact1

		calc1:			;if rax=1 return
			pop rbx
			jmp calc		
		endfact1: 
	ret

	display:			; procedure to convert hex to ascii
	
			mov rsi,dispnum+15
			xor rcx,rcx
			mov cl,16

		cont:
			xor rdx,rdx
			xor rbx,rbx
			mov bl,10h
			div ebx
			cmp dl,09h
			jbe skip
			add dl,07h
		skip:
			add dl,30h
			mov [rsi],dl
			dec rsi
			loop cont
	
			write dispnum,16
	
	ret

	accept:		;procedure to convert ascii to hex
			mov rsi,temp
			mov cl,02h
			xor rax,rax
			xor rdx,rdx
		contc:
			rol dl,04h
			mov al,[rsi]
			cmp al,39h
			jbe skipc
			sub al,07h
		skipc:
			sub al,30h
			add dl,al
			inc rsi
			dec cl
			jnz contc
	
	ret

	exit:				;exit system call
			
			mov rax,60
			mov rdi,0
			syscall

	ret




;OUTPUT
;gescoe@gescoe:~/Desktop$ nasm -f elf64 fa.nasm
;gescoe@gescoe:~/Desktop$ ld -o fa fa.o
;gescoe@gescoe:~/Desktop$ ./fa
;*****Program to find Factorial of a number***** 
;Enter the number : 02
;Factorial is : 0000000000000002

