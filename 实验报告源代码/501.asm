extrn hexh:far
data segment
	buf db 0edh,34h,5fh,3ah,2bh,55h,0h,0ffh,0eeh,0fh
	str0 db 5 dup(?)
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
	xor bx,bx
	xor cx,cx
	mov si,offset buf
	mov dx,offset str0
rs:	mov bl,[si]
	push bx
	push dx
	call hexh
	mov ah,9
	int 21h
	mov dl,20h
	mov ah,2
	int 21h
	inc cl
	cmp cl,0ah
	jnc _ret
	inc si
	jmp rs
_ret:	mov ah,4ch
	int 21h
main endp
code ends
	end start
	