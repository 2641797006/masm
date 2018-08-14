; 十进制输入
; ;;;  IF ( decs='32765' ): THEN { [di]='3',si=decs+5 }  ;;;  预先设置 di,si
; push array[i]  ;;;  array dw 2bh dup(?)  ;;;  array元素地址(DW)
; call dhex

public dhex
code segment
	assume cs:code
dhex proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	xor cx,cx
	mov al,[di]
	cmp al,2dh
	jnz next
	inc cx
	inc di
next:	xor ax,ax
	xor dx,dx
	mov bx,0ah
rs:	mul bx
	mov dl,[di]
	and dx,0fh
	add ax,dx
	inc di
	cmp di,si
	jnz rs
_ret:	cmp cx,0
	jz then
	not ax
	inc ax
then:	mov bx,[bp+6]
	mov [bx],ax
	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
dhex endp
code ends
	end start