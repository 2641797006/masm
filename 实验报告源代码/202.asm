data segment
;	table db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	str1 db 'Please enter a four digit number: $'
	str2 db 0dh, 0ah, 'Error! Please enter number angin!', 0dh, 0ah, '$'
	str3 db 0dh, 0ah, 'Then run again, you can also drop out by "ESC"!', 0dh, 0ah, '$'
	str4 db 0dh, 0ah, 'hex: $'
data ends
code segment
	assume cs:code, ds:data
start:
	mov ax,data
	mov ds,ax
	mov dx,offset str1
	mov ah,09h
	int 21h
	mov cx,04h
	and dx,0
cin:	mov ah,01h
	int 21h
	cmp al,1bh
	jz exit
	cmp al,0dh
	jz _do
	cmp al,0ah
	jz _do
	cmp al,30h
	jc err
	cmp al,3ah
	jnc err
	and ax,0fh
	mov bx,ax
	mov ax,dx
	mov dx,0ah
	mul dx
	add ax,bx
	mov dx,ax
	loop cin
_do:	mov bx,dx
	mov dx,offset str4
	mov ah,09h
	int 21h
	mov cx,04h
do:	mov dx,00f0h
	and dl,bh
	shr dx,1
	shr dx,1
	shr dx,1
	shr dx,1
	cmp dl,0ah
	jc num
	add dl,07h
num:	add dl,30h
	mov ah,02h
	int 21h
	shl bx,1
	shl bx,1
	shl bx,1
	shl bx,1
	loop do
	mov dl,0ah
	mov ah,02h
	int 21h
	mov dx,offset str3
	mov ah,09h
	int 21h
	jmp start
exit:	mov ah,4ch
	int 21h
err:	mov cx,04h
	mov dx,offset str2
	mov ah,09h
	int 21h
	and dx,0
	jmp cin
code ends
	end start