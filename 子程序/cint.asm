; 输入 n 个数字(-32768~32767)
; push array  ;;;  array dw 2bh dup(?)  ;;;  输入的数字将存入array中(-32768~32767)
; push n  ;;;  n = 2bh  ;;;  n = 要输入的数字个数
; push buffer  ;;;  buffer db 416h dup(?)  ;;;  可读写存储空间(默认大小: 416h byte, 其他大小需修改 # buffer 行)
; call cint

extrn getint:far, __digit:far, digit__:far, dhex:far
public cint
code segment
	assume cs:code
cint proc far
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
	mov ax,416h		; # buffer db 416h dup(?)
	push ax
	call getint
rd:	call __digit
	cmp byte ptr [si],24h
	jz rs
	mov di,si
	call digit__
	push dx
	call dhex
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
cint endp
code ends
	end start