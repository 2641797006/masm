; ;;;  clear screen
; call cls

public cls
code segment
	assume cs:code
cls proc far
start:	push ax
	push bx
	push cx
	push dx
	pushf
	mov ax,0600h
	mov bh,7
	mov cx,0
	mov dx,184fh
	int 10h
;	xor dx,dx
;	mov ah,2
;	int 10h
_ret:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	ret
cls endp
code ends
	end start