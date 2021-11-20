# solutie propusa de Vrinceanu Radu-Tudor, student @ FMI Universitatea din Bucuresti
# x m n m*n_elemente let x (operand) operatie
.data
    str: .space 512
    a: .space 260100
    b: .space 260100
    indexVector: .space 4
    lineIndex: .space 4
    columnIndex: .space 4
    res: .space 4
    formatPrintf: .asciz "%d "
    newLine: .asciz "\n"
    m: .long 0
    n: .long 0

    chDelim: .asciz " "
    isLet: .long 0
    i: .long 0
    operand: .long 0
.text
    .global main
    main:   pushl $str
            call gets
            popl %ebx

            pushl $chDelim
            pushl $str
            call strtok
            popl %ebx
            popl %ebx

    for:    pushl $chDelim
            pushl $0
            call strtok
            popl %ebx
            popl %ebx

            cmp $0, %eax
            je et_op_exit

            movl %eax, res

            cmp $0, m
            je populate_m

            cmp $0, n
            je populate_n

            movl res, %edi
            xorl %ecx, %ecx
            movb (%edi, %ecx, 1), %al

            cmp $108, %al
            je set_is_let

            movl isLet, %eax
            cmp $0, %eax
            je insert_element

            cmp $1, %eax
            je verify_operation

    verify_operation:   pushl res
                        call atoi
                        popl %ebx

                        cmp $0, %eax
                        je operation # operatie, variabila

                        movl %eax, operand
                        jmp for

    operation:  pushl res
                call strlen
                popl %ebx

                cmp $1, %eax
                jne what_operation

                jmp for

    what_operation:     movl res, %edi
                        movl a, %esi
                        xorl %ecx, %ecx
                        movb (%edi, %ecx, 1), %al

                        cmp $97, %al
                        je add_operation

                        cmp $115, %al
                        je sub_operation

                        cmp $109, %al
                        je mul_operation

                        cmp $100, %al
                        je div_operation

                        cmp $114, %al
                        je rot_operation

    rot_operation:  movl $0, lineIndex
                    movl $0, indexVector
                    lea a, %edi # vector
                    lea b, %esi # matrice
                    for_lines:  movl lineIndex, %ecx
                                cmp %ecx, m
                                je rotate_matrix

                                movl $0, columnIndex
                                for_columns:    movl columnIndex, %ecx
                                                cmp %ecx, n
                                                je cont

                                                movl indexVector, %ebx
                                                movl lineIndex, %eax
                                                movl $0, %edx
                                                mull n
                                                addl columnIndex, %eax

                                                movl (%edi, %ebx, 4), %edx
                                                movl %edx, (%esi, %eax, 4)

                                                incl indexVector
                                                incl columnIndex
                                                jmp for_columns
                    cont:   incl lineIndex
                            jmp for_lines

    rotate_matrix:  movl $0, lineIndex
                    lea a, %edi # matrice intoarsa
                    lea b, %esi # matrice
                    for_rotate_lines:  movl lineIndex, %ecx
                                cmp %ecx, m
                                je show_result

                                movl $0, columnIndex
                                for_rotate_columns:     movl columnIndex, %ecx
                                                        cmp %ecx, n
                                                        je rotate_cont
                                                        
                                                        movl lineIndex, %eax
                                                        movl $0, %edx
                                                        mull n
                                                        addl columnIndex, %eax

                                                        movl (%esi, %eax, 4), %ebx

                                                        movl columnIndex, %eax
                                                        movl $0, %edx
                                                        mull m
                                                        addl m, %eax
                                                        subl lineIndex, %eax
                                                        subl $1, %eax

                                                        movl %ebx, (%edi, %eax, 4)

                                                        incl columnIndex
                                                        jmp for_rotate_columns

                    rotate_cont:    incl lineIndex
                                    jmp for_rotate_lines

    show_result:    pushl n
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx

                    pushl m
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx
                    
                    lea a, %edi
                    movl $0, lineIndex
                    for_show_lines: movl lineIndex, %ecx
                                    cmp %ecx, n
                                    je et_op_exit

                                    movl $0, columnIndex
                                    for_show_columns:   movl columnIndex, %ecx
                                                        cmp %ecx, m
                                                        je show_cont

                                                        movl lineIndex, %eax
                                                        movl $0, %edx
                                                        mull m
                                                        addl columnIndex, %eax

                                                        movl (%edi, %eax, 4), %ebx

                                                        pushl %ebx
                                                        pushl $formatPrintf
                                                        call printf
                                                        popl %ebx
                                                        popl %ebx

                                                        pushl $0
                                                        call fflush
                                                        popl %ebx

                                                        incl columnIndex
                                                        jmp for_show_columns

                    show_cont:  incl lineIndex
                                jmp for_show_lines


    add_operation:  cmp indexVector, %ecx
                    je prepare_show

                    lea a, %esi
                    movl (%esi, %ecx, 4), %eax
                    addl operand, %eax
                    movl %eax, (%esi, %ecx, 4)

                    incl %ecx
                    jmp add_operation

    sub_operation:  cmp indexVector, %ecx
                    je prepare_show

                    lea a, %esi
                    movl (%esi, %ecx, 4), %eax
                    subl operand, %eax
                    movl %eax, (%esi, %ecx, 4)

                    incl %ecx
                    jmp sub_operation

    div_operation:  cmp indexVector, %ecx
                    je prepare_show

                    lea a, %esi
                    movl (%esi, %ecx, 4), %eax
                    movl $0, %edx
                    cdq
                    idivl operand
                    movl %eax, (%esi, %ecx, 4)

                    incl %ecx
                    jmp div_operation

    mul_operation:  cmp indexVector, %ecx
                    je prepare_show

                    lea a, %esi
                    movl (%esi, %ecx, 4), %eax
                    movl $0, %edx
                    imull operand
                    movl %eax, (%esi, %ecx, 4)

                    incl %ecx
                    jmp mul_operation

    prepare_show:   pushl m
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx

                    pushl n
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx

                    pushl $0
                    call fflush
                    popl %ebx

                    xorl %ecx, %ecx

    show_elements:  cmp indexVector, %ecx
                    je et_op_exit

                    movl (%esi, %ecx, 4), %eax

                    pushl %ecx
                    pushl %eax
                    pushl $formatPrintf
                    call printf
                    popl %ebx
                    popl %ebx
                    popl %ecx

                    pushl %ecx
                    pushl $0
                    call fflush
                    popl %ebx
                    popl %ecx

                    incl %ecx 
                    jmp show_elements

    insert_element:     lea a, %esi

                        pushl res
                        call atoi
                        popl %ebx

                        movl i, %ecx
                        movl %eax, (%esi, %ecx, 4)
                        incl i

                        jmp for


    set_is_let:     movl $1, %eax
                    movl %eax, isLet
                    jmp for

    populate_m:     pushl res
                    call atoi
                    popl %ebx

                    movl %eax, m
                    jmp for

    populate_n:     pushl res
                    call atoi
                    popl %ebx

                    movl %eax, n
                    mull m
                    movl %eax, indexVector
                    jmp for

    et_op_exit: movl $4, %eax
                movl $1, %ebx
                mov $newLine, %ecx
                movl $2, %edx
                int $0x80
                movl $1, %eax
                xorl %ebx, %ebx
                int $0x80
