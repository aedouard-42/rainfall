Dump of assembler code for function main:
   0x08048ec0 <+0>:	push   ebp
   0x08048ec1 <+1>:	mov    ebp,esp
   0x08048ec3 <+3>:	and    esp,0xfffffff0
   0x08048ec6 <+6>:	sub    esp,0x20
   0x08048ec9 <+9>:	mov    eax,DWORD PTR [ebp+0xc]
   0x08048ecc <+12>:	add    eax,0x4
   0x08048ecf <+15>:	mov    eax,DWORD PTR [eax]
   0x08048ed1 <+17>:	mov    DWORD PTR [esp],eax
   0x08048ed4 <+20>:	call   0x8049710 <atoi>
   0x08048ed9 <+25>:	cmp    eax,0x1a7
   0x08048ede <+30>:	jne    0x8048f58 <main+152>
   0x08048ee0 <+32>:	mov    DWORD PTR [esp],0x80c5348
   0x08048ee7 <+39>:	call   0x8050bf0 <strdup>
   0x08048eec <+44>:	mov    DWORD PTR [esp+0x10],eax
   0x08048ef0 <+48>:	mov    DWORD PTR [esp+0x14],0x0
   0x08048ef8 <+56>:	call   0x8054680 <getegid>
   0x08048efd <+61>:	mov    DWORD PTR [esp+0x1c],eax
   0x08048f01 <+65>:	call   0x8054670 <geteuid>
   0x08048f06 <+70>:	mov    DWORD PTR [esp+0x18],eax
   0x08048f0a <+74>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048f0e <+78>:	mov    DWORD PTR [esp+0x8],eax
   0x08048f12 <+82>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048f16 <+86>:	mov    DWORD PTR [esp+0x4],eax
   0x08048f1a <+90>:	mov    eax,DWORD PTR [esp+0x1c]
   0x08048f1e <+94>:	mov    DWORD PTR [esp],eax
   0x08048f21 <+97>:	call   0x8054700 <setresgid>
   0x08048f26 <+102>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048f2a <+106>:	mov    DWORD PTR [esp+0x8],eax
   0x08048f2e <+110>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048f32 <+114>:	mov    DWORD PTR [esp+0x4],eax
   0x08048f36 <+118>:	mov    eax,DWORD PTR [esp+0x18]
   0x08048f3a <+122>:	mov    DWORD PTR [esp],eax
   0x08048f3d <+125>:	call   0x8054690 <setresuid>
   0x08048f42 <+130>:	lea    eax,[esp+0x10]
   0x08048f46 <+134>:	mov    DWORD PTR [esp+0x4],eax
   0x08048f4a <+138>:	mov    DWORD PTR [esp],0x80c5348
   0x08048f51 <+145>:	call   0x8054640 <execv>
   0x08048f56 <+150>:	jmp    0x8048f80 <main+192>
   0x08048f58 <+152>:	mov    eax,ds:0x80ee170
   0x08048f5d <+157>:	mov    edx,eax
   0x08048f5f <+159>:	mov    eax,0x80c5350
   0x08048f64 <+164>:	mov    DWORD PTR [esp+0xc],edx
   0x08048f68 <+168>:	mov    DWORD PTR [esp+0x8],0x5
   0x08048f70 <+176>:	mov    DWORD PTR [esp+0x4],0x1
   0x08048f78 <+184>:	mov    DWORD PTR [esp],eax
   0x08048f7b <+187>:	call   0x804a230 <fwrite>
   0x08048f80 <+192>:	mov    eax,0x0
   0x08048f85 <+197>:	leave  
   0x08048f86 <+198>:	ret    
End of assembler dump.

Analysis of these lines :


The stack looks like this :

        +----------------+
ebp+0xc │     argv       │
        +----------------+
ebp+0x8 │     argc       │
        +----------------+
ebp+0x4 │ return address │
        +----------------+
ebp+0x0 │  old EBP       │
        +----------------+

Therefore:

0x08048ec9 <+9>:	mov    eax,DWORD PTR [ebp+0xc] --> we put argv in eax
0x08048ecc <+12>:	add    eax,0x4                 --> argv points to an array of char pointers.
                                                           On 32-bit x86, each pointer is 4 bytes,
                                                           so eax now points to argv[1].
0x08048ecf <+15>:	mov    eax,DWORD PTR [eax]     --> we put the content of &argv[1] (argv[1]) into eax
0x08048ed1 <+17>:	mov    DWORD PTR [esp],eax     --> we set the content of eax to esp (argv[1])
0x08048ed4 <+20>:	call   0x8049710 <atoi>        --> we call atoi which takes [esp] as an argument (here equals to argv[1])
0x08048ed9 <+25>:	cmp    eax,0x1a7               --> we compare eax (which now contains the return value of atoi) to 0x1a7 (== 423) (test with (gdb) p/d 0x1a7)
0x08048ede <+30>:	jne    0x8048f58 <main+152>    --> if the values are equal, we continue, otherwise we jump to 0x8048f58

Let's continue in this flow:

we can see with gdb :

(gdb) x/s 0x80c5348
0x80c5348:	 "/bin/sh"

0x08048ee0 <+32>:	mov    DWORD PTR [esp],0x80c5348 --> we put the value "/bin/sh" in esp (arg for strdup)
0x08048ee7 <+39>:	call   0x8050bf0 <strdup>        --> we call strdup

