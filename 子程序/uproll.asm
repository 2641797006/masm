; ;;;  roll up the screen
; push (x0,y0)
; push (x1,y1)
; call uproll

public uproll
code segment
	assume cs:code, ds:data, ss:stack
uproll proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf
	call cls
rs:	mov ah,2
	mov dh,win_lrr
	mov dl,win_ulc
	mov bh,0
	int 10h
	mov cx,win_width
lop:	mov ah,1
	int 21h
	cmp al,1bh
	jz exit
	loop lop

	mov ax,0601h
	mov ch,win_ulr
	mov cl,win_ulc
	mov dh,win_lrr
	mov dl,win_lrc
	mov bh,23h
	int 10h
	jmp rs
exit:	mov ah,4ch
	int 21h
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
uproll endp
code ends
	end start