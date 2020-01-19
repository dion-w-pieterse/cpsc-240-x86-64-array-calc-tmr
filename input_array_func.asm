extern printf
extern scanf
global input_array_func

;*************
segment .data
;*************
;define your data
title             db "Input Array function running...", 10, 0
rsi_value         db "rsi value: %d", 10, 0
;request_input    db	"Please enter float numbers for the vector and terminate with CNTL+D", 10, 0
scanf_fmt         db	"%lf", 0

;*************
segment .bss
;*************
;reserve data for later
align 16
;num_value_array resb 800

;*************
segment .text
;*************
input_array_func:
push	rbp
mov		rbp, rsp

;backup all the registers (maybe main stored some values)
push	rbx
push	rcx
push	rdx
push	rsi
push	rdi
push	r8
push 	r9
push	r10
push	r11
push	r12
push	r13
push	r14
push	r15
pushf

;**************************
;*** start program code ***
;**************************

;collect the values passed as parameters
;rdi = address of array
;rsi = size of array
mov			r15, rdi
mov			r14, rsi

;start input loop
;r13 = loop counter
mov	qword r13, 0

input_loop_begin:
push qword 0
;make sure the limit of the array is not exceeded
cmp			r13, r14		;check array size not exceeded
jge			exit_input_loop

mov	qword 	rax, 0
mov			rdi, scanf_fmt
mov			rsi, rsp
call		scanf
cdq
shl			rdx, 32
or			rax, rdx
cmp			rax, -1
je			exit_input_loop
movsd		xmm15, [rsp]
;store the input data
movsd		[r15 + r13*8], xmm15
pop			rax
inc			r13
jmp			input_loop_begin
exit_input_loop:
pop			rax			;very last iteration pushes so we need one last pop

;return the number of values entered in array
mov	qword	rax, r13

;************************
;*** end program code ***
;************************
popf
pop		r15
pop		r14
pop		r13
pop		r12
pop		r11
pop		r10
pop		r9
pop		r8
pop		rdi
pop		rsi
pop		rdx
pop		rcx
pop		rbx
pop		rbp
ret
