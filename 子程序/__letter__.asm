public __letter, letter__
code segment
	assume cs:code
;------------------------------------------------------
; ;;;  si = string读取指针
; call __letter  ;;;  扫描到字母则返回([si]=字母 || [si]='$')
;------------------------------------------------------
__letter proc far
start:	push ax
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
letter__ proc far
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