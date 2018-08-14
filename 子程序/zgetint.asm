; 从键盘读取输入的数字字符串
; push (x0,y0)
; push (x1,y1)
; ;;;  si = buffer地址  ;;;  buffer db 416h dup(?)  ;;;  输入的字符将存入 buffer 中
; push 416h  ;;;  416h = buffer存储空间大小
; call zgetint

public zgetint
code segment
	assume cs:code
zgetint proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf
stt:	mov si,[bp-10]
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
_rs:	push bx
	push cx
	mov bh,0
	mov ah,0ah
	mov cx,1
	int 10h
	pop cx
	pop bx
	mov [si],al
	inc si
	inc bx
	dec cx
	call cursor
	cmp cx,2
	jc _ret
	jmp rs
_ent:	push bx
	push cx
	mov bh,0
	mov ah,3
	int 10h
	mov bx,[bp+8]
	mov dl,bl
	mov bh,0
	mov ah,2
	int 10h
	pop cx
	pop bx
	call cursor
	jmp _ret
bs:	;cmp bx,0
	;jz rs
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
	ret 6
zgetint endp
back proc near
	cmp bx,0
	jz then1
	dec si
	dec bx
	inc cx
then1:	push bx
	push cx
	mov bh,0
	mov ah,3
	int 10h
	mov ax,[bp+10]
	mov bx,[bp+8]
	cmp ax,dx
	jc then0
	add sp,6
	jmp stt
then0:	cmp al,dl
	jc then2
	dec dh
	mov dl,bl
	mov bh,0
	mov ah,2
	int 10h
	jmp _retb
then2:	dec dl
	mov bh,0
	mov ah,2
	int 10h
_retb:	mov bh,0
	mov ax,0a00h
	mov cx,1
	int 10h
	pop cx
	pop bx
	ret
back endp
cursor proc near
	push ax
	push bx
	push cx
	push dx
	mov bh,0
	mov ah,3
	int 10h
	mov ax,[bp+10]
	mov bx,[bp+8]
	cmp dx,bx
	jc next0
;	ax,bx ()()
	call uproll
	jmp next1
next0:	cmp dl,bl
	jc next2
	inc dh
next1:	mov dl,al
	mov bh,0
	mov ah,2
	int 10h
	jmp _retc
next2:	inc dl
	mov bh,0
	mov ah,2
	int 10h
_retc:	pop dx
	pop cx
	pop bx
	pop ax
	ret
cursor endp
uproll proc near
	push ax
	push bx
	push cx
	push dx
;	ax,bx ()()
	mov cx,ax
	mov dx,bx
	mov ax,0601h
	mov bh,6eh
	int 10h
	pop dx
	pop cx
	pop bx
	pop ax
	ret
uproll endp
code ends
	end start