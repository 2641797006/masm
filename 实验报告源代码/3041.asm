data segment
	big db 0ah, 'Too Big', 0ah, '$'
	small db 0ah, 'Too small', 0ah, '$'
	right db 0ah, 'You are right', '$'
	m db 6
public guess
data ends
code segment
	assume cs:code, ds:data
guess proc far
start:	push ax
	push dx
	push ds
rs:	mov ax,data
	mov ds,ax
	mov ah,1
	int 21h
	cmp al,1bh
	jz _ret
;	and al,0fh
	sub al,30h
	cmp al,m
	jc s
	jnz b
	mov dx,offset right
	mov ah,9
	int 21h
	jmp _ret
b:	mov dx,offset big
	mov ah,9
	int 21h
	jmp rs
s:	mov dx,offset small
	mov ah,9
	int 21h
	jmp rs
_ret:	pop ds
	pop dx
	pop ax
	ret
guess endp
code ends
	end start
	