public passwd
data segment
	str0 db 'dos'
	mat db 0ah, 'Match$'
	nom db 0ah, 'NoMatch! Program Terminated!', 0ah, '$'
	str1 db 42bh dup(?)
	i dw 0
data ends
code segment
	assume cs:code, ds:data
passwd proc far
start:	push ax
	push cx
	push dx
	push di
	push si
	push ds
	push es
	mov ax,data
	mov ds,ax
	mov es,ax
rs:	and i,0
	mov cx,42bh
	mov di,offset str1
cin:	mov ah,8
	int 21h
	cmp al,0dh
	jz do
	cmp al,0ah
	jz do
	cmp al,9
	jz cin
	cmp al,8
	jz bs
	mov dl,al
	mov ah,2
	int 21h
	stosb
	inc i
	loop cin	
do:	mov cx,i
	cmp cx,0
	jz _0
	mov di,offset str1
	mov si,offset str0
	cmp cx,3
	jz _3
_n:	mov dx,offset nom
	mov ah,9
	int 21h
	jmp rs
bs:	cmp i,0
	jz cin
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	int 21h
	mov dl,8
	int 21h
	dec di
	dec i
_cin_:	jmp cin
_0:	mov dl,0ah
	mov ah,2
	int 21h
	jmp rs
_3:	repz cmpsb
	jnz _n
	mov dx,offset mat
	mov ah,9
	int 21h
	pop es
	pop ds
	pop si
	pop di
	pop dx
	pop cx
	pop ax
	ret
passwd endp
code ends
	end start
