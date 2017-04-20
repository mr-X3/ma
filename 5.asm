;Assignment Name :X86/64 Assembly language program (ALP) to find
;	a) Number of Blank spaces
;	b) Number of lines
;	c) Occurrence of a particular character. 
;Accept the data from the text file. The text file has to be accessed during Program_1 execution.
;Write FAR PROCEDURES in Program_2 for the rest of the processing.
;Use of PUBLIC/GLOBAL and EXTERN directives is mandatory.


;Three files are required first File1.asm



extern	far_proc		                ; [ FAR PROCRDURE    USING EXTERN DIRECTIVE ]

global	filehandle, char, buf, abuf_len

%include	"macro.asm"


section .data
	nline db	10
	nline_len	equ	$-nline

	ano db 10,10,10,10,"ML assignment 05 :- String Operation using Far Procedure"
			db   10,"   ",10
	ano_len equ $-ano

	filemsg db 10,"Enter filename for string operation: "
	filemsg_len equ $-filemsg	
  
	charmsg	db 10,"Enter character to search: "
	charmsg_len equ $-charmsg

	errmsg db 10,"ERROR in opening File!!!",10
	errmsg_len equ $-errmsg

	exitmsg db 10,10,"Exit from program!!!",10,10
	exitmsg_len equ $-exitmsg


section .bss
	buf	resb	4096
	buf_len equ $-buf		                        ; buffer initial length

	filename	resb	50	
	char resb	2	
 
	filehandle resq	1
	abuf_len	resq	1		                        ; actual buffer length


section .text
	global _start
		
_start:
		print ano,ano_len		                ;assignment no. 

		print filemsg,filemsg_len		
		read  filename,50
		dec	rax
		mov	byte[filename + rax],0		; blank char/null char

		print charmsg,charmsg_len		
		read char,2
		
		fopen filename			        ; on succes returns handle
		cmp	rax,-1H			                ; on failure returns -1
		jle	Error
		mov	[filehandle],rax	

		fread [filehandle],buf, buf_len
		mov	[abuf_len],rax

		call	far_proc
		jmp	Exit

Error:	print errmsg, errmsg_len

Exit:	print exitmsg,exitmsg_len
		exit

;Three files are required second File2.asm


section .data
	nline		db	10,10
	nline_len:	equ	$-nline

	smsg		db	10,"No. of spaces are	: "
	smsg_len:	equ	$-smsg
	
	nmsg		db	10,"No. of lines are	: "
	nmsg_len:	equ	$-nmsg

	cmsg		db	10,"No. of character occurances are	: "
	cmsg_len:	equ	$-cmsg


section .bss

	scount	resq	1
	ncount	resq	1
	ccount	resq	1

	char_ans	resb	16


global	far_proc		

extern	filehandle, char, buf, abuf_len

%include	"macro.asm"

section .text
	global	_main
_main:

far_proc:          		                        ;FAR Procedure
	
		xor	rax,rax
		xor	rbx,rbx
		xor	rcx,rcx
		xor	rsi,rsi	

		mov	bl,[char]
		mov	rsi,buf
		mov	rcx,[abuf_len]

again:	mov	al,[rsi]

case_s:	cmp	al,20h		                ;space : 32 (20H)
		jne	case_n
		inc	qword[scount]
		jmp	next

case_n:	cmp	al,0Ah		                ;newline : 10(0AH)
		jne	case_c
		inc	qword[ncount]
		jmp	next

case_c:	cmp	al,bl			                ;character
		jne	next
		inc	qword[ccount]

next:		inc	rsi
		dec	rcx			                ;
		jnz	again			        ;loop again

		print smsg,smsg_len
		mov	rax,[scount]
		call	display
	
		print nmsg,nmsg_len
		mov	rax,[ncount]
		call	display

		print cmsg,cmsg_len
		mov	rax,[ccount]
		call	display

	fclose	[filehandle]
	ret




display:
	mov 	rsi,char_ans+3	; load last byte address of char_ans in rsi
	mov 	rcx,4			; number of digits 

cnt:	mov 	rdx,0			; make rdx=0 (as in div instruction rdx:rax/rbx)
	mov 	rbx,10		        ; divisor=10 for decimal and 16 for hex
	div 	rbx
;	cmp 	dl, 09h		        ; check for remainder in RDX
;	jbe  	add30
;	add  	dl, 07h 
;add30:
	add 	dl,30h		                ; calculate ASCII code
	mov 	[rsi],dl		        ; store it in buffer
	dec 	rsi			                ; point to one byte back

	dec 	rcx			                ; decrement count
	jnz 	cnt			                ; if not zero repeat
	
	print char_ans,4		        ; display result on screen
ret




;Three files are required second macro.asm

 ;macro.asm
;macros as per 64 bit conventions

%macro read 2
	mov	rax,0		;read
	mov	rdi,0		;stdin/keyboard
	mov	rsi,%1	        ;buf
	mov	rdx,%2	        ;buf_len
	syscall
%endmacro

%macro print 2
	mov	rax,1		;print
	mov	rdi,1		;stdout/screen
	mov	rsi,%1	        ;msg
	mov	rdx,%2	        ;msg_len
	syscall
%endmacro

%macro fopen 1
	mov	rax,2		;open
	mov	rdi,%1	        ;filename
	mov	rsi,2		;mode RW
	mov	rdx,0777o	;File permissions
	syscall
%endmacro

%macro fread 3
	mov	rax,0		;read
	mov	rdi,%1	        ;filehandle
	mov	rsi,%2	        ;buf
	mov	rdx,%3	        ;buf_len
	syscall
%endmacro

%macro fwrite 3
	mov	rax,1		;write/print
	mov	rdi,%1	        ;filehandle
	mov	rsi,%2	        ;buf
	mov	rdx,%3	        ;buf_len
	syscall
%endmacro

%macro fclose 1
	mov	rax,3		;close
	mov	rdi,%1	        ;file handle
	syscall
%endmacro

%macro exit 0
	print nline,nline_len
	mov	rax,60	        ;exit
	mov	rdi,0
	syscall
%endmacro


;output

administrator@siftworkstation:~/Desktop/micro$ nasm -f elf64 file1.asm
administrator@siftworkstation:~/Desktop/micro$ nasm -f elf64 file2.asm
administrator@siftworkstation:~/Desktop/micro$ ld  file1.o file2.o -o file
administrator@siftworkstation:~/Desktop/micro$ ./file




ML assignment 05 :- String Operation using Far Procedure
   

Enter filename for string operation: myfile.txt


Enter character to search: e

No. of spaces are	: 0002
No. of lines are	: 0004
No. of character occurances are	: 0002

Exit from program!!!


administrator@siftworkstation:~/Desktop/micro$ ./file




ML assignment 05 :- String Operation using Far Procedure
   

Enter filename for string operation: mfile.txt

Enter character to search: a

ERROR in opening File!!!


Exit from program!!!



