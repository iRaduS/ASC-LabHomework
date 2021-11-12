# solutie propusa de Vrinceanu Radu-Tudor, student @ FMI Universitatea din Bucuresti
.data
	str: .space 128
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	res: .space 12 
	vars: .space 128
	aux: .space 12
.text
    .global main

    main:   movl $vars, %edi
            xorl %ecx, %ecx
            jmp reset

    begin:  pushl $str
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
            cmp $0, %eax
            je check_var

    reset:  cmp $26, %ecx
            je begin
            movl $256, (%edi, %ecx, 4)
            incl %ecx
            jmp reset
	
    et_for: pushl $chDelim
            pushl $0
            call strtok
            popl %ebx
            popl %ebx

            cmp $0, %eax
            je exit
            
            movl %eax, res

            movl res, %esi
            xorl %ecx, %ecx
            movb (%esi, %ecx, 1), %al

            cmp $48, %al
            je add_zero_stack

            pushl res
            call atoi
            popl %ebx

            cmp $0, %eax
            je check_var            
            
            pushl %eax
            jmp et_for	

    check_var:  pushl res
                call strlen
                popl %ebx

                cmp $1, %eax
                jne insert_operation
                
                xorl %ecx, %ecx
                movl res, %esi
                movb (%esi, %ecx, 1), %al
                movb %al, aux

                movl aux, %ecx
                sub $97, %ecx
                movl (%edi, %ecx, 4), %eax
                
                cmp $256, %eax
                jne add_aux_stack

                push aux
                jmp et_for

    add_zero_stack:     pushl $0
                        jmp et_for

    add_aux_stack:	movl %eax, aux
                    pushl aux
                    jmp et_for

    insert_operation:   movl res, %esi
                        xorl %ecx, %ecx
                        movb (%esi, %ecx, 1), %al

                        cmp $97, %al
                        je add_operation

                        cmp $115, %al
                        je sub_operation

                        cmp $109, %al
                        je mul_operation
                        
                        cmp $100, %al
                        je div_operation

                        cmp $108, %al
                        je let_operation

    add_operation:  popl %eax
                    popl %ebx
                    add %eax, %ebx
                    pushl %ebx
                    jmp et_for

    let_operation:	popl %eax
                    popl %ebx
                    sub $97, %ebx
                    movl %eax, (%edi, %ebx, 4)
                    jmp et_for

    sub_operation:  popl %ebx
                    popl %eax
                    sub %ebx, %eax
                    pushl %eax
                    jmp et_for

    mul_operation:  popl %ebx
                    popl %eax
                    mul %ebx
                    pushl %eax
                    jmp et_for

    div_operation:  popl %ebx
                    popl %eax
                    xorl %edx, %edx
                    div %ebx
                    pushl %eax
                    jmp et_for


    exit:   popl %eax
			pushl %eax
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
            movl $1, %eax
            xorl %ebx, %ebx
            int $0x80
