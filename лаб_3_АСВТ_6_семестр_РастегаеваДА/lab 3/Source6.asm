.686
.model flat, stdcall
.stack 4096

.data
    matrix  dd 35, 702, 164, 181, 242, 884, 676, 542, 501, 533, 38, 63, 198, 2, 553
            dd 961, 100, 0, 334, 636, 56, 536, 640, 33, 729, 744, 50, 366, 49, 751
            dd 346, 599, 121, 468, 355, 935, 637, 587, 781, 671, 931, 128, 659, 867, 991
            dd 556, 739, 292, 632, 859, 565, 494, 294, 193, 685, 480, 548, 437, 794, 745
            dd 499, 343, 184, 434, 732, 222, 8, 882, 809, 931, 434, 194, 119, 119, 428
            dd 540, 547, 41, 585, 726, 379, 941, 928, 709, 843, 113, 788, 316, 642, 6
            dd 229, 995, 686, 280, 88, 111, 80, 223, 351, 266, 67, 151, 232, 241, 160
            dd 292, 535, 128, 209, 33, 439, 537, 475, 538, 400, 156, 147, 378, 422, 997
            dd 488, 466, 700, 824, 989, 948, 78, 771, 884, 489, 774, 830, 519, 721, 85
            dd 221, 857, 816, 327, 983, 383, 740, 47, 384, 29, 868, 863, 258, 204, 550
            dd 723, 419, 627, 587, 823, 723, 242, 368, 242, 123, 797, 231, 31, 475, 709
            dd 915, 183, 191, 65, 562, 990, 101, 713, 738, 745, 534, 254, 120, 289, 947
            dd 332, 485, 539, 832, 724, 725, 867, 872, 835, 193, 757, 56, 785, 810, 898
            dd 367, 661, 35, 358, 477, 739, 764, 40, 544, 482, 467, 336, 829, 497, 772
            dd 905, 850, 356, 854, 682, 159, 790, 411, 270, 184, 708, 197, 526, 162, 360
    N       dd 15
    sum_of_diag dd 0
    temp_eax dd 0
    temp_edx dd 0

.code
main proc
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
    add esi, 120
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