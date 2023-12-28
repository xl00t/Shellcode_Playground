; write hello world to stdout
; %rax	System call	%rdi	            %rsi	            %rdx	        %r10	%r8	%r9
; 1	    sys_write	unsigned int fd	    const char *buf	    size_t count
; 60	sys_exit	int error_code

%define SYS_WRITE 1
%define SYS_EXIT 60

%define STDOUT 1

BITS 64
section .text
global _start
_start:

    push SYS_WRITE ; set sys_write syscall number
    pop rax
    
    push STDOUT    ; set stdout file descriptor
    pop rdi
    jmp end
start:
    pop rbx        ; pop the ret address from the stack to rbx
    lea rsi, [rbx] ; set hello_world buffer to rsi

    push hello_world_len       ; set hello_world_len to rdx
    pop rdx
    syscall

    xor rdi, rdi  ; set 0 to rdi
    push SYS_EXIT  ; set sys_exit syscal number to rax
    pop rax
    syscall

end:
    call start
hello_world: db "Hello, World!", 0x0a
hello_world_len: equ $ - hello_world