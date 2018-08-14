; 回车换行

public crlf
code segment
crlf proc far
	assume cs:code
start:	push ax
	push dx
	mov ah,2
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
_ret:	pop dx
	pop ax
	ret
crlf endp
code ends
	end start