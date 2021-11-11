# solutie propusa de Vrinceanu Radu-Tudor, student @ FMI Universitatea din Bucuresti
# Fiecare codificare implica un numar de 12 biti => 3 cifre in baza hexazecimala
# Astfel, putem delimita cateva conditii si anume:
#
# Sirul de hexazecimal va fi intotdeauna divizibil cu 3 deci putem delimita daca codificarea reprezinta un numar intreg
# (pozitiv / negativ), operatie sau variabila
#
# Datorita reprezentarii unice operatia are ca prefix (primii 4 biti) 1 10 0... (conform tabelului)
# putem conchide la faptul ca daca un grup de 3 cifre hexazecimale va incepe cu prima cifra "C" atunci este o instructiune
#
# Datorita reprezentarii unice variabila are ca prefix (primii 4 biti) 1 01 0... (conform tabelului si INDICATIEI ca se vor
# folosi doar litere mici ale alfabetului pentru reprezentarea acestora) putem deduce faptul ca un grup de 3 cifre hexazecimale va incepe cu "A"
# atunci este o variabila
#
# Mergand pe acelasi principiu, numerele pozitive au ca prefix (primii 4 biti) 1 00 0... deci un grup de 3 cifre hexazeciamle care incepe cu "8"
# e un numar pozitiv, idem pentru numerele negative au ca prefix (primii 4 biti) 1 00 1... deci un grup de 3 cifre care incepe cu cifra "9" e un numar negative
#
# Spre exemplu: x 1 let x -14 div <=>(codificare hexa) A78 801 C00 A78 90E C04, ceea ce dovedeste adevarata ipoteza de mai sus 
# 
# ================================================
# 
# int number;
# char code[256], fragment[256], result[512] = "";
# scanf("%s", code);

# for (int ecx = 0; ecx < strlen(code); ecx += 3) {
#     fragment[0] = '\0';
#     if (code[ecx] == 'A') {
#         strncat(fragment, code + ecx + 1, 2);
#         sscanf(fragment, "%2x", &number);
#         sprintf(fragment, "%c ", number);
#         strcat(result, fragment);
#     } else if (code[ecx] == 'C') {
#         strncat(fragment, code + ecx + 1, 2);
#         sscanf(fragment, "%2x", &number);
        
#         if (number == 0) {
#             strcat(result, "let ");
#         } else if (number == 1) {
#             strcat(result, "add ");
#         } else if (number == 2) {
#             strcat(result, "sub ");
#         } else if (number == 3) {
#             strcat(result, "mul ");
#         } else if (number == 4) {
#             strcat(result, "div ");
#         }
#     } else if (code[ecx] == '8') {
#         strncat(fragment, code + ecx + 1, 2);
#         sscanf(fragment, "%2x", &number);
#         sprintf(fragment, "%d ", number);
    
#         strcat(result, fragment);
#     } else if (code[ecx] == '9') {
#         strncat(fragment, code + ecx + 1, 2);
#         sscanf(fragment, "%2x", &number);
#         sprintf(fragment, "-%d ", number);
    
#         strcat(result, fragment);
#     }
# }
# strncpy(result, result, strlen(result) - 1);
# printf("%s", result);
# return 0;
# ================================================


.data 
    charDelim: .asciz "%s "
    hexaDelim: .asciz "%2x"
    posDecDelim: .asciz "%d "
    negDecDelim: .asciz "-%d "
    strDelim: .asciz "%s"
    printDelim: .asciz "%s\n"
    code: .space 128
    fragment: .space 64
    result: .space 512
    show_result: .space 512
    length: .space 4
    number: .long 0
    auxiliar: .space 4
    strNumber: .long 2
    letOp: .asciz "let "
    addOp: .asciz "add "
    subOp: .asciz "sub "
    mulOp: .asciz "mul "
    divOp: .asciz "div "

.text 
    .global main
    main:   pushl $code
            pushl $strDelim
            call scanf
            popl %ebx
            popl %ebx

            movl $fragment, %esi
            movl $code, %edi
            xorl %ecx, %ecx
    
    for:    movb (%edi, %ecx, 1), %al
            movb %al, auxiliar
            movl %ecx, strNumber
            cmp $0, auxiliar
            je et_exit

            pushl %ebx
            pushl %ecx
            xorl %ebx, %ebx
            movl strNumber, %ecx
            incl %ecx
            movb (%edi, %ecx, 1), %ah
            movb %ah, (%esi, %ebx, 1)
            incl %ecx
            incl %ebx
            movb (%edi, %ecx, 1), %ah
            movb %ah, (%esi, %ebx, 1)
            popl %ecx
            popl %ebx

            cmp $67, auxiliar
            je add_operation

            cmp $65, auxiliar
            je add_variable

            cmp $56, auxiliar
            je add_pos_number

            cmp $57, auxiliar
            je add_neg_number

    continue:   movl strNumber, %ecx
                incl %ecx
                incl %ecx
                incl %ecx
                jmp for
    
    add_operation:  pushl $number
                    pushl $hexaDelim
                    pushl $fragment
                    call sscanf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    cmp $0, number
                    je concat_let
                    cmp $1, number
                    je concat_add
                    cmp $2, number
                    je concat_sub
                    cmp $3, number
                    je concat_mul
                    cmp $4, number
                    je concat_div
    
    concat_let:     pushl $letOp
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    concat_add:     pushl $addOp
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    concat_sub:     pushl $subOp
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    concat_mul:     pushl $mulOp
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    concat_div:     pushl $divOp
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    add_variable:   pushl $number
                    pushl $hexaDelim
                    pushl $fragment
                    call sscanf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl $number
                    pushl $charDelim
                    pushl $fragment
                    call sprintf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl $fragment
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    add_pos_number: pushl $number
                    pushl $hexaDelim
                    pushl $fragment
                    call sscanf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl number
                    pushl $posDecDelim
                    pushl $fragment
                    call sprintf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl $fragment
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    add_neg_number: pushl $number
                    pushl $hexaDelim
                    pushl $fragment
                    call sscanf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl number
                    pushl $negDecDelim
                    pushl $fragment
                    call sprintf
                    popl %ebx
                    popl %ebx
                    popl %ebx
                    pushl $fragment
                    pushl $result
                    call strcat
                    popl %ebx
                    popl %ebx
                    jmp continue

    et_exit:    pushl $result
                call strlen
                popl %ebx
                movl %eax, length
                subl $1, length
                movl length, %ecx
                movl $result, %esi
                movb $0, %dl
                movb %dl, (%esi, %ecx, 1)
                pushl $result
                pushl $printDelim
                call printf
                popl %ebx
                popl %ebx
                movl $1, %eax
                xorl %ebx, %ebx
                int $0x80
