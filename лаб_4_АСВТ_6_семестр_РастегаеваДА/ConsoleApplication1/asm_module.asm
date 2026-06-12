.586
.MODEL FLAT, C
.DATA
i_local DWORD 0
x_local QWORD 0.0
step_val QWORD 0.1
.CODE
EXTERN CalcFunc:near
PUBLIC CalcTable

CalcTable PROC
push ebp
mov ebp, esp
mov i_local, 0
mov edx, dword ptr [ebp+12]

@@for_loop:
cmp i_local, edx
jge @@end_for

fild i_local
fld qword ptr step_val
fmulp st(1), st(0)
fstp x_local

push dword ptr [x_local + 4]
push dword ptr [x_local]

call CalcFunc

mov esi, dword ptr [ebp+8]
mov eax, i_local
shl eax, 3
add esi, eax
fstp qword ptr [esi]

add esp, 8
inc i_local
jmp @@for_loop

@@end_for:
mov esp, ebp
pop ebp
ret
CalcTable ENDP
END