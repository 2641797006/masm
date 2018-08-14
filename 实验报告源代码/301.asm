data segment
	big db 0ah, 'Too Big', 0ah, '$'
	small db 0ah, 'Too small', 0ah, '$'
	right db 0ah, 'You are right', '$'
	m db 6
data ends
code segment
	assume cs:code, ds:data
start:	mov ax,data
	mov ds,ax
	mov ah,1
	int 21h
;	and al,0fh
	sub al,30h
	cmp al,m
	jc s
	jnz b
	mov dx,offset right
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
b:	mov dx,offset big
	mov ah,9
	int 21h
	jmp start
s:	mov dx,offset small
	mov ah,9
	int 21h
	jmp start
code ends
	end start
