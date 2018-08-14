extrn strlet:far, hexh:far, gets:far
data segment
	buffer db 416h dup(?)
	n dw ?
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
	mov sp,offset tos
	mov bx,offset buffer
	push bx
	mov ax,416h
	push ax
	call gets
	mov di,offset n
	push bx
	mov ax,'b'
	push ax
	push di
	call strlet
	push [di]
	mov dx,offset buffer
	push dx
	call hexh
	push dx
	mov dl,0ah
	mov ah,2
	int 21h
	pop dx
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
main endp
code ends
	end start