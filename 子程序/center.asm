; �ַ����������  ����80��  string_length<=80���ַ�
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  �ַ�����ַ
; push row  ;;;  row db ?  ;;;  row=�к�, һ�� 0<=row && row<=24
; push color  ;;;  mov bx,color  ;;;  bh=ҳ�� bl=����

public center
extrn zcls:far, strlen:far
code segment
	assume cs:code
center proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov dx,[bp+10]
	push dx
	call strlen
	mov cx,ax
	mov dx,50h
	sub dx,ax
	mov al,dl
	mov dl,2
	div dl
	mov dl,al
	mov ax,[bp+8]
	mov dh,al
	mov bx,[bp+6]
	mov ax,1301h
	int 10h
_ret:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
center endp
code ends
	end start
	