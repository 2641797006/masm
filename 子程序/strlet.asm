; 查找字符串中 '特定字符' 的数量 (区分大小写) !#(以'$'结束)
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待查找字符串地址
; push char  ;;;  char = 's' = 0073h  ;;;  目标字符 (堆栈dw)
; push n  ;;;  n dw ?  ;;;  结果将存入 n 中
; call strlet

public strlet
code segment
	assume cs:code
strlet proc far
start:	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	mov di,[bp+10]
	mov dx,[bp+8]
rs:	mov al,[di]
	inc di
	cmp al,24h
	jz _ret
	cmp al,dl
	jnz next
	inc cx
next:	jmp rs
_ret:	mov di,[bp+6]
	mov [di],cx
	popf
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
strlet endp
code ends
	end start