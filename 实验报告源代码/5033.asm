extrn m5034:far
public m5033
code segment
	assume cs:code
m5033 proc far
start:	push ax
	push bx
	pushf
restt:	mov ah,8
	int 21h
	cmp al,1bh
	jz exit
_ret:	call m5034
	cmp dx,0
	jz restt
	popf
	pop bx
	pop ax
	ret
exit:	mov ah,4ch
	int 21h
m5033 endp
code ends
	end start