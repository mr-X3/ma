;Assignment no. :7
;X86/64 Assembly language program (ALP) 
;To sort the list of integers in ascending/descending order using bubble sort. 
;Read the input from the text file and write the sorted data back to the same text file.


%include	"macro.asm"

section .data
	nline db	10
	nline_len	equ	$-nline

	ano	db 10,10,10,10," Bubble sort using file operations"
			db 10,"  ",10
	ano_len equ $-ano

	filemsg db 10,"Enter filename of input data	: "
	filemsg_len equ $-filemsg	

	omsg db	10,"Sorting using bubble sort Operation successful."
			db 10,"Output stored in same file...",10,10
	omsg_len	equ	$-omsg
  
	errmsg db 10,"ERROR in opening/reading/writing File...",10
	errmsg_len equ $-errmsg

	ermsg db	10,"ERROR in writing File...",10
	ermsg_len equ $-ermsg

	exitmsg db 10,10,"Exit from program...",10,10
	exitmsg_len equ $-exitmsg


section .bss
	buf resb	1024
	buf_len equ $-buf		; buffer length
	filename	resb	50	
	filehandle resq	1
	abuf_len resq	1		        ; actual buffer length

	array resb 10
	n resq	1

section .text
	global _start
        _start:
		print ano,ano_len				;assignment no. 
		print filemsg,filemsg_len		
		read filename,50
		dec	rax
		mov	byte[filename + rax],0		        ; blank char/null char

		fopen filename				        ; on succes returns handle
		cmp	rax,-1H				                ; on failure returns -1
		je Error
		mov	[filehandle],rax	
		fread [filehandle],buf, buf_len
		dec	rax					                ; EOF
		mov	[abuf_len],rax

		call	bsort
		jmp	Exit

Error:	print errmsg, errmsg_len

Exit:	print exitmsg,exitmsg_len
		exit

bsort:							                ; Bubble sort procedure
		call	buf_array

		xor	rax,rax
		mov	rbp,[n]
		dec	rbp

		xor	rcx,rcx
		xor	rdx,rdx
		xor	rsi,rsi
		xor	rdi,rdi

		mov	rcx,0				; i=0

oloop:	mov	rbx,0				; j=0

		mov	rsi,array			        ; a[j]

iloop:	mov	rdi,rsi			        ; a[j+1]
		inc	rdi

		mov	al,[rsi]
		cmp	al,[rdi]
		jbe	next

		mov	dl,0
		mov	dl,[rdi]			        ; swap
		mov	[rdi],al
		mov	[rsi],dl

next:	inc	rsi
		inc	rbx				        ; j++
		cmp	rbx,rbp
		jb	iloop
		
		inc	rcx
		cmp	rcx,rbp
		jb	oloop

	fwrite [filehandle],omsg, omsg_len
	fwrite [filehandle],array,[n]

	fclose [filehandle]	

	print omsg, omsg_len
	print array,[n]	

	RET

Error1:
	print ermsg, ermsg_len
	RET

buf_array:
	xor	rcx,rcx
	xor	rsi,rsi
	xor	rdi,rdi

	mov	rcx,[abuf_len]
	mov	rsi,buf
	mov	rdi,array

next_num:
	mov	al,[rsi]
	mov	[rdi],al

	inc	rsi		; number
	inc	rsi		; newline
	inc	rdi

	inc	byte[n]	; counter
	
	dec	rcx		; number
	dec	rcx		; newline
	jnz	next_num
ret


;Create another file and save it as macro.asm And cut paste this code
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
;administrator@siftworkstation:~/Desktop/micro/bs$ ./bsort
;administrator@siftworkstation:~/Desktop/micro/bs$ ld -o bsort bsort.o
;administrator@siftworkstation:~/Desktop/micro/bs$ ./bsort




 ;Bubble sort using file operations
  

;Enter filename of input data	: data.txt

;Sorting using bubble sort Operation successful.
;Output stored in same file...



;12345

;Exit from program...


