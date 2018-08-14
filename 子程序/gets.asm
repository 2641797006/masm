; 字符串输入  ;;;  支持 '20h~126h'
; push string  ;;;  string db 416h dup(?)  ;;;  字符串存储地址
; push 416h  ;;;  字符串存储空间string的长度
; call gets

public gets
code segment
	assume cs:code
gets proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor bx,bx
	mov cx,[bp+6]
	mov di,[bp+8]
cin:	mov ah,8
	int 21h
	cmp al,0dh
	jz _ret
	cmp al,8
	jz bs
	cmp al,20h
	jc cin
	cmp al,7fh
	jnc cin
	mov dl,al
	mov ah,2
	int 21h
	mov [di],al
	inc di
	inc bx
	dec cx
	cmp cx,2
	jc _ret
	jmp cin
bs:	cmp bx,0
	jz cin
	call back
	dec di
	dec bx
	jmp cin
_ret:	mov byte ptr [di],24h
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
gets endp
back proc near
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	mov ah,2
	int 21h
	mov dl,8
	mov ah,2
	int 21h
	ret
back endp
code ends
	end start