; Галкин Никита Сергеевич, БПИ197, Микропроект №1.
format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable
         ; Текстовые формы.
         displayY db "Your function is : y = a + b*(x**3)", 0
         getAInfo db "Input a >> ", 0
         getBInfo db "Input b >> ", 0
         getx1Info db "Input x1 >> ", 0
         getx2Info db "Input x2 >> ", 0
         resultInfo db "Result is %d", 0

         ; Форма под ввод данных.
         spaceStr db "%d", 0

         ; Ячейки памяти.
         ; Перенос на другую строку.
         gap db 0x0A
         ; Шаг.
         step dd 1
         ; а из формулы.
         a   dd ?
         ; b из формулы.
         b   dd ?
         ; Отрезок интегрирования.
         x1  dd ?
         x2  dd ?

section '.code' code readable executable
; Начало программы.
start:
        ; Вывод формулы функции.
        push displayY
        call [printf]

        ; Перенос на другую строку после формулы функции.
        push gap
        call [printf]

        ; Текстовый запрос на ввод а.
        push getAInfo
        call [printf]

        ; Получение а.
        push a
        push spaceStr
        call [scanf]

        ; Текстовый запрос на ввод b.
        push getBInfo
        call [printf]

        ; Получение b.
        push b
        push spaceStr
        call [scanf]

        ; Текстовый запрос на ввод x1.
        push getx1Info
        call [printf]

        ; Получение x1.
        push x1
        push spaceStr
        call [scanf]

        ; Текстовый запрос на ввод x2.
        push getx2Info
        call [printf]

        ; Получение x2.
        push x2
        push spaceStr
        call [scanf]

        mov edx, [x1]       ; Для сравнения х1 и х2 помещаю значение х1 в регистр edx.

        cmp edx, [x2]       ; если х1 < х2
        jl normalAlgo

        cmp edx, [x2]       ; если х1 = х2
        je zeroAlgo

        call negativeAlgo   ; если х1 > х2

; Алгоритм, вызываемый при обратном порядке x'ов (x1 > x2).
negativeAlgo:
        ; Обмен х местами.
        mov edx, [x1]
        xchg edx, [x2]
        mov [x1], edx
        ; Сбор первичного значения x в регистр edx.
        mov edx, [x1]
        add edx, [step]
        mov eax, edx       ; Перенос первичного значения х в eax.
        mov ebx, 0         ; Cумма площадей (в результате - интеграл).
        call mainCycle     ; Получение интеграла.

        call inverse       ; Для обратного порядка иксов необходимо поменять знак результата.

; Алгоритм, вызываемый при равности введенных х.
zeroAlgo:
        call printResultZero ; Вывод нулевого результата.

; Нормальный алгоритм, вызываемый при х1 < х2.
normalAlgo:
        ; Сбор первичного значения x в регистр edx.
        mov edx, [x1]
        add edx, [step]
        mov eax, edx       ; Перенос первичного значения х в eax.
        mov ebx, 0         ; Cумма площадей (в результате - интеграл).
        call mainCycle     ; Получение интеграла.

        call printResult   ; Выводим результат.

; Вывод результата в консоль.
printResult:
        push ebx
        push resultInfo
        call [printf]

        call finish

; Вывод нулевого результата (если х1 = х2)
printResultZero:
        push 0
        push resultInfo
        call [printf]
        call finish

; Цикл нахождения интеграла.
mainCycle:
        mov ecx, eax ; Сохранение значения eax (смысл в хранении текущей позиции).

        ; Подсчет y по формуле функции (собирается в eax).
        mov edx, eax
        imul eax, edx
        imul eax, edx      ; Возведение в куб.
        imul eax, [b]      ; Умножение на b.
        add eax, [a]       ; Сложение с a.
        mul [step]         ; Получение площади участка.

        add ebx, eax       ; Добавление площади к счетчику (собираемый интеграл).

        mov eax, ecx       ; Возвращение старого значения eax (текущая позиция).

        cmp eax, [x2]      ; Проверка на окончание цикла.
        jne continue

        ret

; Меняет знак ebx (интеграла) на противоположный.
inverse:
        mov eax, ebx       ; Сохраняем интеграл в регистре eax.

        cdq                ; Увеличиваем размерность регистра eax.
        imul eax, -1       ; Меняем знак интеграла.

        mov ebx, eax       ; Возвращаем значение интеграла в ebx.

        call printResult   ; Выводим результат.

; Алгоритм продолжения цикла.
continue:
        add eax, [step]    ; Увеличение x на шаг.
        jmp mainCycle      ; Повторный цикл.

; Алгоритм завершения работы программы.
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