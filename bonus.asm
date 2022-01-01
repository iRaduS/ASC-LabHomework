# Solutie propusa de Vrinceanu Radu-Tudor, student @ FMI Universitatea din Bucuresti
.data
    lineIndex: .space 4
    columnIndex: .space 4
    ok_lineIndex: .space 4
    ok_columnIndex: .space 4
    ok_startRow: .space 4
    ok_startCol: .space 4
    sudokuTable: .space 400
    read: .space 4
    fileAddress: .space 4
    x: .space 4

    found: .long 0
    filled: .long 0
    total: .long 81
    n: .long 9
    small_n: .long 3
    formatPrintf: .asciz "%d "
    newLine: .asciz "\n"
    cantSol: .asciz "-1\n"
    formatScanf: .asciz "%d"
    fileType: .asciz "r"
    fileName: .asciz "bonus.txt"
.text
.global main

# MODIFICA %EAX, %ECX
OK: pushl %ebp 
    movl %esp, %ebp
    
    xorl %ecx, %ecx
    OK_row_check:   cmp n, %ecx
                    je OK_revenire
                    
                    lea sudokuTable, %edi

                    movl 8(%ebp), %eax
                    xorl %edx, %edx
                    mull n
                    addl %ecx, %eax
                    movl (%edi, %eax, 4), %eax

                    cmp %eax, 16(%ebp)
                    je OK_ret_false

                    incl %ecx
                    jmp OK_row_check

    OK_revenire: xorl %ecx, %ecx
    OK_col_check:   cmp n, %ecx
                    je OK_continue
                    
                    lea sudokuTable, %edi

                    movl %ecx, %eax
                    xorl %edx, %edx
                    mull n
                    addl 12(%ebp), %eax
                    movl (%edi, %eax, 4), %eax

                    cmp %eax, 16(%ebp)
                    je OK_ret_false

                    incl %ecx
                    jmp OK_col_check

    OK_continue: 
                xorl %edx, %edx
                movl 8(%ebp), %eax
                divl small_n
                movl 8(%ebp), %eax
                subl %edx, %eax
                movl %eax, ok_startRow

                xorl %edx, %edx
                movl 12(%ebp), %eax
                divl small_n
                movl 12(%ebp), %eax
                subl %edx, %eax
                movl %eax, ok_startCol

                movl $0, ok_lineIndex
                for_OK_lines:   movl ok_lineIndex, %ecx
                                cmp small_n, %ecx
                                je OK_ret_true

                                movl $0, ok_columnIndex
                                for_OK_columns: movl ok_columnIndex, %ecx
                                                cmp small_n, %ecx
                                                je for_OK_continue

                                                lea sudokuTable, %edi

                                                movl ok_lineIndex, %eax
                                                addl ok_startRow, %eax
                                                xorl %edx, %edx
                                                mull n
                                                addl ok_columnIndex, %eax
                                                addl ok_startCol, %eax
                                                movl (%edi, %eax, 4), %edx
                                                
                                                cmp %edx, 16(%ebp)
                                                je OK_ret_false

                                                incl ok_columnIndex
                                                jmp for_OK_columns

                for_OK_continue:    incl ok_lineIndex
                                    jmp for_OK_lines

OK_ret_false:
    movl $0, %edx
    jmp OK_exit

OK_ret_true:
    movl $1, %edx
    jmp OK_exit

OK_exit: popl %ebp
         ret

Backtracking:
    pushl %ebp
    movl %esp, %ebp

    cmp $1, found
    je Backtracking_exit

    cmp $81, filled
    je Backtracking_show

    movl 12(%ebp), %eax
    cmp n, %eax
    je Backtracking_indices