0x08048eec <+44>:	mov    DWORD PTR [esp+0x10],eax  --> we set [esp+0x10] to the value of eax (pointer to the string returned by strdup)
0x08048ef0 <+48>:	mov    DWORD PTR [esp+0x14],0x0  --> we set [esp+0x14] to a NULL ptr

0x08048ef8 <+56>:	call   0x8054680 <getegid>       --> we call getegid (no args are required)
0x08048efd <+61>:	mov    DWORD PTR [esp+0x1c],eax  --> we set the returned value of getegid into [esp+0x1c]

0x08048f01 <+65>:	call   0x8054670 <geteuid>       --> we call geteuid (no args are required)
0x08048f06 <+70>:	mov    DWORD PTR [esp+0x18],eax  --> we set the returned value of geteuid into [esp+0x18]

0x08048f0a <+74>:	mov    eax,DWORD PTR [esp+0x1c]  --> we set eax value to the id returned by getegid (gid)
0x08048f0e <+78>:	mov    DWORD PTR [esp+0x8],eax   --> we set [esp+0x8] value to eax (gid)
0x08048f12 <+82>:	mov    eax,DWORD PTR [esp+0x1c]  --> we set eax value to the id returned by getegid (gid)
0x08048f16 <+86>:	mov    DWORD PTR [esp+0x4],eax   --> we set [esp+0x4] value to eax (gid)
0x08048f1a <+90>:	mov    eax,DWORD PTR [esp+0x1c]  --> we set eax value to the id returned by getegid (gid)
0x08048f1e <+94>:	mov    DWORD PTR [esp],eax       --> we set [esp] value to eax (gid)
0x08048f21 <+97>:	call   0x8054700 <setresgid>     --> we now call setresgid which will use the [esp] content as parameters (gid,gid,gid)

0x08048f26 <+102>:	mov    eax,DWORD PTR [esp+0x18]  --> we set eax value to the id returned by geteuid (uid)
0x08048f2a <+106>:	mov    DWORD PTR [esp+0x8],eax   --> we set [esp+0x8] value to eax (uid)
0x08048f2e <+110>:	mov    eax,DWORD PTR [esp+0x18]  --> we set eax value to the id returned by geteuid (uid)
0x08048f32 <+114>:	mov    DWORD PTR [esp+0x4],eax   --> we set [esp+04] value to eax (uid)
0x08048f36 <+118>:	mov    eax,DWORD PTR [esp+0x18]  --> we set eax value to the id returned by geteuid (uid)
0x08048f3a <+122>:	mov    DWORD PTR [esp],eax       --> we set [esp+04] value to eax (uid)
0x08048f3d <+125>:	call   0x8054690 <setresuid>     --> we now call setresuid which will use the [esp] content as parameters (uid,uid,uid)

0x08048f42 <+130>:	lea    eax,[esp+0x10]            --> we set the address value contained by esp+0x10 to eax 
                                                        [esp+0x10] and [esp+0x14] form an array of char pointers:
                                                        [esp+0x10] contains the pointer returned by strdup(), and [esp+0x14] contains NULL.
                                                        Therefore, eax points to the beginning of this argument array.
0x08048f46 <+134>:	mov    DWORD PTR [esp+0x4],eax   --> we set [esp+0x4] (the second argument) to the above array
0x08048f4a <+138>:	mov    DWORD PTR [esp],0x80c5348 --> we set [esp] to the adress of the string containing "/bin/sh"
0x08048f51 <+145>:	call   0x8054640 <execv>         --> we now call execv

0x08048f56 <+150>:	jmp    0x8048f80 <main+192>      --> we jump to the end of the program

Lets' have a look at the other flow (when the return value of atoi is not equal to 423)


0x08048f58 <+152>:	mov    eax,ds:0x80ee170         --> we load the value of the global stderr variable into eax.
0x08048f5d <+157>:	mov    edx,eax                  --> we store it into edx
0x08048f5f <+159>:	mov    eax,0x80c5350            --> we set eax to an address to a string containing "No !\n"
0x08048f64 <+164>:	mov    DWORD PTR [esp+0xc],edx  --> we set the 4th argument to edx (pointer to stderr fd)
0x08048f68 <+168>:	mov    DWORD PTR [esp+0x8],0x5  --> we set the 3rd argument (nmemb) to 5 
0x08048f70 <+176>:	mov    DWORD PTR [esp+0x4],0x1  --> we set the second argument to 1
0x08048f78 <+184>:	mov    DWORD PTR [esp],eax      --> we set the first argument to the adress of the str containing "No !\n"
0x08048f7b <+187>:	call   0x804a230 <fwrite>       --> we now call fwrite

end of the program

With this analysis we can imagine the code of the program in C will look something like this :

#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    char *str;
    char *args[2];
    gid_t gid;
    uid_t uid;

    if (atoi(argv[1]) == 423)
    {
        str = strdup("/bin/sh");

        args[0] = str;
        args[1] = NULL;

        gid = getegid();
        uid = geteuid();

        setresgid(gid, gid, gid);
        setresuid(uid, uid, uid);

        execv("/bin/sh", args);
    }
    else
    {
        fwrite("No !\n", 1, 5, stderr);
    }

    return 0;
}