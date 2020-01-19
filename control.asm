extern printf				               ;make printf visible
extern scanf                       ;make scanf visible
extern input_array_func            ;make input_array_func visible
extern output_original_array       ;make output_original_array visible
extern compute_dot                 ;make compute_dot func visible
global control

;*************
segment .data
;*************
;define your data
title                               db 10, "Welcome to the final exam", 10, 0
single_print_fmt                    db	"%lf", 10, 0
request_input		                    db	"Please enter float numbers for the vector and terminate with CNTL+D", 10, 0
second_vect_input                   db 10, 10, "Enter float numbers for another vector of the same size and terminate with CNTL +D", 10, 0
output_heading                      db	"Your vector is ", 0
clock_time_now                      db  10, "Clock time is now %lu tics",10, 0
dot_product                         db	"The dot product is %1.6lf", 0
elapsed_time                        db	"The elapsed time is %lu tics", 0
goodbye_msg                         db	10, "Bye", 0

;*************
segment .bss
;*************
;reserve data for later
align 16
num_value_array resb 800            ;array to hold 100 qwords (8 bytes * 100)
;pdata_array		 resb 800           ;array of pointers, holds 100 qwords (8 bytes * 100)
second_array	resb 800
backup_start_clock resq 1
backup_end_clock resq 1

;*************
segment .text
;*************
control:
push	rbp
mov	rbp, rsp

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

mov	qword	rax, 0
mov			rdi, title
call		printf

;*************************
;*** Input First Array ***
;*************************

;request input message
mov	qword   rax, 0
mov         rdi, request_input
call        printf
;//call the input_array_func and pass it the array and size
mov         rdi, num_value_array
mov         rsi, 100
call        input_array_func
;//place the return value from input_array_func in r15
mov         r15, rax

;*************************
;*** Print First Array ***
;*************************

;//array without sorting message
mov	qword	  rax, 0
mov         rdi, output_heading
call        printf

;//call output_original_array function
mov         rdi, num_value_array
mov         rsi, r15
call        output_original_array

;**************************
;*** Input Second Array ***
;**************************
;out second vector input
mov	qword   rax, 0
mov         rdi, second_vect_input
call        printf

;//call the input_array_func and pass it the array and size
mov         rdi, second_array
mov         rsi, 100
call        input_array_func
;//place the return value from input_array_func in r15
mov         r14, rax

;****************************
;*** Display Second Array ***
;****************************

;//array without sorting message
mov	qword   rax, 0
mov         rdi, output_heading
call        printf

;//call output_original_array function
mov         rdi, second_array
mov         rsi, r14
call        output_original_array

;*******************
;*** Start Timer ***
;*******************
;zero out rdx and rax before timer macro
mov	qword   rax, 0
mov	qword   rdx, 0
cpuid
;call timer rdtsc
;r13 = timer clock value
rdtsc
shl         rdx,	32
or          rdx, rax
mov         r11, rdx
mov         [backup_start_clock], r11


;output clock time now
mov	qword   rax, 0
mov         rdi, clock_time_now
mov         rsi, r11
call        printf

;**************************
;*** Compute Dot Vector ***
;**************************
mov         rdi, num_value_array
mov         rsi, second_array
mov         rdx, r15
call        compute_dot

;value is returned in xmm0
mov	qword   rax, 1
mov         rdi, dot_product
call        printf

;*****************
;*** End Timer ***
;*****************
;zero out rdx and rax
mov	qword   rax, 0
mov	qword   rdx, 0

cpuid

;collect end time stamp
rdtsc
shl         rdx, 32
or          rdx, rax
mov         r10, rdx
mov         [backup_end_clock], r10

;display end tics value
;output clock time now
mov	qword   rax, 0
mov         rdi, clock_time_now
mov         rsi, r10
call        printf

;****************************
;*** Compute Elapsed Time ***
;****************************
;avoid corruption from printf, recover start and end times for clock
mov         r10, [backup_end_clock]
mov         r11, [backup_start_clock]
sub         r10, r11

;output elapsed time
mov	qword	rax, 0
mov         rdi, elapsed_time
mov         rsi, r10
call        printf

;say goodbye
mov	qword   rax, 0
mov         rdi, goodbye_msg
call        printf

;******************************
;*** Return Value to Driver ***
;******************************

;send first value back to driver
movsd		    xmm0, [num_value_array]

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
