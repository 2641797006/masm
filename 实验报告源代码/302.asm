data segment
	dig db 0ah, 'It is a digital', 0ah, '$'
	lowc db 0ah, 'It is a lowcaseletter', 0ah, '$'
data ends
stack segment stack
	dw 64 dup(?)
stack ends
code segment
	assume cs:code, ds:data, ss:stack
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
cin:	mov ah,1
	int 21h
	cmp al,0dh
	jz exit
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
exit:	mov ah,4ch
	int 21h
_dig:	mov dx,offset dig
	mov ah,9
	int 21h
	jmp cin
_lowc:	mov dx,offset lowc
	mov ah,9
	int 21h
	jmp cin
code ends
	end start
