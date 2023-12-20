#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include  <errno.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <shellcode_file>\n", argv[0]);
        return 1;
    }
    
    FILE *shellcode_file = fopen(argv[1], "rb");
    if (!shellcode_file) {
        printf("[-] Failed to open shellcode file: %s\n", argv[1]);
        return 1;
    } else {
        printf("[+] Opened shellcode file: %s\n", argv[1]);
    }

    fseek(shellcode_file, 0, SEEK_END);
    size_t shellcode_size = ftell(shellcode_file);
    fseek(shellcode_file, 0, SEEK_SET);

    char *shellcode = mmap(NULL, 
            shellcode_size,
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_ANONYMOUS | MAP_PRIVATE,
            -1,
            0
        );

    if (!shellcode) {
        printf("[-] Failed to allocate memory for shellcode\n");
        fclose(shellcode_file);
        return 1;
    } else {
        printf("[+] Allocated %zu bytes for shellcode at %p\n", shellcode_size, &shellcode);
    }

    if (fread(shellcode, 1, shellcode_size, shellcode_file) != shellcode_size) {
        printf("[-] Failed to read shellcode from file\n");
        fclose(shellcode_file);
        free(shellcode);
        return 1;
    } else {
        printf("[+] Read shellcode from file\n");
    }

    fclose(shellcode_file);

    void (*func)() = (void (*)())shellcode;
    func();

    return 0;
}