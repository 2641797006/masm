extrn crlf:far
public m5034
; if enter Y: bx=1, else: bx=0
data segment
	str1 db 0ah, 'Will you continue program really?(Y/N): $'
data ends
code segment
	assume cs:code
m5034 proc far
start:	push ax
	pushf
	push ds
	mov ax,data
	mov ds,ax
	mov dx,offset str1
	mov ah,9
	int 21h
	mov ah,1
	int 21h
	call crlf
	xor dx,dx
	cmp al,'Y'
	jz _ret
	cmp al,'y'
	jz _ret
	inc dx
_ret:	pop ds
	popf
	pop ax
	ret
m5034 endp
code ends
	end start