extrn strlet:far, hexh:far, gets:far, m5034:far
public m5032
data segment
	str1 db 416h dup(?)
	n dw ?
	buffer db 5 dup(?)
data ends
code segment
	assume cs:code
m5032 proc far
start:	push ax
	push bx
	push dx
	push di
	pushf
	push ds
	mov ax,data
	mov ds,ax
restt:	mov bx,offset str1
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
_ret:	call m5034
	cmp dx,0
	jz restt
	pop ds
	popf
	pop di
	pop dx
	pop bx
	pop ax
	ret
m5032 endp
code ends
	end start