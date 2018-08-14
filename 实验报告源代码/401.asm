extrn hexd:far, couta:far
data segment
	arr dw 243, 263, 372, 7866, 3389, 2306
	max db 6 dup(?)
data ends
stack segment stack
	dw 80h dup(?)
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
;;;
	mov bx,offset max
	push bx
	mov bx,offset arr
	push bx
	mov ax,6
	push ax
	call couta
;;;
	mov dl,0ah
	mov ah,2
	int 21h
	mov bx,offset arr
	mov cx,bx
	add cx,12
la:	mov dx,[bx]
lb:	add bx,2
	cmp bx,cx
	jnc _max
	cmp dx,[bx]
	jc la
	jnc lb
_max:	push dx
	mov dx,offset max
	push dx
	call hexd
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
main endp
code ends
	end start
