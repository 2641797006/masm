; 数组排序(改变原数组)
; push array  ;;;  array dw 1, 2, ... , 99  ;;;  数组地址
; push 99  ;;;  99=array元素个数
; call sort

public sort
code segment
sort proc far
	assume cs:code
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	pushf
	xor bx,bx
rs:	inc bx
	cmp bx,[bp+6]
	jz _ret
	mov cx,[bp+6]
	sub cx,bx
	mov si,[bp+8]
rc:	mov di,si
	add si,2
	mov ax,ds:[si]
	mov dx,ds:[di]
	cmp ax,dx
	jc _ex
ex_:	dec cx
	cmp cx,0
	jnz rc
	jmp rs
_ex:	mov ds:[di],ax
	mov ds:[si],dx
	jmp ex_
_ret:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
sort endp
code ends
	end start