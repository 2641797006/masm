public __hex, hex__
code segment
	assume cs:code
;------------------------------------------------------
; ;;;  si = string读取指针
; call __hex  ;;;  扫描到(大写字母/数字)则返回([si]=(大写字母/数字) || [si]='$')
;------------------------------------------------------
__hex proc far
start:	push ax
	pushf
rd1:	mov al,[si]
	cmp al,24h
	jz _ret1
	cmp al,30h
	jc _rd1
	cmp al,3ah
	jc _ret1
	cmp al,41h
	jc _rd1
	cmp al,5bh
	jc _ret1
_rd1:	inc si
	jmp rd1
_ret1:	popf
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
rd2:	mov al,[si]
	cmp al,30h
	jc _ret2
	cmp al,3ah
	jc _rd2
	cmp al,41h
	jc _ret2
	cmp al,5bh
	jc _rd2
	jmp _ret2
_rd2:	inc si
	jmp rd2
_ret2:	popf
	pop ax
	ret
hex__ endp
code ends
	end start