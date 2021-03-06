; 带符号数(dw)转字符串 : ffffh -> '-1$'
; push hex  ;;;  hex=1234  ;;;  hex为需要转化的十六进制'数'(dw)
; push string  ;;;  string db 7 dup(?)  ;;;  结果将会以字符串形式存入string中, 如string='123$', string='34567$'
; call hexdx

public hexdx
code segment
	assume cs:code
hexdx proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	mov di,[bp+6]
	mov ax,[bp+8]
	cmp ax,8000h
	jc next
	dec ax
	not ax
	mov byte ptr [di],2dh
	inc di
next:	mov bx,0ah
rs:	inc cx
	xor dx,dx
	div bx
	cmp ax,0
	jz done
	push dx
	jmp rs
done:	add dl,30h
	mov ds:[di],dl
	inc di
	dec cx
	cmp cx,0
	jz _ret
	pop dx
	jmp done
_ret:	mov dl,24h
	mov ds:[di],dl
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
hexdx endp
code ends
	end start