Backtracking_continue:
    lea sudokuTable, %edi
    
    xorl %edx, %edx
    movl 8(%ebp), %eax
    mull n
    addl 12(%ebp), %eax
    movl (%edi, %eax, 4), %edx

    cmp $0, %edx
    jg Backtracking_next

    movl $1, %ecx
    Backtracking_for:   cmp n, %ecx
                        jg Backtracking_exit

                        movl 12(%ebp), %eax
                        movl 8(%ebp), %ebx

                        pushl %ecx #num
                        pushl %eax #col
                        pushl %ebx #row
                        call OK
                        popl %ebx
                        popl %eax
                        popl %ecx
                        
                        cmp $0, %edx
                        je Backtracking_for_inc
                        
                        incl filled

                        lea sudokuTable, %edi
                        movl 8(%ebp), %eax
                        xorl %edx, %edx
                        mull n
                        addl 12(%ebp), %eax

                        movl %ecx, (%edi, %eax, 4)

                        movl 12(%ebp), %eax
                        movl 8(%ebp), %ebx
                        incl %eax
                        pushl %ecx
                        pushl %eax
                        pushl %ebx
                        call Backtracking
                        popl %ebx
                        popl %ebx
                        popl %ecx
                        
                        lea sudokuTable, %edi
                        movl 8(%ebp), %eax
                        xorl %edx, %edx
                        mull n
                        addl 12(%ebp), %eax

                        movl $0, (%edi, %eax, 4)

                        decl filled

                        Backtracking_for_inc: incl %ecx
                        jmp Backtracking_for

Backtracking_next:
    movl 12(%ebp), %eax
    movl 8(%ebp), %ebx
    incl %eax
    pushl %ecx
    pushl %eax
    pushl %ebx
    call Backtracking
    popl %ebx
    popl %ebx
    popl %ecx

    jmp Backtracking_exit

Backtracking_indices:
    movl $0, 12(%ebp)
    incl 8(%ebp)
    jmp Backtracking_continue

Backtracking_show:
    call print
    jmp Backtracking_exit

Backtracking_exit:
    popl %ebp
    ret

# MODIFICA DOAR %ECX, %EDX, %EAX, %EBX, %EDI
print:
    movl $1, found
    movl $0, lineIndex
    for_print_lines:  movl lineIndex, %ecx
                cmp n, %ecx
                je continue_print
                
                movl $0, columnIndex
                for_print_columns:  movl columnIndex, %ecx
                                cmp n, %ecx
                                je print_continue_for

                                lea sudokuTable, %edi

                                movl lineIndex, %eax
                                xorl %edx, %edx
                                mull n
                                addl columnIndex, %eax
                                
                                pushl %ecx
                                pushl (%edi, %eax, 4)
                                pushl $formatPrintf
                                call printf
                                popl %ebx
                                popl %ebx
                                popl %ecx

                                incl columnIndex
                                jmp for_print_columns
                
    print_continue_for: pushl %ecx
                        pushl $newLine
                        call puts
                        popl %ebx
                        popl %ecx

                        incl lineIndex
                        jmp for_print_lines

    continue_print: ret

main:
    pushl $fileType
    pushl $fileName
    call fopen
    popl %ebx
    popl %ebx

    movl %eax, fileAddress

    movl $0, lineIndex
    for_lines:  movl lineIndex, %ecx
                cmp n, %ecx
                je continue_main
                
                movl $0, columnIndex
                for_columns:    movl columnIndex, %ecx
                                cmp n, %ecx
                                je continue_for

                                pushl %ecx
                                pushl $read
                                pushl $formatScanf
                                pushl fileAddress
                                call fscanf
                                popl %ebx
                                popl %ebx
                                popl %ebx
                                popl %ecx
                                
                                lea sudokuTable, %edi

                                movl lineIndex, %eax
                                xorl %edx, %edx
                                mull n
                                addl columnIndex, %eax

                                movl read, %edx
                                movl %edx, (%edi, %eax, 4)

                                cmp $0, %edx
                                je increment_for
                                
                                incl filled

                                increment_for: incl columnIndex
                                jmp for_columns
                
    continue_for:   incl lineIndex
                    jmp for_lines

    continue_main:  pushl $0 # 12(%ebp), col
                    pushl $0 # 8(%ebp), row
                    call Backtracking
                    popl %ebx
                    popl %ebx

                    cmp $0, found
                    jne exit

                    pushl $cantSol
                    call puts
                    popl %ebx

    exit:   movl $1, %eax
            xorl %ebx, %ebx
            int $0x80
