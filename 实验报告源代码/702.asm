extrn cint:far, couta:far, sort:far
data segment
	str0 db 'Please enter 10 integers: $'
	str1 db 'array: $'
	array dw 0ah dup(?)
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
	mov ax,offset array		;数组 数字存储地址
	push ax
	mov ax,0ah			;待输入数字数量
	push ax
	mov ax,offset buffer		;缓冲区地址
	push ax
	call cint			;输入数组 10个数字
	mov ax,offset array		;待排序数组地址
	push ax
	mov ax,0ah			;数组元素个数
	push ax
	call sort			;数组排序(改变原数组)
	mov dl,0ah
	mov ah,2
	int 21h
	mov dx,offset str1
	mov ah,9
	int 21h
	mov ax,offset buffer		;缓冲区
	push ax
	mov ax,offset array		;待输出数组地址
	push ax
	mov ax,0ah			;数组元素个数
	push ax
	call couta			;输出数组
_ret:	mov ah,4ch
	int 21h
code ends
	end start