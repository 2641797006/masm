data segment
	str0 db 'dos'
	mat db 0ah, 'Match$'
	nom db 0ah, 'NoMatch! Program Terminated!', 0ah, '$'
	str1 db 42bh dup(?)
	i dw 0
data ends
stack segment stack
	dw 80h dup(?)
stack ends
code segment
	assume cs:code, ds:data, ss:stack
start:	mov ax,data
	mov ds,ax
	mov es,ax
	mov ax,stack
	mov ss,ax
	and i,0
	mov cx,42bh	;输入字符数量超过42bh个时无需回车, 自动结束输入
	mov di,offset str1
cin:	mov ah,8	;输入不回显(检测Ctrl+C总没反应)
	int 21h
	cmp al,0dh	;回车结束输入
	jz do
	cmp al,0ah
	jz do
	cmp al,9	;TAB 与 退格符处理 产生异常, 拒绝TAB输入
	jz cin
	cmp al,8	;跳转到退格符处理
	jz bs
	mov dl,al	;回显之前输入的字符
	mov ah,2
	int 21h
	stosb		;存储输入的字符
	inc i
	loop cin	;持续输入字符
do:	mov cx,i	;开始处理输入, 输入字符数量 与 预置字符串长度 比较
	cmp cx,0
	jz _0
	mov di,offset str1
	mov si,offset str0
	cmp cx,3
	jz _3
_n:	mov dx,offset nom	;字符串配对失败处理
	mov ah,9
	int 21h
	jmp start
bs:	cmp i,0		;退格符backspace处理
	jz cin		;
	mov dl,8	;
	mov ah,2	;
	int 21h		;
	mov dl,0	;
	int 21h		;
	mov dl,8	;
	int 21h		;删除屏幕显示的字符
	dec di		;移动字符输入指针
	dec i		;修改字符数量统计
_cin_:	jmp cin		;重新输入
_0:	mov dl,0ah	;对直接回车的处理
	mov ah,2
	int 21h
	jmp start
_3:	repz cmpsb	;输入字符数量与预置字符串相同时, 比较两字符串
	jnz _n
	mov dx,offset mat
	mov ah,9
	int 21h
	mov ah,4ch
	int 21h
code ends
	end start
