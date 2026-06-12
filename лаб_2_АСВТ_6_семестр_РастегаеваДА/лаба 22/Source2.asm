.386
.model flat, stdcall
.stack 4096

.data
    X dw 0B8F7h
    Y dw 3DA6h
    Z dw 911Ch
    Q dw 6633h
    
    X_new dw ?
    Y_new dw ?
    Z_new dw ?
    Q_new dw ?
    
    M dw ?
    R dw ?

.code
main proc
    lea esi, X
    lea edi, X_new
    mov ecx, 4
    
cycle:
    mov ax, [esi]
    mov bl, al
    neg bl
    mov al, bl
    mov [edi], ax
    add esi, 2
    add edi, 2
    loop cycle
    
    mov ax, Y_new
    and ax, X_new
    mov bx, ax
    
    mov ax, Z_new
    or  ax, Q_new
    
    add bx, ax
    mov M, bx
    
    mov ax, M
    and ax, 000Fh
    cmp ax, 4
    jl  call_proc1
    jmp call_proc2
    
call_proc1:
    call proc1
    jmp check_R
    
call_proc2:
    call proc2
    
check_R:
    mov ax, R
    cmp ax, 0
    jl  to_ADR1
    jmp to_ADR2
    
to_ADR1:
    jmp ADR1
    
to_ADR2:
    jmp ADR2

proc1 proc
    mov ax, M
    add ax, Y_new
    mov R, ax
    ret
proc1 endp

proc2 proc
    mov ax, M
    sub ax, 999
    sbb ax, 0
    mov R, ax
    ret
proc2 endp

ADR1:
    mov ax, R
    or  ax, X_new
    mov R, ax
    jmp exit
    
ADR2:
    mov ax, R
    or  ax, 1011b
    mov R, ax
    
exit:
    ret

main endp
end main