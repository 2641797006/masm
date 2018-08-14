; 十六进制输出
; push hex  ;;;  hex = 89abh  ;;;  待输出值(dw)
; push string  ;;;  string db 5 dup(?)  ;;;  结果将会以字符串形式存入string中, 如string='2b$', string='45df$'
; call hexh

public hexh
code segment
	assume cs:code
hexh proc far
start:	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	xor dx,dx
	mov cl,4
	mov di,[bp+6]
	mov ax,[bp+8]
rs:	mov dl,0fh
	and dl,al
	shr ax,cl
	cmp dl,0ah
	jc shuzi
	add dl,07h
shuzi:	add dl,30h
	push dx
	inc ch
	cmp ax,0
	jz done
	jmp rs
done:	pop dx
	mov [di],dl
	inc di
	dec ch
	cmp ch,0
	jz _ret
	jmp done
_ret:	mov byte ptr [di],24h
	popf
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 4
hexh endp
code ends
	end start