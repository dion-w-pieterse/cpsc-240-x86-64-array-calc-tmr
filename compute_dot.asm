extern printf
extern scanf
global compute_dot

;*************
segment .data
;*************
;define your data
title db "Welcome to Practice Application", 10, 0

;*************
segment .bss
;*************
;reserve data for later
align 16
num_array resb 80
;*************
segment .text
;*************
compute_dot:
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

;showregisters 1		;SHOW GEN.REGISTERS
;showxmmregisters 2		;SHOW XMM REGISTERS
;dumpstack 3, 0, 10		;SHOW STACK

;show HEAP (to view array)
;mov rbp, test_array
;dumpstack 10, 0, 8		;SHOW HEAP

mov			r15, rdi;start address of first array
mov			r14, rsi;start address of second array
mov			r13, rdx;size of arrays (expected to be the same)

mov	qword	r12, 0;zero out loop counter
mov	qword	r11, 0

;zero out accumulator
push r11
cvtsi2sd	xmm13, [rsp]
pop r11

multiply_loop:
cmp			r12, r13
jge			exit_multiply_loop
movsd		xmm15, [r15 + r12*8];value from first array
movsd		xmm14, [r14 + r12*8];value from second array
mulsd		xmm15, xmm14
addsd		xmm13, xmm15		;add product to accumulator
inc			r12
jmp			multiply_loop
exit_multiply_loop:

;return the total back to caller function
movsd		xmm0, xmm13

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
