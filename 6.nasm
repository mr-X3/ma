;Assignment No:
;Title:This program first check the mode of processor(Real or Protected),
;then reads GDTR, LDTR and IDTR and displays the same.
;Class:SE-A
;Batch:SE_ 
;Roll No.:

	%macro write 2
		mov rax,01
		mov rdi,01
		mov rsi,%1
		mov rdx,%2
		syscall
	%endmacro

	section .data
		msg1 db 'Welcome',10
		len1:equ $-msg1
		msg2 db 10,'GDT Contents are:'
		len2:equ $-msg2
		msg3 db 10,'LDT Contents are:'
		len3:equ $-msg3
		msg4 db 10,'IDT Contents are:'
		len4:equ $-msg4
		nxline db 10
		colmsg db ':'
		msg5 db 10,'Processor is in Real Mode'
		len5:equ $-msg5
		msg6 db 10,'Processor is in Protected Mode'
		len6:equ $-msg6
		msg7 db 10,13,' '
		len7 equ $-msg7

	section .bss
		gdt resd 1
	 	resw 1
		ldt resw 1
		idt resd 1
		resw 1
		dnum_buff resb 04
		cr0_data resd 1


	section .text
		global _start
		_start:	
		write msg7,len7
		smsw eax				;Reading CR0
		mov [cr0_data],eax		; copy eax to CRO buffer
		ror eax,1					;Checking PE bit, if 1=Protected Mode, else Real Mode
		jc prmode
		write msg5,len5
		jmp L1

	prmode:	write msg6,len6

	L1:sgdt [gdt]
		sldt [ldt]
		sidt [idt]

		write msg2,len2			; for displaying contents of GDT
		mov bx,[gdt+4]
		call disp_num
		mov bx,[gdt+2]
		call disp_num
		write colmsg,1
		mov bx,[gdt]
		call disp_num

		write msg3,len3			; for displaying contents of LDT
		mov bx,[ldt]
		call disp_num

		write msg4,len4			; for displaying contents of IDT
		mov bx,[idt+4]				
		call disp_num
		mov bx,[idt+2]
		call disp_num
	     	write colmsg,1
		mov bx,[idt]
		call disp_num
		write msg1,len1
	

	
	exit:	mov rax,60
			mov rdi,00
			syscall


	;Display Procedure
	disp_num:
		mov esi,dnum_buff	;point esi to buffer
		mov ch,04			;load number of digits to display 
		mov cl,04			;load count of rotation in cl
	L2:
		rol bx,cl			        ;rotate number left by four bits
		mov dl,bl			;move lower byte in dl
		and dl,0fh			;mask upper digit of byte in dl
		add dl,30h			;add 30h to calculate ASCII code
		cmp dl,39h			;compare with 39h
		jbe L3			;if less than 39h akip adding 07 more 
		add dl,07h			;else add 07

	L3:
		mov [esi],dl			;store ASCII code in buffer
		inc esi				;point to next byte
		dec ch				;decrement the count of digits to display
		jnz L2				;if not zero jump to repeat
		mov rax,1			;display the number from buffer
		mov rdi,1	
		mov rsi,dnum_buff
		mov rdx,4
		syscall
		ret
	;Output:
	;administrator@administrator-OptiPlex-3010:~/Desktop/SEB56$ nasm -f elf64 protected_real.nasm
	;administrator@administrator-OptiPlex-3010:~/Desktop/SEB56$ ld -o protected_real protected_real.o
	;administrator@administrator-OptiPlex-3010:~/Desktop/SEB56$ ./protected_realWelcome

	;Processor is in Protected Mode
	;GDT Contents are:1F304000:007F
	;LDT Contents are:0000
	;IDT Contents are:81DF8000:0FFF

