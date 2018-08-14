extrn sort:far, couta:far, crlf:far
data segment
	num dw 234, 23, 0, 34227, 849, 3748, 9089, 65535, 8888, 444, 38, 393, 4344
	n dw 13
	__buffer__ db 6 dup(?)
data ends
stack segment stack
	dw 80h dup(?)
	tos label word
stack ends
code segment
main proc far
	assume cs:code, ds:data, ss:stack
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,offset tos
	mov bx,offset __buffer__
	push bx
	mov dx,offset num
	push dx
	mov ax,13
	push ax
	call couta
	call crlf
	push dx
	push ax
	call sort
	push bx
	push dx
	push ax
	call couta
	mov ah,4ch
	int 21h
main endp
code ends
	end start
