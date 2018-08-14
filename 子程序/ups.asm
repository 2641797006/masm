; 字符串转化为全大写形式
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待处理字符串地址(以$结束)
; call ups

public ups
code segment
ups proc far
	assume cs:code
start:	push bp
	mov bp,sp
	push ax
	push bx
	pushf
	mov bx,[bp+6]
rs:	mov al,[bx]
	cmp al,24h
	jz _ret
	cmp al,61h
	jc _rs
	cmp al,7bh
	jnc _rs
	sub al,20h
	mov [bx],al
_rs:	inc bx
	jmp rs
_ret:	popf
	pop bx
	pop ax
	pop bp
	ret 2
ups endp
code ends
	end start