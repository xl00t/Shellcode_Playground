# Shellcode Playground

This is a project that provides a shellcode runner along with various examples of shellcodes for educational purposes.
The shellcodes are based on x86_64 architechture

## Features

- Shellcode Runner: A tool to execute shellcodes.
- Shellcode Examples: A collection of shellcodes for demonstration and learning.

## Getting Started

To get started with the shellcode runner, follow these steps:

1. Clone the repository: `git clone https://github.com/xl00t/Shellcode_Playground`
2. Install the necessary dependencies: `apt install binutils make gcc nasm`
3. Build the runner and the shellcodes `make`
3. Run the shellcode runner with the shellcode you want: `./runner shellcodes/build/bin_sh.bin`

## Usage example
```
$ ./runner shellcodes/build/bin_sh.bin
[+] Opened shellcode file: shellcodes/build/bin_sh.bin
[+] Allocated 43 bytes for shellcode at 0x7fff85ff1060
[+] Read shellcode from file
[+] Mapped 43 bytes for shellcode at 0x7fff85ff1058 with 7 PROT
$ echo "Hello, world"
Hello, world
$ exit
```