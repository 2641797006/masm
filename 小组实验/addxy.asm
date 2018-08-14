; 依赖于asmbase子程序库
; #将 TAB 设置为 8 个空格, 代码更整齐
; 子程序详细说明可以在asmbase.txt中找到
extrn zcls:far, cls:far, zgcint:far, hexdx:far	; 声名调用3个子程序 (其中cint又调用另外3个子程序 digit dhex getint)
outnum	macro num	; ;;; 宏定义 : 输出数字;   
	push num	;#第4行 例: 遇到宏调用指令 outnum xy[0] 时, 将会用'4~9'行的代码替换 outnum xy[0],其中xy[0]将替换掉num
	mov dx,offset buffer
	push dx
	call hexdx	; ;;; hexdx子程序: 将数值转为字符串
	mov ah,9
	int 21h		;#第9行
	endm
__cls__ macro
	mov ah,51h
	push ax
	mov ax,0
	push ax
	mov ax,184fh
	push ax
	call zcls	;cls子程序: 清空屏幕
	mov ah,30h
	push ax
	mov ax,0102h
	push ax
	mov ax,174dh
	push ax
	call zcls
	mov ah,6eh
	push ax
	mov ax,051ch
	push ax
	mov ax,0833h
	push ax
	call zcls
	endm
data segment
	str0 db 'Please enter 2 Integers:$'
	str1 db '(-32768~32767)$'
	str2 db 'Press any key to exit ... ...'
	str2_len equ $-str2
	i dw 0		;循环次数i
	xy dw 3 dup(?)	;输入的2个数字及相加结果将存入xy的3个dw空间
	buffer db 416h dup(?)	;此空间用来临时存储/读取数据, 如输入的内容将先存入其中 给后续子程序处理, 416h 超过 1000 byte的空间足以让使用者随便皮
data ends
stack segment stack	;设置堆栈段 大小为 80h byte 足够后续使用
	dw 80h dup(?)
	tos label word	;这行及下面的mov sp,offset tos一起删掉也无妨,可以忽略
stack ends
code segment
	assume cs:code, ds:data, ss:stack
main proc far
start:	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,offset tos
	mov ax,0003h
	int 10h
	__cls__
rs:	mov bh,0	;$
	mov dx,021ch
	mov ah,2
	int 10h		;$ 置位光标位置 详见课本9.2.2节
	mov dx,offset str0
	mov ah,9
	int 21h
	mov ax,ds
	mov es,ax
	mov bp,offset str1
	mov ax,1301h
	mov bx,0034h
	mov cx,0eh
	mov dx,0321h
	int 10h
	mov bh,0	;$
	mov dx,051ch
	mov ah,2
	int 10h		;$ 置位光标位置 详见课本9.2.2节
	mov ax,051ch
	push ax
	mov ax,0833h
	push ax
	mov ax,offset xy
	push ax
	mov ax,2
	push ax
	mov ax,offset buffer
	push ax		;上面的3个push操作是给cint子程序传递参数, cint具体传参 见asmbase.txt
	call zgcint	;cint子程序: 输入数字/数组(-32768~32767)
	mov ax,xy[0]	;cint输入的2个数存入在以xy[0],xy[2]为首地址的dw空间中
	mov bx,xy[2]	;将2个数移动到寄存器
	add ax,bx	;将2个数相加
	mov xy[4],ax	;相加结果存入以xy[4]为首地址的dw空间中
	__cls__
	mov bh,0	;#
	mov dx,0e21h
	mov ah,2
	int 10h		;# 置位光标
	mov ah,0ch
	push ax
	mov ax,0e02h
	push ax
	mov ax,0e4dh
	push ax
	call zcls
	outnum xy[0]	;数字输出宏调用
	cmp word ptr xy[2],8000h
	jnc then	;判断输入的第二个数正负, 如果是负数则不输出'+'
	mov dl,2bh	;$ 输出'+'
	mov ah,2
	int 21h		;$
then:	outnum xy[2]	;数字输出宏调用
	mov dl,3dh	;#
	mov ah,2
	int 21h		;# 输出'='
	outnum xy[4]	;数字输出宏调用
	inc i		;$
	cmp i,3
	jnc next	;$ 循环判断, 循环3次, 不足3次则重新运行
	jmp rs		;重新运行
next:	mov ax,ds
	mov es,ax
	mov bp,offset str2
	mov ax,1301h
	mov bx,0034h
	mov cx,str2_len
	mov dx,101ah
	int 10h
	mov ah,8
	int 21h
	call cls
	mov ah,1eh
	push ax
	mov ax,0
	push ax
	mov ax,004fh
	push ax
	call zcls
	mov ah,4ch
	int 21h
main endp
code ends
	end start