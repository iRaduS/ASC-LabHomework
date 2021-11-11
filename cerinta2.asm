# solutie propusa de Vrinceanu Radu-Tudor, student @ FMI Universitatea din Bucuresti
.data
    str: .space 128
    strDelim: .asciz "%s"
    chDelim: .asciz " "
    formatPrintf: .asciz "%d\n"
    res: .space 16
    number: .space 4
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

            movl %eax, res

            pushl res
            call atoi
            popl %ebx
            
            pushl %eax

    for:    pushl $chDelim
            pushl $0
            call strtok
            popl %ebx
            popl %ebx 

            cmp $0, %eax
            je et_exit

            movl %eax, res

            pushl res
            call atoi
            popl %ebx
                
            cmp $0, %eax
            je insert_operation

            pushl %eax
            jmp for

    insert_operation:   movl res, %edi
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

    add_operation:  popl %eax
                    popl %ebx
                    add %eax, %ebx
                    pushl %ebx
                    jmp for

    sub_operation:  popl %ebx
                    popl %eax
                    sub %ebx, %eax
                    pushl %eax
                    jmp for

    mul_operation:  popl %ebx
                    popl %eax
                    mul %ebx
                    pushl %eax
                    jmp for

    div_operation:  popl %ebx
                    popl %eax
                    xorl %edx, %edx
                    div %ebx
                    pushl %eax
                    jmp for
    
    et_exit:    popl %eax
                pushl %eax
                pushl $formatPrintf
                call printf
                popl %ebx
                popl %ebx
