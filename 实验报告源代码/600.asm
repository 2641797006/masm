extrn sgets:far
data segment
	str0 db 'Please enter a string: $'
	buffer db 416h dup(?)
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
	mov dx,offset str0
	mov ah,9
	int 21h
	mov bx,offset buffer		;缓冲区地址
	push bx
	mov ax,416h			;缓冲区大小
	push ax
	call sgets			;输入字符串回显'*'
rd:	mov al,[bx]			;加密输入内容
	cmp al,24h
	jz _ret
	cmp al,41h
	jc _rd
	cmp al,57h			;根据输入内容选择不加密方式
	jc encrp1
	cmp al,5bh
	jc encrp2
	cmp al,61h
	jc _rd
	cmp al,77h
	jc encrp1
	cmp al,7bh
	jc encrp2
	jmp _rd
encrp1:	add al,4			;加4加密
	jmp _rd
encrp2:	sub al,16h			;减16h回到字母表开头
_rd:	mov [bx],al
	inc bx
	jmp rd
_ret:	mov dl,0ah
	mov ah,2
	int 21h
	mov dx,offset buffer
	mov ah,9	
	int 21h				;输出密文
	mov ah,4ch
	int 21h
code ends
	end start