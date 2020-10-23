; Галкин Никита Сергеевич, БПИ197, вариант 5.
format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        stringX   db 'Enter X: ', 0

        stringArraySize   db 'Size of array A? >> ', 0
        stringWrongSizeInfo db 'Wrong size!', 10, 0
        stringArraysElement  db 'A[%d] >> ', 0

        getInt   db '%d', 0

        stringArrayB   db 'Array B: ', 10, 0
        stringElementsOfB  db 'B[%d] >> %d', 10, 0

        ar           rd 100
        arB          rd 100
        myx          dd 0
        arraySize    dd 0
        i            dd ?

section '.code' code readable executable

start:
; All the inputs.
        push stringX
        call [printf]

        push myx
        push getInt
        call [scanf]

        push stringArraySize
        call [printf]

        push arraySize
        push getInt
        call [scanf]

        mov eax, [arraySize]
        cmp eax, 0
        jg  createArray
; Information about wrong size of arrray A.
        push arraySize
        push stringWrongSizeInfo
        call [printf]
        jmp finish
; Array A creating.
createArray:
        xor ecx, ecx
        mov ebx, ar
; Array A filling.
getElementALooped:
        cmp ecx, [arraySize]
        jge endIt

        mov [i], ecx
        push ecx
        push stringArraysElement
        call [printf]

        push ebx
        push getInt
        call [scanf]

        mov ecx, [i]
        inc ecx

        add ebx, 4
        jmp getElementALooped
endIt:

; Array B creating.
arrayB:
        xor ecx, ecx
        mov ebx, ar
        mov edx, arB

; Array B filling.
arrayBLooped:
        cmp ecx, [arraySize]
        jge endArrayB
        mov eax, [ebx+ecx*4]

        cmp eax, myx
        jne normal

        cmp eax, myx
        je equalsX

normal:
        mov ebp, eax
        mov [edx+ecx*4], ebp
        inc ecx
        jmp arrayBLooped
equalsX:
        inc ecx
        jmp arrayBLooped

endArrayB:

; Displaying of array B
displayArray:
        push stringArrayB
        call [printf]

        xor ecx, ecx
        mov ebx, arB
displayArrayLooped:
        cmp ecx, [arraySize]
        je endDisplayArray
        mov [i], ecx

        push dword [ebx]
        push ecx
        push stringElementsOfB
        call [printf]

        mov ecx, [i]
        inc ecx
        add ebx, 4
        jmp displayArrayLooped
endDisplayArray:

finish:
                call [getch]

                push 0
                call [ExitProcess]


;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'