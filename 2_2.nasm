%macro write 2			;common macro for input/output
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro
  
section .data
	
 bemsg db 10,13,"before execution",0ah
 belen equ $-bemsg

 smsg db 10,13,"source block",0ah
 slen equ $-smsg

 dmsg db 10,13,"destination block",0ah
 dlen equ $-dmsg

 aemsg db 10,13,"after execution",0ah
 aelen equ $-aemsg

 spmsg db " "
 splen equ $-spmsg

 sb db 01h,02h,43h,84h,55h
 ddb db 00h,00h,00h,00h,00h
 cnt equ 5

section .bss
num resb 1

section .text
global _start
_start:

write bemsg,belen

;================DISPLAY SOURCE BLOCK BEFORE EXECUTION===================
write smsg,slen
mov r9,sb
mov ebp,cnt
call dispblk

;==============DISPLAY DESTINATION BLOCK BEFORE EXECUTION==================
write dmsg,dlen
mov r9,ddb
mov ebp,cnt
call dispblk


;===========DATA TRANSFER FROM SOURCE BLOCK TO DESTINATION BLOCK=============
mov esi,sb
mov edi,ddb
mov ebp,cnt

loop: 
mov al,[esi]
mov [edi],al
inc esi
inc edi
dec ebp
jnz loop


write aemsg,aelen

;=========DISPLAY SOURCE BLOCK AFTER EXECUTION============
write smsg,slen
mov r9,sb
mov ebp,cnt
call dispblk


;=======DISPLAY DESTINATION BLOCK AFTER EXECUTION==========
write dmsg,dlen
mov r9,ddb
mov ebp,cnt
call dispblk

mov rax,60
mov rdi,0
syscall


;===============PROCEDURE TO DISPLAY BLOCK==============
dispblk: 

l: 
call display
write spmsg,splen
inc r9
dec ebp
jnz l
ret

;============PROCEDURE TO DISPALY NUMBER===============
display :
	mov r8,num
	mov bl,00
	mov cx,02
	mov rdi,r9
	mov bl,[rdi]

lo3 :
	
	rol bl,4
	mov al,bl
	AND al,0Fh
	cmp al,09h
	jbe l4
	add al,07h

l4 :	
	add al,30h
	mov [r8],al
	inc edi
	inc r8
	dec cx
	jnz lo3
        write num,02
	ret

                                     	
	 		
