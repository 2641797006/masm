extrn hexh:far, m5034:far
public m5031
data segment
	buf db 0edh,34h,5fh,3ah,2bh,55h,0h,0ffh,0eeh,0fh
	str0 db 5 dup(?)
data ends
code segment
	assume cs:code
m5031 proc far
start:	push ax
	push bx
	push cx
	push dx
	push si
	pushf
	push ds
	mov ax,data
	mov ds,ax
restt:	xor bx,bx
	xor cx,cx
	mov si,offset buf
	mov dx,offset str0
rs:	mov bl,[si]
	push bx
	mov dx,offset str0
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
_ret:	call m5034
	cmp dx,0
	jz restt
	pop ds
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
m5031 endp
code ends
	end start
	