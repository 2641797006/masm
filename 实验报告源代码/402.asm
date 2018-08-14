extrn gets:far, strlen:far
data segment
	passwd db 'dos123'
	strc db 42bh dup(?)
	ok db 0ah, 'Match! Congratulation', 0ah, '$'
	no db 0ah, 'No Match!', 0ah, '$'
	ban db 0ah, 'You have been banned!$'
data ends
stack segment stack
	dw 80h dup(?)
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov es,ax
	mov ax,stack
	mov ss,ax
	xor bx,bx
rs:	mov dx,offset strc
	push dx
	mov ax,42bh
	push ax
	call gets
	push dx
	call strlen
	mov cx,ax
	cmp cx,6
	jnz _no
	cld
	mov di,offset passwd
	mov si,offset strc
	repz cmpsb
	jnz _no
	mov dx,offset ok
	mov ah,9
	int 21h
	jmp exit
_no:	inc bx
	cmp bx,3
	jnc _ban
	mov dx,offset no
	mov ah,9
	int 21h
	jmp rs
_ban:	mov dx,offset ban
	mov ah,9
	int 21h
exit:	mov ah,4ch
	int 21h
main endp
code ends
	end start
