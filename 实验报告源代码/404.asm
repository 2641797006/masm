extrn strwd:far, match:far, hexd:far
data segment
	str1 db 'a sun two sUn three sun four c.sun five sun-This is a string ... ... $'
	cmd db 'sun$'
	str2 db 'words: $'
	str3 db 'key words: $'
	n0 dw ?
	n1 dw ?
	buffer0 db 6 dup(?)
	buffer1 db 6 dup(?)
data ends
stack segment stack
	dw 80h dup(?)
	tos label word
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,offset tos
	mov dx,offset str1
	mov ah,9
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	mov dx,offset cmd
	mov ah,9
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	mov dx,offset str1
	push dx
	mov ax,offset n0
	push ax
	call strwd
	push dx
	mov ax,offset cmd
	push ax
	mov ax,offset n1
	push ax
	call match
	mov dx,offset str2
	mov ah,9
	int 21h
	mov ax,n0
	push ax
	mov dx,offset buffer0
	push dx
	call hexd
	mov ah,9
	int 21h
	mov dl,0ah
	mov ah,2
	int 21h
	mov dx,offset str3
	mov ah,9
	int 21h
	mov ax,n1
	push ax
	mov dx,offset buffer1
	push dx
	call hexd
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
main endp
code ends
	end start