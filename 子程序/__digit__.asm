public __digit, digit__
code segment
	assume cs:code
;------------------------------------------------------
; ;;;  si = string读取指针
; call __digit  ;;;  扫描到数字则返回([si]=数字 || [si]='$')
;------------------------------------------------------
__digit proc far
start:	push ax
	pushf
rd1:	mov al,[si]
	cmp al,24h
	jz _ret1
	cmp al,2dh
	jz fu1
	cmp al,20h
	jnz _ret1
	inc si
	jmp rd1
fu1:	inc si
	mov al,[si]
	cmp al,30h
	jc rd1
	cmp al,3ah
	jnc rd1
	dec si
_ret1:	popf
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
rd2:	mov al,[si]
	cmp al,2dh
	jz fu2
	cmp al,30h
	jc _ret2
	cmp al,3ah
	jc _rd2
	jmp _ret2
fu2:	cmp di,si
	jnz _ret2
_rd2:	inc si
	jmp rd2
_ret2:	popf
	pop ax
	ret
digit__ endp
code ends
	end start