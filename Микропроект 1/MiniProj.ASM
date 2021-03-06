; ������ ������ ���������, ���197, ����������� �1.
format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
         ; ��������� �����.
         displayY db "Your function is : y = a + b*(x**3)", 0
         getAInfo db "Input a >> ", 0
         getBInfo db "Input b >> ", 0
         getx1Info db "Input x1 >> ", 0
         getx2Info db "Input x2 >> ", 0
         resultInfo db "Result is %d", 0

         ; ����� ��� ���� ������.
         spaceStr db "%d", 0

         ; ������ ������.
         ; ������� �� ������ ������.
         gap db 0x0A
         ; ���.
         step dd 1
         ; � �� �������.
         a   dd ?
         ; b �� �������.
         b   dd ?
         ; ������� ��������������.
         x1  dd ?
         x2  dd ?

section '.code' code readable executable
; ������ ���������.
start:
        ; ����� ������� �������.
        push displayY
        call [printf]

        ; ������� �� ������ ������ ����� ������� �������.
        push gap
        call [printf]

        ; ��������� ������ �� ���� �.
        push getAInfo
        call [printf]

        ; ��������� �.
        push a
        push spaceStr
        call [scanf]

        ; ��������� ������ �� ���� b.
        push getBInfo
        call [printf]

        ; ��������� b.
        push b
        push spaceStr
        call [scanf]

        ; ��������� ������ �� ���� x1.
        push getx1Info
        call [printf]

        ; ��������� x1.
        push x1
        push spaceStr
        call [scanf]

        ; ��������� ������ �� ���� x2.
        push getx2Info
        call [printf]

        ; ��������� x2.
        push x2
        push spaceStr
        call [scanf]

        mov edx, [x1]       ; ��� ��������� �1 � �2 ������� �������� �1 � ������� edx.

        cmp edx, [x2]       ; ���� �1 < �2
        jl normalAlgo

        cmp edx, [x2]       ; ���� �1 = �2
        je zeroAlgo

        call negativeAlgo   ; ���� �1 > �2

; ��������, ���������� ��� �������� ������� x'�� (x1 > x2).
negativeAlgo:
        ; ����� � �������.
        mov edx, [x1]
        xchg edx, [x2]
        mov [x1], edx
        ; ���� ���������� �������� x � ������� edx.
        mov edx, [x1]
        add edx, [step]
        mov eax, edx       ; ������� ���������� �������� � � eax.
        mov ebx, 0         ; C���� �������� (� ���������� - ��������).
        call mainCycle     ; ��������� ���������.

        call inverse       ; ��� ��������� ������� ����� ���������� �������� ���� ����������.

; ��������, ���������� ��� �������� ��������� �.
zeroAlgo:
        call printResultZero ; ����� �������� ����������.

; ���������� ��������, ���������� ��� �1 < �2.
normalAlgo:
        ; ���� ���������� �������� x � ������� edx.
        mov edx, [x1]
        add edx, [step]
        mov eax, edx       ; ������� ���������� �������� � � eax.
        mov ebx, 0         ; C���� �������� (� ���������� - ��������).
        call mainCycle     ; ��������� ���������.

        call printResult   ; ������� ���������.

; ����� ���������� � �������.
printResult:
        push ebx
        push resultInfo
        call [printf]

        call finish

; ����� �������� ���������� (���� �1 = �2)
printResultZero:
        push 0
        push resultInfo
        call [printf]
        call finish

; ���� ���������� ���������.
mainCycle:
        mov ecx, eax ; ���������� �������� eax (����� � �������� ������� �������).

        ; ������� y �� ������� ������� (���������� � eax).
        mov edx, eax
        imul eax, edx
        imul eax, edx      ; ���������� � ���.
        imul eax, [b]      ; ��������� �� b.
        add eax, [a]       ; �������� � a.
        mul [step]         ; ��������� ������� �������.

        add ebx, eax       ; ���������� ������� � �������� (���������� ��������).

        mov eax, ecx       ; ����������� ������� �������� eax (������� �������).

        cmp eax, [x2]      ; �������� �� ��������� �����.
        jne continue

        ret

; ������ ���� ebx (���������) �� ���������������.
inverse:
        mov eax, ebx       ; ��������� �������� � �������� eax.

        cdq                ; ����������� ����������� �������� eax.
        imul eax, -1       ; ������ ���� ���������.

        mov ebx, eax       ; ���������� �������� ��������� � ebx.

        call printResult   ; ������� ���������.

; �������� ����������� �����.
continue:
        add eax, [step]    ; ���������� x �� ���.
        jmp mainCycle      ; ��������� ����.

; �������� ���������� ������ ���������.
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