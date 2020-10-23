format PE console
include 'win32a.inc'
entry start

.data:
  strEnterX db 'Enter X:',13,10,0
  arrSize db 'Array size:',13,10,0
     Enter_elements db 'Put array:',13,10,0
      Result db 'Result: ',0
  get_int db '%d',0
  put_int db ' %d',0
  myNX dd 0
  array1 dd 0
  array2 dd 0
  arraySize dd 0
start: 
   cinvoke printf,strEnterX
   cinvoke scanf,get_int,myNX
   cinvoke printf,arrSize
   cinvoke scanf,get_int,arraySize

   mov eax,[arraySize]
   shl eax,2
   cinvoke malloc,eax
   mov [array1],eax
   mov eax,[arraySize]
   shl eax,2
   push eax
   cinvoke malloc,eax
   mov [array2],eax

   call ArrayInput
   call tryCalc
   call PrintResult

   cinvoke free,[array1]
   cinvoke free,[array2]
   cinvoke scanf,get_int,myNX
   ret

ArrayInput:
        cinvoke printf,Enter_elements
        mov eax,[array1]
        mov ecx,[arraySize]
        .input_loop:
        pusha
        cinvoke scanf,get_int,eax
        popa
        add eax,4
        loop .input_loop
        ret

tryCalc:
          mov     esi,array1
          mov     edi,array2
          cld
          mov     ecx, 4
          rep     movsb

ret
PrintResult:
        cinvoke printf,Result
        mov eax,[array2]
        mov ecx,[arraySize]
        .print_loop:
        pusha

        cmp eax, cnk
        jne cnk

        popa
        add eax,4
        loop .print_loop
        ret
cnk:
        cinvoke printf,put_int,[eax]
  
section 'import' import readable
library msvcrt,'msvcrt.dll'
import msvcrt,\
       printf,'printf',\
       scanf,'scanf',\
       free,'free',\
       malloc,'malloc'