.686
.model flat, stdcall
.stack 16384

ExitProcess PROTO :DWORD
GetProcessHeap PROTO
HeapAlloc PROTO :DWORD, :DWORD, :DWORD
HeapFree PROTO :DWORD, :DWORD, :DWORD

.data
    matrix      dd 0            ; указатель на матрицу в куче
    N           dd 1000
    matrix_size dd 4000000      ; 1000*1000*4 байт
    
    sum_of_diag dd 0
    temp_eax    dd 0
    temp_edx    dd 0
    heap_handle dd 0

.code
main proc
    ; ============ 1. ¬ыделение пам€ти под матрицу ============
    call GetProcessHeap
    mov heap_handle, eax
    
    ; HeapAlloc(hHeap, dwFlags, dwBytes)
    push matrix_size            ; dwBytes = 4000000
    push 0                      ; dwFlags = 0 (не обнул€ем дл€ скорости)
    push heap_handle            ; hHeap
    call HeapAlloc
    
    cmp eax, 0
    je end_program              ; если выделение не удалось
    
    mov matrix, eax             ; matrix = указатель на выделенную пам€ть
    
    ; ============ 2. «аполнение матрицы числами 1..1000000 ============
    mov ecx, 1000000            ; 1000*1000 элементов
    mov esi, matrix             ; esi = начало матрицы
    mov eax, 1                  ; начальное значение
    
fill_loop:
    mov [esi], eax              ; записываем число
    add esi, 4                  ; следующий элемент
    inc eax                     ; следующее число
    dec ecx
    jnz fill_loop
   
    
    finit                  

    mov ecx, N             
    mov esi, offset matrix 
    mov ebx, N
    inc ebx                

    fldz                   

sum_loop:
    fild dword ptr [esi]   
    faddp st(1), st(0)     
    lea esi, [esi + ebx*4] 
    loop sum_loop

    fistp sum_of_diag      
    
    mov eax, sum_of_diag   
    mov temp_eax, eax      

    xor edx, edx           
    mov ecx, 2             
    div ecx                
    mov temp_edx, edx      
    cmp edx, 0
    je swap_diagonals      

    
    mov eax, temp_eax      
    xor edx, edx           
    mov ecx, 5
    div ecx
    mov temp_edx, edx
    cmp edx, 0
    je swap_diagonals      

    jmp end_program        

   
swap_diagonals:
    mov ecx, N             
    mov esi, offset matrix 
    mov edi, offset matrix 
    mov ebx, N
    lea edi, [edi + ebx*4 - 4] 

swap_loop:
    
    mov eax, [esi]        
    mov edx, [edi]         
    mov [esi], edx         
    mov [edi], eax         

    
    push ebx               
    mov ebx, N
    inc ebx                
    lea esi, [esi + ebx*4] 
    dec ebx
    dec ebx                
    lea edi, [edi + ebx*4] 
    pop ebx                

    loop swap_loop
    
    finit
    mov esi, offset matrix
    add esi, 2000000            
    mov ecx, 8
load_result:
    fild dword ptr [esi]
    add esi, 4
    loop load_result
    

end_program:
    
    xor eax, eax           
    ret                    
main endp
end main