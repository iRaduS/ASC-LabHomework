.data
	n: .space 4
	m: .space 4
	size: .space 4 # 3n
	readable: .space 4
	v: .space 512
	fr: .space 512
	filled: .space 512
	first: .space 4
	start: .space 4
	stop: .space 4
	subTriple: .space 4 # 3n - 1

	cstThree: .long 3
	formatTwoScanf: .asciz "%d %d"
	formatScanf: .asciz "%d"
	formatPrintf: .asciz "%d "
	formatNewLn: .asciz "\n"
	formatNoSolution: .asciz "-1\n"
.text
.global main
	Ok: pushl %ebp
		movl %esp, %ebp

		movl 12(%ebp), %eax # k
		subl m, %eax

		cmp $0, %eax
		jl Ok_set_start_zero

		movl %eax, start
		###################
		movl 12(%ebp), %eax
		addl m, %eax

		cmp size, %eax
		jge Ok_set_stop_sub

		movl %eax, stop

	Ok_continue: movl start, %ecx
				
	Ok_For: cmp stop, %ecx
			jg Ok_For_Continue

			movl 8(%ebp), %eax
			lea v, %esi

			cmp %eax, (%esi, %ecx, 4)
			je verifiy_second_condition

			OK_For_Increment: incl %ecx
			jmp Ok_For

	verifiy_second_condition:	movl 12(%ebp), %eax
								cmp %eax, %ecx
								je OK_For_Increment

								movl $0, %edx
								popl %ebp
								ret

	Ok_For_Continue:	movl 8(%ebp), %eax
						lea fr, %edi
						
						cmp $3, (%edi, %eax, 4)
						jge Ok_Return_False

						movl $1, %edx
						popl %ebp
						ret

	Ok_Return_False:	movl $0, %edx
						popl %ebp
						ret

	Ok_set_start_zero: 	movl $0, start
						jmp Ok_continue

	Ok_set_stop_sub: 	movl subTriple, %eax
						movl %eax, stop
						jmp Ok_continue
		

	Show:	movl $1, first
			xorl %ecx, %ecx

	Show_For: 	cmp size, %ecx
				je Show_End

				lea v, %esi

				pushl %ebx
				pushl %eax
				pushl %ecx
				pushl %edx
				pushl (%esi, %ecx, 4)
				pushl $formatPrintf
				call printf
				popl %ebx
				popl %ebx
				popl %edx
				popl %ecx
				popl %eax
				popl %ebx

				incl %ecx
				jmp Show_For

	Show_End: 	pushl %ebx
				pushl %eax
				pushl %ecx
				pushl %edx
				pushl $formatNewLn
				call puts
				popl %ebx
				popl %edx
				popl %ecx
				popl %eax
				popl %ebx
				ret

	Backtrack:	pushl %ebp
				movl %esp, %ebp

				cmp $0, first
				jne Backtrack_End

				movl 8(%ebp), %eax
				cmp size, %eax
				je Backtrack_Show

				movl 8(%ebp), %eax
				lea filled, %edi
				movl (%edi, %eax, 4), %ebx

				cmp $0, %ebx
				jne Backtrack_Next

				movl $1, %ecx

	Backtrack_For:	cmp n, %ecx
					jg Backtrack_End

					movl 8(%ebp), %eax

					pushl %eax # k
					pushl %ecx # i
					call Ok
					popl %ecx
					popl %eax

					cmp $0, %edx
					je Backtrack_For_Inc
					
					lea v, %esi
					lea fr, %edi
					movl 8(%ebp), %eax
					movl %ecx, (%esi, %eax, 4)

					movl (%edi, %ecx, 4), %ebx
					incl %ebx
					movl %ebx, (%edi, %ecx, 4)

					pushl %ecx
					incl %eax
					pushl %eax
					call Backtrack
					popl %eax
					popl %ecx

					lea v, %esi
					lea fr, %edi
					movl 8(%ebp), %eax

					movl (%edi, %ecx, 4), %ebx
					decl %ebx
					movl %ebx, (%edi, %ecx, 4)

					movl $0, (%esi, %eax, 4)

					Backtrack_For_Inc: incl %ecx
					jmp Backtrack_For

	Backtrack_Next: movl 8(%ebp), %eax
					pushl %ecx
					incl %eax
					pushl %eax
					call Backtrack
					popl %eax
					popl %ecx

					popl %ebp
					ret

	Backtrack_Show:	pushl %ecx
					pushl %eax
					call Show
					popl %eax
					popl %ecx

					popl %ebp
					ret

	Backtrack_End:	popl %ebp
					ret

	main: 	pushl $m
			pushl $n
			pushl $formatTwoScanf
			call scanf
			popl %ebx
			popl %ebx
			popl %ebx

			# Calculeaza 3n si 3n - 1
			xorl %edx, %edx
			movl n, %eax
			mull cstThree
			movl %eax, size
			subl $1, %eax
			movl %eax, subTriple

			xorl %ecx, %ecx

	read_elements:	cmp size, %ecx
					je continue_main
	
					pushl %ecx
					pushl $readable
					pushl $formatScanf
					call scanf
					popl %ebx
					popl %ebx
					popl %ecx
					
					lea v, %esi
					lea fr, %edi

					movl readable, %ebx # ebx <- v[i]
					movl %ebx, (%esi, %ecx, 4)
					
					movl (%edi, %ebx, 4), %eax
					incl %eax
					movl %eax, (%edi, %ebx, 4)

					pushl %edi
					lea filled, %edi
					
					cmp $0, %ebx
					je pre_next_element

					movl $1, (%edi, %ecx, 4)
					popl %edi

					next_element: incl %ecx
					jmp read_elements
					
	pre_next_element: 	popl %edi
						jmp next_element
	
	continue_main:	pushl $0
					call Backtrack
					popl %ebx

					cmp $0, first
					jne exit

					pushl $formatNoSolution
					call puts
					popl %ebx

	exit: 	movl $1, %eax
			xorl %ebx, %ebx
			int $0x80
