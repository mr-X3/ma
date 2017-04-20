%macro scall 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

%macro fopen 1
mov rax,2
mov rdi,%1
mov rsi,2
mov rdx,0777o
syscall
%endmacro

%macro fread 3
mov rax,0
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

%macro fwrite 3
mov rax,1
mov rdi,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

%macro fclose 1
mov rax,3
mov rdi,%1
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
menumsg db 10,"**********Menu*************"
	db 10,"1.TYPE"
	db 10,"2.Copy"
	db 10,"3.Delete"
	db 10,"4.Exit"
l1 equ $-menumsg	

chmsg db 10,"Enter u r choice:"
l2 equ $-chmsg

cntmsg db 10,"Do u want to cont...."
l3 equ $-cntmsg

fmsg db 10,"Enter File name:"
l4 equ $-fmsg

errmsg db "File not Present..."
l5 equ $-errmsg

fmsg1 db "File  Present..."
l6 equ $-fmsg1

delmsg db 10,"File deleted successfully...."
l7 equ $-delmsg

wmsg db 10,"Write Successfully"
wmsgl equ $-wmsg

section .bss

choice resb 2
filename resb 50
filename1 resb 50
fhandle resq 1
fhandle1 resq 1
buff resb 1024
bufflen equ $-buff
act_len resq 2

cnt1 resq 1
cnt2 resb 2
dispbuff resb 5
section .text

global _start

_start:

menu:

	scall 1,1,menumsg, l1
	scall 1,1,chmsg,l2
	scall 0,0,choice,2
	mov al,byte[choice]
	sub al,30h
	cmp al,1
	jne case2
	call typecmd
	jmp cnt
case2:
	cmp al,2	
	jne case3
	call copycmd
	jmp cnt
case3:
	cmp al,3
	jne case4
	call delcmd
	jmp cnt
case4:
	exit
cnt:
	scall 1,1,cntmsg,l3
	scall 0,0,choice,2
	mov al,byte[choice]
	sub al,30h
	cmp al,1		
	je menu
	exit 
;********************TYPE Command ********************
typecmd:
	scall 1,1,fmsg,l4
	scall 0,0,filename,50
	dec rax
	mov byte[filename+rax],0
	fopen filename
	cmp rax,-1H
	jle err
	mov [fhandle],rax
	fread [fhandle],buff,bufflen
	dec rax
	mov [act_len],rax
	scall 1,1,buff,act_len
	jmp n
err:
	scall 1,1,errmsg,l5
	
n:	
ret

;*******************Copy Command **********************

copycmd:
      scall 1,1,fmsg,l4
      scall 0,0,filename,50
      dec rax
      mov byte[filename+rax],0
      
      scall 1,1,fmsg,l4
      scall 0,0,filename1,50
      dec rax
      mov byte[filename1+rax],0
      
      
      fopen filename
      cmp rax,-1h
      jle err1
      mov [fhandle],rax
      
      fopen filename1
      cmp rax,-1h
      jle err1
      mov [fhandle1],rax
      
      fread [fhandle],buff,bufflen
      dec rax
      mov [act_len],rax
      
      
      
      fwrite [fhandle1],buff,[act_len]
      scall 1,1,wmsg,wmsgl
      fclose [fhandle1]
      jmp nxt
 err1:
	scall 1,1,errmsg,l5
 nxt:
 	ret	  
	  
;***********************Delete Command *********************  		    
    
delcmd:
	scall 1,1,fmsg,l4
	scall 0,0,filename,50
	dec rax
	mov byte[filename+rax],0
	mov rax,87
	mov rdi,filename
	syscall
	
	cmp rax,-1h
	jle erro
	scall 1,1,delmsg, l7
	call cnt
erro:
	scall 1,1,errmsg,l5	

ret


;output
;vishal@ubuntu:~/Desktop/My_m$ nasm -f elf64 8.asm
;vishal@ubuntu:~/Desktop/My_m$ ld -o 8 8.o
;vishal@ubuntu:~/Desktop/My_m$ ./8
;
;**********Menu*************
;1.TYPE
;2.Copy
;3.Delete;
;4.Exit
;Enter u r choice:
;vishal@ubuntu:~/Desktop/My_m$ ./8;

;**********Menu*************
;1.TYPE
;2.Copy
;3.Delete
;4.Exit
;Enter u r choice:1

;Enter File name:file1.txt
;hfnb
;dgg
;asda

;Do u want to cont....1

;**********Menu*************
;1.TYPE
;2.Copy
;3.Delete
;4.Exit
;Enter u r choice:2   

;Enter File name:file1.txt

;Enter File name:file2.txt

;Write Successfully
;Do u want to cont....1

;**********Menu*************
;1.TYPE
;2.Copy
;3.Delete
;4.Exit
;Enter u r choice:3

;Enter File name:file2.txt

;File deleted successfully....
;Do u want to cont....1

;**********Menu*************
;1.TYPE
;2.Copy
;3.Delete
;4.Exit
;Enter u r choice:4
;vishal@ubuntu:~/Desktop/My_m$ 

