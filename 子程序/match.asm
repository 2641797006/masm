; 统计单词在字符串中出现的次数  (!! 区分大小写 !!) 以非字母为界
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  字符串地址(以$结束)
; push cmd  ;;;  cmd db 'this$'  ;;;  要匹配的单词(以$结束)
; push n  ;;;  n dw ?  ;;;  统计结果将存入 n 中
; call match

public match
extrn __letter:far, letter__:far, strlen:far
code segment
	assume cs:code
match proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	pushf
	mov bx,ds
	mov es,bx
	xor bx,bx
	mov di,[bp+8]
	push di
	call strlen
	mov dx,ax
	mov si,[bp+10]
rs:	call __letter
	cmp byte ptr [si],24h
	jz _ret
	mov ax,si
	call letter__
	mov cx,si
	sub cx,ax
	cmp cx,dx
	jnz rs
	push si
	push di
	mov si,ax
	repz cmpsb
	pop di	;;;-------!
	pop si	;;;-------!
	jnz rs
	inc bx
	jmp rs
_ret:	mov si,[bp+6]
	mov [si],bx
	popf
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
match endp
code ends
	end start
