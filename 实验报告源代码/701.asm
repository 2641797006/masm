extrn hexcin:far, couta:far, crlf:far
data segment
	str0 db 'hex: $'
	str1 db 'dec: $'
	hex dw ?
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
	mov ax,offset hex
	push ax
	mov ax,1
	push ax
	mov ax,offset buffer		;缓冲区地址
	push ax
	call hexcin			;以16进制形式输入数值
	call crlf			;回车换行
	mov dx,offset str1
	mov ah,9
	int 21h
	mov ax,offset buffer		;缓冲区地址
	push ax
	mov ax,offset hex		;(10进制形式)待输出数值
	push ax
	mov ax,1			;一个数字
	push ax
	call couta			;输出数值的10进制形式字符串
_ret:	mov ah,4ch
	int 21h
code ends
	end start