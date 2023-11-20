IO244 equ 0270H
IO273 equ 0260H

mystack segment stack
	dw 100 dup(?)
mystack ends

mydata segment word public 'data'
mydata ends

mycode segment
assume cs:mycode, ds:mydata, ss:mystack
start proc near
	mov ax, mydata
	mov ds, ax
init:
	mov dx, IO244
	in ax, dx
	and ax, 00FFH
	cmp ax, 0FFH
	jz q1
	cmp ax, 0
	jz q2
	mov dx, IO273
	not ax
	out dx, ax
	jmp init
q1:
	mov ax, 0FF7FH
	mov dx, IO273
lr:
	call delay
	out dx, ax
	ror ax, 1
	cmp ax, 07FFFH
	jne lr
	jmp init
q2:
	mov ax, 0FFFEH
	mov dx, IO273
rl:
	call delay
	out dx, ax
	rol ax, 1
	cmp ax, 0FEFFH
	jne rl
	jmp init

delay proc near
dalay1:
	xor cx, cx
	loop $
	ret
delay endp
start endp

mycode ends
end start

