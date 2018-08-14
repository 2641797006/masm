; 获取字符串长度(不计$)
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  字符串地址
; ;;;  执行strlen后: ax = string长度
; call strlen

public strlen
code segment
	assume cs:code
strlen proc far
start:	push bp
	mov bp,sp
	push si
	pushf
	xor ax,ax
	mov si,[bp+6]
rs:	cmp byte ptr [si],24h
	jz _ret
	inc si
	inc ax
	jmp rs
_ret:	popf
	pop si
	pop bp
	ret 2
strlen endp
code ends
	end start