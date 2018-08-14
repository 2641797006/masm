data segment
message db 'This is a sample program of keyboard and display'
	db 0dh, 0ah, 'Please strike the key!', 0dh, 0ah, '$'
fuck	db 0dh, 0ah, 'Illegal character is striked, Please enter angin!', 0dh, 0ah, '$'
data ends
stack segment para stack 'stack'
	db 50 dup(?)
stack ends
code segment
	assume cs:code, ds:data, ss:stack
start:	
	mov ax,data
	mov ds,ax
	mov dx,offset message
	mov ah,9
	int 21h
again:	mov ah,1
	int 21h
	cmp al,1bh
	jz exit
	cmp al,61h
	jc renter
	cmp al,7bh
	jnc renter
	and al,11011111b
	mov dl,al
	mov ah,2
	int 21h
	jmp again
exit:	mov ah,4ch
	int 21h
renter:	mov dx,offset fuck
	mov ah,9
	int 21h
	jmp again
code	ends
	end start
