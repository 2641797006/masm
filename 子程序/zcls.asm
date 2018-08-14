; 自定义  clear screen
; push \bx  ;;;  该值将会给bx
; push \cx  ;;;  该值将会给cx
; push \dx  ;;;  该值将会给dx
; call zcls

public zcls
code segment
	assume cs:code
zcls proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov ax,0600h
	mov bx,[bp+10]
	mov cx,[bp+8]
	mov dx,[bp+6]
	int 10h
;	xor dx,dx
;	mov ah,2
;	int 10h
_ret:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
zcls endp
code ends