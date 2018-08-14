; 输入 n 个16进制数(0~ffff)
; push array  ;;;  array dw 2bh dup(?)  ;;;  输入的数字将存入array中
; push n  ;;;  n = 2bh  ;;;  n = 要输入的数字个数
; push buffer  ;;;  buffer db 416h dup(?)  ;;;  可读写存储空间(默认大小: 416h byte, 其他大小需修改 # buffer 行)
; call hexcin

public hexcin
extrn gets:far, ups:far, __hex:far, hex__:far, hhex:far
code segment
	assume cs:code
hexcin proc far
start:	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	push si
	pushf
	mov dx,[bp+10]
	mov cx,[bp+8]
rs:	mov si,[bp+6]
	push si
	mov ax,416h		; # buffer db 416h dup(?)
	push ax
	call gets
	push si
	call ups
rd:	call __hex
	cmp byte ptr [si],24h
	jz rs
	mov di,si
	inc si
	call hex__
	push dx
	call hhex
	add dx,2
	dec cx
	cmp cx,0
	jz _ret
	jmp rd
_ret:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
hexcin endp
code ends
	end start