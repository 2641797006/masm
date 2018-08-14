; 数组输出
; push buffer  ;;;  buffer db 6 dup(?)  ;;;  请求 6 byte 可读写数据空间
; push array  ;;;  array dw 1, 2, ... , 99  ;;;  数组地址
; push 99  ;;;  99=array元素个数
; call couta

extrn hexd:far
public couta

;------------------------------------------
;data segment common
;	__couta_num__ db 6 dup(?)
;data ends
;------------------------------------------

code segment
couta proc far
	assume cs:code
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov bx,[bp+8]
	mov cx,[bp+6]
rs:	push [bx]
	mov dx,[bp+10]
	push dx
	call hexd
	mov ah,9
	int 21h
	mov dl,20h
	mov ah,2
	int 21h
	add bx,2
	dec cx
	cmp cx,1
	jnc rs
_ret:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
couta endp
code ends
	end start