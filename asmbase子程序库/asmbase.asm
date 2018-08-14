; # asmbase版本: 2018.06.25.0
; 持续更新中...
; 如发现错误, 或者有所建议, 您可以通过邮箱 " yongxxone@gmail.com " 联系我们

; ***********************************************************************

; 字符串居中输出  单行80列  string_length<=80个字符
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  字符串地址
; push row  ;;;  row db ?  ;;;  row=行号, 一般 0<=row && row<=24
; push color  ;;;  mov bx,color  ;;;  bh=页号 bl=属性

public center
;;; extrn strlen:far
code03 segment
	assume cs:code03
center proc far
start:	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov dx,[bp+10]
	push dx
	call far ptr strlen
	mov cx,ax
	mov dx,50h
	sub dx,ax
	mov al,dl
	mov dl,2
	div dl
	mov dl,al
	mov ax,[bp+8]
	mov dh,al
	mov bx,[bp+6]
	mov ax,1301h
	int 10h
_ret03:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
center endp
code03 ends

; *************************************************************************

; 输入 n 个数字(-32768~32767)
; push array  ;;;  array dw 2bh dup(?)  ;;;  输入的数字将存入array中(-32768~32767)
; push n  ;;;  n = 2bh  ;;;  n = 要输入的数字个数
; push buffer  ;;;  buffer db 416h dup(?)  ;;;  可读写存储空间(默认大小: 416h byte, 其他大小需修改 # buffer 行)
; call cint

public cint
code00 segment
	assume cs:code00
cint proc far
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	push si
	pushf
	mov dx,[bp+10]
	mov cx,[bp+8]
rs00:	mov si,[bp+6]
	mov ax,416h		; # buffer db 416h dup(?)
	push ax
	call far ptr getint
rd00:	call far ptr __digit
	cmp byte ptr [si],24h
	jz rs00
	mov di,si
	inc si
	call far ptr digit__
	push dx
	call far ptr dhex
	add dx,2
	dec cx
	cmp cx,0
	jz _ret00
	jmp rd00
_ret00:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
cint endp
code00 ends

; ********************************************************************

; ;;;  clear screen
; call cls

public cls
code02 segment
	assume cs:code02
cls proc far
	push ax
	push bx
	push cx
	push dx
	pushf
	mov ax,0600h
	mov bh,7
	mov cx,0
	mov dx,184fh
	int 10h
	mov bh,0
	xor dx,dx
	mov ah,2
	int 10h
_ret02:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	ret
cls endp
code02 ends

; ********************************************************************

; 数组输出
; push buffer  ;;;  buffer db 6 dup(?)  ;;;  请求 6 byte 可读写数据空间
; push array  ;;;  array dw 1, 2, ... , 99  ;;;  数组地址
; push 99  ;;;  99=array元素个数
; call couta

public couta
code0 segment
couta proc far
	assume cs:code0
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov bx,[bp+8]
	mov cx,[bp+6]
rs0:	push [bx]
	mov dx,[bp+10]
	push dx
	call far ptr hexd
	mov ah,9
	int 21h
	mov dl,20h
	mov ah,2
	int 21h
	add bx,2
	dec cx
	cmp cx,1
	jnc rs0
_ret0:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
couta endp
code0 ends

; ********************************************************************

; 带符号数组输出(-32768~32767)
; push buffer  ;;;  buffer db 7 dup(?)  ;;;  请求 7 byte 可读写数据空间
; push array  ;;;  array dw 1, 2, ... , 99  ;;;  数组地址
; push 99  ;;;  99=array元素个数
; call coutax

public coutax
code01 segment
coutax proc far
	assume cs:code01
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov bx,[bp+8]
	mov cx,[bp+6]
rs01:	mov dx,[bx]	
	push dx
	mov dx,[bp+10]
	push dx
	call far ptr hexdx
	mov ah,9
	int 21h
	mov dl,20h
	mov ah,2
	int 21h
	add bx,2
	dec cx
	cmp cx,1
	jnc rs01
_ret01:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
coutax endp
code01 ends

; ********************************************************************

; 回车换行

public crlf
code1 segment
crlf proc far
	assume cs:code1
	push ax
	push dx
	mov ah,2
	mov dl,0dh
	int 21h
	mov dl,0ah
	int 21h
_ret1:	pop dx
	pop ax
	ret
crlf endp
code1 ends

; ********************************************************************

public __digit, digit__
code13 segment
	assume cs:code13
;------------------------------------------------------
; ;;;  si = string读取指针
; call __digit  ;;;  扫描到数字则返回([si]=数字 || [si]='$')
;------------------------------------------------------
__digit proc far
	push ax
	pushf
rd113:	mov al,[si]
	cmp al,24h
	jz _ret113
	cmp al,2dh
	jz fu113
	cmp al,20h
	jnz _ret113
	inc si
	jmp rd113
fu113:	inc si
	mov al,[si]
	cmp al,30h
	jc rd113
	cmp al,3ah
	jnc rd113
	dec si
_ret113:popf
	pop ax
	ret
__digit endp
;------------------------------------------------------
; ;;;  si = string读取指针
; call digit__  ;;;  扫描到非数字则返回([si]=非数字)
;------------------------------------------------------
digit__ proc far
	push ax
	pushf
rd213:	mov al,[si]
	cmp al,30h
	jc _ret213
	cmp al,3ah
	jc _rd213
	jmp _ret213
_rd213:	inc si
	jmp rd213
_ret213:popf
	pop ax
	ret
digit__ endp
code13 ends

; ********************************************************************

; 十进制输入
; ;;;  IF ( decs='32765' ): THEN { [di]='3',si=decs+5 }  ;;;  预先设置 di,si
; push array[i]  ;;;  array dw 2bh dup(?)  ;;;  array元素地址(DW)
; call dhex

public dhex
code15 segment
	assume cs:code15
dhex proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	xor cx,cx
	mov al,[di]
	cmp al,2dh
	jnz next15
	inc cx
	inc di
next15:	xor ax,ax
	xor dx,dx
	mov bx,0ah
rs15:	mul bx
	mov dl,[di]
	and dx,0fh
	add ax,dx
	inc di
	cmp di,si
	jnz rs15
_ret15:	cmp cx,0
	jz then15
	not ax
	inc ax
then15:	mov bx,[bp+6]
	mov [bx],ax
	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
dhex endp
code15 ends

; ********************************************************************

; 从键盘读取输入的数字字符串
; ;;;  si = buffer地址  ;;;  buffer db 416h dup(?)  ;;;  输入的字符将存入 buffer 中
; push 416h  ;;;  416h = buffer存储空间大小
; call getint

public getint
code19 segment
	assume cs:code19
getint proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	pushf
	mov di,si
stt19:	xor bx,bx
	mov cx,[bp+6]
rs19:	mov ah,8
	int 21h
	cmp al,20h
	jz _rs19
	cmp al,2dh
	jz _rs19
	cmp al,0dh
	jz _ent19
	cmp al,8
	jz bs19
	cmp al,30h
	jc rs19
	cmp al,3ah
	jnc rs19
_rs19:	mov dl,al
	mov ah,2
	int 21h
	mov [si],dl
	inc si
	inc bx
	dec cx
	cmp cx,2
	jc _pi19
	jmp rs19
_pi19:	mov si,di
	jmp stt19
_ent19:	mov dl,0ah
	mov ah,2
	int 21h
	jmp _ret19
bs19:	cmp bx,0
	jz rs19
	call back19
	jmp rs19
_ret19:	mov byte ptr [si],24h
	popf
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
getint endp
back19 proc near
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	mov ah,2
	int 21h
	mov dl,8
	mov ah,2
	int 21h
	dec si
	dec bx
	inc cx
	ret
back19 endp
code19 ends

; ********************************************************************

; 字符串输入  ;;;  支持 '20h~126h'
; push string  ;;;  string db 416h dup(?)  ;;;  字符串存储地址
; push 416h  ;;;  字符串存储空间string的长度
; call gets

public gets
code2 segment
	assume cs:code2
gets proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor bx,bx
	mov cx,[bp+6]
	mov di,[bp+8]
cin2:	mov ah,8
	int 21h
	cmp al,0dh
	jz _ret2
	cmp al,8
	jz bs2
	cmp al,20h
	jc cin2
	cmp al,7fh
	jnc cin2
	mov dl,al
	mov ah,2
	int 21h
	mov [di],al
	inc di
	inc bx
	dec cx
	cmp cx,2
	jc _ret2
	jmp cin2
bs2:	cmp bx,0
	jz cin2
	call back2
	dec di
	dec bx
	jmp cin2
_ret2:	mov byte ptr [di],24h
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
gets endp
back2 proc near
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	mov ah,2
	int 21h
	mov dl,8
	mov ah,2
	int 21h
	ret
back2 endp
code2 ends

; ********************************************************************

; 字符串输入  ;;;  支持 '20h~126h'
; push string  ;;;  string db 416h dup(?)  ;;;  字符串存储地址
; push 416h  ;;;  字符串存储空间string的长度
; call sgets

public sgets
code21 segment
	assume cs:code21
sgets proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor bx,bx
	mov cx,[bp+6]
	mov di,[bp+8]
cin21:	mov ah,8
	int 21h
	cmp al,0dh
	jz _ret21
	cmp al,8
	jz bs21
	cmp al,20h
	jc cin21
	cmp al,7fh
	jnc cin21
	mov [di],al	;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mov dl,al
	mov dl,2ah
	mov ah,2
	int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;
;	mov [di],al
	inc di
	inc bx
	dec cx
	cmp cx,2
	jc _ret21
	jmp cin21
bs21:	cmp bx,0
	jz cin21
	call back21
	dec di
	dec bx
	jmp cin21
_ret21:	mov byte ptr [di],24h
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
sgets endp
back21 proc near
	mov dl,8
	mov ah,2
	int 21h
	mov dl,0
	mov ah,2
	int 21h
	mov dl,8
	mov ah,2
	int 21h
	ret
back21 endp
code21 ends

; ******************************************************************

; 输入 n 个16进制数(0~ffff)
; push array  ;;;  array dw 2bh dup(?)  ;;;  输入的数字将存入array中
; push n  ;;;  n = 2bh  ;;;  n = 要输入的数字个数
; push buffer  ;;;  buffer db 416h dup(?)  ;;;  可读写存储空间(默认大小: 416h byte, 其他大小需修改 # buffer 行)
; call hexcin

public hexcin
;;; extrn gets:far, ups:far, __hex:far, hex__:far, hhex:far
code22 segment
	assume cs:code22
hexcin proc far
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	push si
	pushf
	mov dx,[bp+10]
	mov cx,[bp+8]
rs22:	mov si,[bp+6]
	push si
	mov ax,416h		; # buffer db 416h dup(?)
	push ax
	call far ptr gets
	push si
	call far ptr ups
rd22:	call far ptr __hex
	cmp byte ptr [si],24h
	jz rs22
	mov di,si
	inc si
	call far ptr hex__
	push dx
	call far ptr hhex
	add dx,2
	dec cx
	cmp cx,0
	jz _ret22
	jmp rd22
_ret22:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
hexcin endp
code22 ends

; *********************************************************************

; 十六进制输入
; ;;;  IF ( decs='2f6e' ): THEN { [di]='2',si=decs+4 }  ;;;  预先设置 di,si
; push array[i]  ;;;  array dw 2bh dup(?)  ;;;  array元素地址(DW)
; call hhex

public hhex
code23 segment
	assume cs:code23
hhex proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov al,[di]
	xor ax,ax
	xor dx,dx
	mov bx,10h
rs23:	mul bx
	mov dl,[di]
	cmp dl,41h
	jc next23
	add dl,9
next23:	and dx,0fh
	add ax,dx
	inc di
	cmp di,si
	jnz rs23
_ret23:	mov bx,[bp+6]
	mov [bx],ax
	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 2
hhex endp
code23 ends

; ***************************************************************

public __hex, hex__
code24 segment
	assume cs:code24
;------------------------------------------------------
; ;;;  si = string读取指针
; call __hex  ;;;  扫描到(大写字母/数字)则返回([si]=(大写字母/数字) || [si]='$')
;------------------------------------------------------
__hex proc far
	push ax
	pushf
rd124:	mov al,[si]
	cmp al,24h
	jz _ret124
	cmp al,30h
	jc _rd124
	cmp al,3ah
	jc _ret124
	cmp al,41h
	jc _rd124
	cmp al,5bh
	jc _ret124
_rd124:	inc si
	jmp rd124
_ret124:popf
	pop ax
	ret
__hex endp
;------------------------------------------------------
; ;;;  si = string读取指针
; call hex__  ;;;  扫描到非(大写字母/数字)则返回([si]=非(大写字母/数字))
;------------------------------------------------------
hex__ proc far
	push ax
	pushf
rd224:	mov al,[si]
	cmp al,30h
	jc _ret224
	cmp al,3ah
	jc _rd224
	cmp al,41h
	jc _ret224
	cmp al,5bh
	jc _rd224
	jmp _ret224
_rd224:	inc si
	jmp rd224
_ret224:popf
	pop ax
	ret
hex__ endp
code24 ends

; ********************************************************************

;单字长无符号十六进制数转十进制
;push hex  ;;;  hex=1234  ;;;  hex为需要转化的十六进制'数'(dw)
;push string  ;;;  string db 6 dup(?)  ;;;  结果将会以字符串形式存入string中, 如string='123$', string='34567$'
;call hexd

public hexd
code3 segment
	assume cs:code3
hexd proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	mov di,[bp+6]
	mov ax,[bp+8]
	mov bx,0ah
rs3:	inc cx
	xor dx,dx
	div bx
	cmp ax,0
	jz done3
	push dx
	jmp rs3
done3:	add dl,30h
	mov ds:[di],dl
	inc di
	dec cx
	cmp cx,0
	jz _ret3
	pop dx
	jmp done3
_ret3:	mov dl,24h
	mov ds:[di],dl
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
hexd endp
code3 ends

; ***************************************************************

; 带符号数(dw)转字符串 : ffffh -> '-1$'
; push hex  ;;;  hex=1234  ;;;  hex为需要转化的十六进制'数'(dw)
; push string  ;;;  string db 7 dup(?)  ;;;  结果将会以字符串形式存入string中, 如string='123$', string='34567$'
; call hexdx

public hexdx
code30 segment
	assume cs:code30
hexdx proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	mov di,[bp+6]
	mov ax,[bp+8]
	cmp ax,8000h
	jc next30
	dec ax
	not ax
	mov byte ptr [di],2dh
	inc di
next30:	mov bx,0ah
rs30:	inc cx
	xor dx,dx
	div bx
	cmp ax,0
	jz done30
	push dx
	jmp rs30
done30:	add dl,30h
	mov ds:[di],dl
	inc di
	dec cx
	cmp cx,0
	jz _ret30
	pop dx
	jmp done30
_ret30:	mov dl,24h
	mov ds:[di],dl
	popf
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
hexdx endp
code30 ends

; ***************************************************************

; 十六进制输出
; push hex  ;;;  hex = 89abh  ;;;  待输出值(dw)
; push string  ;;;  string db 5 dup(?)  ;;;  结果将会以字符串形式存入string中, 如string='2b$', string='45df$'
; call hexh

public hexh
code31 segment
	assume cs:code31
hexh proc far
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	xor dx,dx
	mov cl,4
	mov di,[bp+6]
	mov ax,[bp+8]
rs31:	mov dl,0fh
	and dl,al
	shr ax,cl
	cmp dl,0ah
	jc shuzi31
	add dl,07h
shuzi31:add dl,30h
	push dx
	inc ch
	cmp ax,0
	jz done31
	jmp rs31
done31:	pop dx
	mov [di],dl  ;ds:[di]
	inc di
	dec ch
	cmp ch,0
	jz _ret31
	jmp done31
_ret31:	mov byte ptr [di],24h
	popf
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 4
hexh endp
code31 ends

; *************************************************************

public __letter, letter__
code4 segment
	assume cs:code4
;------------------------------------------------------
; ;;;  si = string读取指针
; call __letter  ;;;  扫描到字母则返回([si]=字母 || [si]='$')
;------------------------------------------------------
__letter proc far
	push ax
	pushf
rd14:	mov al,[si]
	cmp al,24h
	jz _ret14
	cmp al,41h
	jc _rd14
	cmp al,5bh
	jc _ret14
	cmp al,61h
	jc _rd14
	cmp al,7bh
	jc _ret14
_rd14:	inc si
	jmp rd14
_ret14:	popf
	pop ax
	ret
__letter endp
;------------------------------------------------------
; ;;;  si = string读取指针
; call letter__  ;;;  扫描到非字母则返回([si]=非字母)
;------------------------------------------------------
letter__ proc far
	push ax
	pushf
rd24:	mov al,[si]
	cmp al,41h
	jc _ret24
	cmp al,5bh
	jc _rd24
	cmp al,61h
	jc _ret24
	cmp al,7bh
	jc _rd24
	jmp _ret24
_rd24:	inc si
	jmp rd24
_ret24:	popf
	pop ax
	ret
letter__ endp
code4 ends

; **************************************************************

; 字符串转化为全小写形式
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待处理字符串地址(以$结束)
; call lows

public lows
code5 segment
lows proc far
	assume cs:code5
	push bp
	mov bp,sp
	push ax
	push bx
	pushf
	mov bx,[bp+6]
rs5:	mov al,[bx]
	cmp al,24h
	jz _ret5
	cmp al,41h
	jc _rs5
	cmp al,5bh
	jnc _rs5
	add al,20h
	mov [bx],al
_rs5:	inc bx
	jmp rs5
_ret5:	popf
	pop bx
	pop ax
	pop bp
	ret 2
lows endp
code5 ends

; *********************************************************************

; 统计单词在字符串中出现的次数  (!! 区分大小写 !!) 以非字母为界
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  字符串地址(以$结束)
; push cmd  ;;;  cmd db 'this$'  ;;;  要匹配的单词(以$结束)
; push n  ;;;  n dw ?  ;;;  统计结果将存入 n 中
; call match

public match
code6 segment
	assume cs:code6
match proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	push es
	pushf
	mov bx,ds
	mov es,bx
	xor bx,bx
	mov di,[bp+8]
	push di
	call far ptr strlen
	mov dx,ax
	mov si,[bp+10]
rs6:	call far ptr __letter
	cmp byte ptr [si],24h
	jz _ret6
	mov ax,si
	call far ptr letter__
	mov cx,si
	sub cx,ax
	cmp cx,dx
	jnz rs6
	push si
	push di
	mov si,ax
	repz cmpsb
	pop di
	pop si
	jnz rs6
	inc bx
	jmp rs6
_ret6:	mov si,[bp+6]
	mov [si],bx
	popf
	pop es
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
match endp
code6 ends

; **************************************************************

; 数组排序(改变原数组)
; push array  ;;;  array dw 1, 2, ... , 99  ;;;  数组地址
; push 99  ;;;  99=array元素个数
; call sort

public sort
code7 segment
sort proc far
	assume cs:code7
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	pushf
	xor bx,bx
rs7:	inc bx
	cmp bx,[bp+6]
	jz _ret7
	mov cx,[bp+6]
	sub cx,bx
	mov si,[bp+8]
rc7:	mov di,si
	add si,2
	mov ax,ds:[si]
	mov dx,ds:[di]
	cmp ax,dx
	jc _ex7
ex_7:	dec cx
	cmp cx,0
	jnz rc7
	jmp rs7
_ex7:	mov ds:[di],ax
	mov ds:[si],dx
	jmp ex_7
_ret7:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
sort endp
code7 ends

; **********************************************************************

; 获取字符串长度(不计$)
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  字符串地址
; ;;;  执行strlen后: ax = string长度
; call strlen

public strlen
code8 segment
	assume cs:code8
strlen proc far
	push bp
	mov bp,sp
	push si
	pushf
	xor ax,ax
	mov si,[bp+6]
rs8:	cmp byte ptr [si],24h
	jz _ret8
	inc si
	inc ax
	jmp rs8
_ret8:	popf
	pop si
	pop bp
	ret 2
strlen endp
code8 ends

; *************************************************************************

; 查找字符串中 '特定字符' 的数量 (区分大小写) !#(以'$'结束)
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待查找字符串地址
; push char  ;;;  char = 's' = 0073h  ;;;  目标字符 (堆栈dw)
; push n  ;;;  n dw ?  ;;;  结果将存入 n 中
; call strlet

public strlet
code81 segment
	assume cs:code81
strlet proc far
	push bp
	mov bp,sp
	push ax
	push cx
	push dx
	push di
	pushf
	xor cx,cx
	mov di,[bp+10]
	mov dx,[bp+8]
rs81:	mov al,[di]
	inc di
	cmp al,24h
	jz _ret81
	cmp al,dl
	jnz next81
	inc cx
next81:	jmp rs81
_ret81:	mov di,[bp+6]
	mov [di],cx
	popf
	pop di
	pop dx
	pop cx
	pop ax
	pop bp
	ret 6
strlet endp
code81 ends

; *************************************************************************

; 统计字符串中单词数量  ;;;  以非字母为界
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  目标字符串地址(以$结束)
; push num  ;;;  num dw ?  ;;;  统计结果将存入num中
; call strwd

public strwd
code82 segment
	assume cs:code82
strwd proc far
	push bp
	mov bp,sp
	push cx
	push si
	pushf
	xor cx,cx
	mov si,[bp+8]
rs82:	call far ptr __letter
	cmp byte ptr [si],24h
	jz _ret82
	call far ptr letter__
	inc cx
	jmp rs82
_ret82:	mov si,[bp+6]
	mov [si],cx
	popf
	pop si
	pop cx
	pop bp
	ret 4
strwd endp
code82 ends

; **************************************************************************

; 字符串转化为全大写形式
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  待处理字符串地址(以$结束)
; call ups

public ups
code9 segment
ups proc far
	assume cs:code9
	push bp
	mov bp,sp
	push ax
	push bx
	pushf
	mov bx,[bp+6]
rs9:	mov al,[bx]
	cmp al,24h
	jz _ret9
	cmp al,61h
	jc _rs9
	cmp al,7bh
	jnc _rs9
	sub al,20h
	mov [bx],al
_rs9:	inc bx
	jmp rs9
_ret9:	popf
	pop bx
	pop ax
	pop bp
	ret 2
ups endp
code9 ends

; ********************************************************************

; 自定义  clear screen
; push \bx  ;;;  该值将会给bx
; push \cx  ;;;  该值将会给cx
; push \dx  ;;;  该值将会给dx
; call zcls

public zcls
code93 segment
	assume cs:code93
zcls proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	pushf
	mov ax,0600h
	mov bx,[bp+10]
	mov cx,[bp+8]
	mov dx,[bp+6]
	int 10h
;	xor dx,dx
;	mov ah,2
;	int 10h
_ret93:	popf
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
zcls endp
code93 ends

; ****************************************************************

; 输入 n 个数字(-32768~32767)
; push (x0,y0)
; push (x1,y1)
; push array  ;;;  array dw 2bh dup(?)  ;;;  输入的数字将存入array中(-32768~32767)
; push n  ;;;  n = 2bh  ;;;  n = 要输入的数字个数
; push buffer  ;;;  buffer db 416h dup(?)  ;;;  可读写存储空间(默认大小: 416h byte, 其他大小需修改 # buffer 行)
; call zgcint

public zgcint
code94 segment
	assume cs:code94
zgcint proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	pushf
	mov dx,[bp+10]
	mov cx,[bp+8]
rs94:	push [bp+14]
	push [bp+12]
	mov si,[bp+6]
	mov ax,416h		; # buffer db 416h dup(?)
	push ax
	call far ptr zgetint
rd94:	call far ptr __digit
	cmp byte ptr [si],24h
	jz rs94
	mov di,si
	inc si
	call far ptr digit__
	push dx
	call far ptr dhex
	add dx,2
	dec cx
	cmp cx,0
	jz _ret94
	jmp rd94
_ret94:	popf
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 10
zgcint endp
code94 ends

; **************************************************************************

; 从键盘读取输入的数字字符串
; push (x0,y0)
; push (x1,y1)
; ;;;  si = buffer地址  ;;;  buffer db 416h dup(?)  ;;;  输入的字符将存入 buffer 中
; push 416h  ;;;  416h = buffer存储空间大小
; call zgetint

public zgetint
code95 segment
	assume cs:code95
zgetint proc far
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push si
	pushf
stt95:	mov si,[bp-10]
	xor bx,bx
	mov cx,[bp+6]
rs95:	mov ah,8
	int 21h
	cmp al,20h
	jz _rs95
	cmp al,2dh
	jz _rs95
	cmp al,0dh
	jz _ent95
	cmp al,8
	jz bs95
	cmp al,30h
	jc rs95
	cmp al,3ah
	jnc rs95
_rs95:	push bx
	push cx
	mov bh,0
	mov ah,0ah
	mov cx,1
	int 10h
	pop cx
	pop bx
	mov [si],al
	inc si
	inc bx
	dec cx
	call cursor
	cmp cx,2
	jc _ret95
	jmp rs95
_ent95:	push bx
	push cx
	mov bh,0
	mov ah,3
	int 10h
	mov bx,[bp+8]
	mov dl,bl
	mov bh,0
	mov ah,2
	int 10h
	pop cx
	pop bx
	call cursor
	jmp _ret95
bs95:	;cmp bx,0
	;jz rs
	call back
	jmp rs95
_ret95:	mov byte ptr [si],24h
	popf
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 6
zgetint endp
back proc near
	cmp bx,0
	jz then195
	dec si
	dec bx
	inc cx
then195:push bx
	push cx
	mov bh,0
	mov ah,3
	int 10h
	mov ax,[bp+10]
	mov bx,[bp+8]
	cmp ax,dx
	jc then095
	add sp,6
	jmp stt95
then095:cmp al,dl
	jc then295
	dec dh
	mov dl,bl
	mov bh,0
	mov ah,2
	int 10h
	jmp _retb95
then295:dec dl
	mov bh,0
	mov ah,2
	int 10h
_retb95:mov bh,0
	mov ax,0a00h
	mov cx,1
	int 10h
	pop cx
	pop bx
	ret
back endp
cursor proc near
	push ax
	push bx
	push cx
	push dx
	mov bh,0
	mov ah,3
	int 10h
	mov ax,[bp+10]
	mov bx,[bp+8]
	cmp dx,bx
	jc next095
;	ax,bx ()()
	call uproll
	jmp next195
next095:cmp dl,bl
	jc next295
	inc dh
next195:mov dl,al
	mov bh,0
	mov ah,2
	int 10h
	jmp _retc95
next295:inc dl
	mov bh,0
	mov ah,2
	int 10h
_retc95:pop dx
	pop cx
	pop bx
	pop ax
	ret
cursor endp
uproll proc near
	push ax
	push bx
	push cx
	push dx
;	ax,bx ()()
	mov cx,ax
	mov dx,bx
	mov ax,0601h
	mov bh,6eh
	int 10h
	pop dx
	pop cx
	pop bx
	pop ax
	ret
uproll endp
code95 ends
	end start