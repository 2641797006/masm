; 统计字符串中单词数量  ;;;  以非字母为界
; push string  ;;;  string db 'This is a string ... ... $'  ;;;  目标字符串地址(以$结束)
; push num  ;;;  num dw ?  ;;;  统计结果将存入num中
; call strwd

public strwd
;public __letter, letter__
code segment
	assume cs:code
strwd proc far
start:	push bp
	mov bp,sp
	push cx
	push si
	pushf
	xor cx,cx
	mov si,[bp+8]
rs:	call __letter
	cmp byte ptr [si],24h
	jz _ret
	call letter__
	inc cx
	jmp rs
_ret:	mov si,[bp+6]
	mov [si],cx
	popf
	pop si
	pop cx
	pop bp
	ret 4
strwd endp
;------------------------------------------------------
; ;;;  si = string读取指针
; call __letter  ;;;  扫描到字母则返回([si]=字母 || [si]='$')
;------------------------------------------------------
__letter proc near
	push ax
	pushf
rd1:	mov al,[si]
	cmp al,24h
	jz _ret1
	cmp al,41h
	jc _rd1
	cmp al,5bh
	jc _ret1
	cmp al,61h
	jc _rd1
	cmp al,7bh
	jc _ret1
_rd1:	inc si
	jmp rd1
_ret1:	popf
	pop ax
	ret
__letter endp
;------------------------------------------------------
; ;;;  si = string读取指针
; call letter__  ;;;  扫描到非字母则返回([si]=非字母)
;------------------------------------------------------
letter__ proc near
	push ax
	pushf
rd2:	mov al,[si]
	cmp al,41h
	jc _ret2
	cmp al,5bh
	jc _rd2
	cmp al,61h
	jc _ret2
	cmp al,7bh
	jc _rd2
	jmp _ret2
_rd2:	inc si
	jmp rd2
_ret2:	popf
	pop ax
	ret
letter__ endp
code ends
	end start
