; 字符串转化为全小写形式
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待处理字符串地址(以$结束)
; call lows

public lows
code segment
lows proc far
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
	cmp al,41h
	jc rs
	cmp al,5bh
	jnc rs
	add al,20h
	mov [bx],al
_rs:	inc bx
	jmp rs
_ret:	popf
	pop bx
	pop ax
	pop bp
	ret 2
lows endp
code ends
	end start