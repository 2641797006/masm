extrn m5031:far, m5032:far, m5033:far
data segment
	str1 db 'Your selection is $'
	str2 db ', the program will execute!$'
	menu db 0ah, '(1)	HEXAC GAME', 0ah
	     db	'(2)	CHAR  STATISTICS PROGRAM', 0ah
	     db	'(3)	PRESS  "ESC"  TO  QUIT', 0ah, '$'
data ends
stack segment stack
	dw 416h dup(?)
	tos label word
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,offset tos
rs:	mov dx,offset menu
	mov ah,9
	int 21h
cin:	mov ah,8	;输入不回显
	int 21h
	cmp al,31h
	jz f1
	cmp al,32h
	jz f2
	cmp al,33h
	jz f3
	jmp cin		;输入 1 2 3 以外一概不作处理
f1:	call lf
	call m5031
	jmp rs
f2:	call lf
	call m5032
	jmp rs
f3:	call lf
	call m5033
	jmp rs
main endp
lf proc near		;换行, 回显输入
	push ax
	push dx
	mov dx,offset str1
	mov ah,9
	int 21h
	mov dl,al
	mov ah,2
	int 21h
	mov dx,offset str2
	mov ah,9
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	pop dx
	pop ax
	ret
lf endp
code ends
	end start