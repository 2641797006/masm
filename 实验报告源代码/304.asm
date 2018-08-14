extrn guess:far, char:far, passwd:far
data segment
	pcin	db 0ah, '(1) Guess Number Game', 0ah
		db '(2) Char Selection Program', 0ah
		db '(3) Password Program', 0ah
		db '(4) Press "ESC" to Quit', 0ah, '$'
data ends
stack segment stack
	dw 80h dup(?)
	tos label word
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
rs:	mov dx,offset pcin
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
	cmp al,34h
	jz f4		;输入 1 2 3 4 以外一概不作处理
	jmp cin
f1:	call lf
	call guess	;调用guess子程序
	jmp rs
f2:	call lf
	call char
	jmp rs
f3:	call lf
	call passwd
	jmp rs
f4:	call lf
	mov ah,4ch
	int 21h
	ret
main endp
lf proc near		;换行, 回显输入
	push ax
	push dx
	mov dl,al
	mov ah,2
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