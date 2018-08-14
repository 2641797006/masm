; 从键盘读取输入的数字字符串
; ;;;  si = buffer地址  ;;;  buffer db 416h dup(?)  ;;;  输入的字符将存入 buffer 中
; push 416h  ;;;  416h = buffer存储空间大小
; call getint

public getint
code segment
	assume cs:code
getint proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf
	xor bx,bx
	mov cx,[bp+6]
rs:	mov ah,8
	int 21h
	cmp al,20h
	jz _rs
	cmp al,2dh
	jz _rs
	cmp al,0dh
	jz _ent
	cmp al,8
	jz bs
	cmp al,30h
	jc rs
	cmp al,3ah
	jnc rs
_rs:	mov dl,al
	mov ah,2
	int 21h
	mov [si],dl
	inc si
	inc bx
	dec cx
	cmp cx,2
	jc _ret
	jmp rs
_ent:	mov dl,0ah
	mov ah,2
	int 21h
	jmp _ret
bs:	cmp bx,0
	jz rs
	call back
	jmp rs
_ret:	mov byte ptr [si],24h
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
getint endp
back proc near
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	mov ah,2
	int 21h
	mov dl,8
	mov ah,2
	int 21h
	dec si
	dec bx
	inc cx
	ret
back endp
code ends
	end start