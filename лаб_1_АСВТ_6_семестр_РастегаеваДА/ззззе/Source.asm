.686
.model flat, stdcall
.stack 100h

.data
   
    X dw 15
    Y dw -10          ; Отрицательное число в дополнительном коде
    Z dw 65

    ; Переменные для результатов
    X_prime dw ?      ; Результат RCR для X
    Y_prime dw ?      ; Результат RCR для Y
    T1 dw ?           ; Z + X' * Y'
    T2 dw ?           ; X' + Y'
    M dw ?            ; Финальный результат (T1 xor T2)

    ; Для хранения информации о переполнении
    overflow_flag dw 0

.code
; Прототип для выхода
ExitProcess PROTO stdcall :DWORD

Start:

    ; Вычисление X' (RCR X, 5) 
    mov ax, [X]       ; AX = X
    mov cl, 5         ; Счетчик сдвигов = 5
    
    clc               ; CF = 0
    
    rcr ax, cl        ; Циклический сдвиг вправо через перенос на 5 бит
    mov [X_prime], ax ; Сохраняем X'

    ; Вычисление Y' (RCR Y, 5) 
    mov ax, [Y]       ; AX = Y
 
    clc               
    rcr ax, cl        ; Сдвигаем Y (уже отрицательное число!)
    mov [Y_prime], ax ; Сохраняем Y'

    ;  Вычисление T2 = X' + Y' 
    mov ax, [X_prime]
    add ax, [Y_prime] ; AX = X' + Y'
    mov [T2], ax      ; Сохраняем T2
    

    ;  Вычисление X' * Y' (со знаком) 
    mov ax, [X_prime]
    imul [Y_prime]    
    
    
    mov bx, ax        ; BX = X' * Y' (младшая часть)

    ; Вычисление T1 = Z + (X' * Y') 
    mov ax, [Z]
    add ax, bx        ; AX = Z + (X' * Y')
    mov [T1], ax      ; Сохраняем T1

    ; Вычисление M = T1 xor T2 
    mov ax, [T1]
    xor ax, [T2]      ; AX = T1 xor T2
    mov [M], ax       

    
    ; сохраним состояние флагов после вычисления T1 
    pushf              ; кладем флаги в стек
    pop ax             ; выгружаем в ax
    and ax, 0800h      ; маска для флага OF (0800h = 1000 0000 0000b)
    mov [overflow_flag], ax ; Если не 0, значит было переполнение.
    
    invoke ExitProcess, 0

End Start