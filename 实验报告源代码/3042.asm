public char
data segment
	dig db 0ah, 'It is a digital', 0ah, '$'
	lowc db 0ah, 'It is a lowcaseletter', 0ah, '$'
data ends
code segment
	assume cs:code, ds:data
char proc far
start:	push ax
	push dx
	push ds
	mov ax,data
	mov ds,ax
cin:	mov ah,1
	int 21h
	cmp al,0dh
	jz _ret
	cmp al,30h
	jc cin
	cmp al,3ah
	jc _dig
	cmp al,41h
	jc cin
	cmp al,5bh
	jc _lowc
	cmp al,61h
	jc cin
	cmp al,7bh
	jc _lowc
	cmp al,7bh
	jnc cin
;exit:	
_dig:	mov dx,offset dig
	mov ah,9
	int 21h
	jmp cin
_lowc:	mov dx,offset lowc
	mov ah,9
	int 21h
	jmp cin
_ret:	pop ds
	pop dx
	pop ax
	ret
char endp
code ends
	end start
