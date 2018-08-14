; 十六进制输入
; ;;;  IF ( decs='2f6e' ): THEN { [di]='2',si=decs+4 }  ;;;  预先设置 di,si
; push array[i]  ;;;  array dw 2bh dup(?)  ;;;  array元素地址(DW)
; call hhex

public hhex
code segment
	assume cs:code
hhex proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov al,[di]
	xor ax,ax
	xor dx,dx
	mov bx,10h
rs:	mul bx
	mov dl,[di]
	cmp dl,41h
	jc next
	add dl,9
next:	and dx,0fh
	add ax,dx
	inc di
	cmp di,si
	jnz rs
_ret:	mov bx,[bp+6]
	mov [bx],ax
	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
hhex endp
code ends
	end start