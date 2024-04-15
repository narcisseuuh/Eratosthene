section .text
    default rel
    global main
    extern printf

gen_list:
; Shoud do : push on the stack numbers from 2 to n
    pop rcx ; saving rip at each step
    push rdi
    push rcx ; putting it back
    sub rdi, 1
    cmp rdi, 1 
    jne gen_list
    ret





find_pivot:
; Shoud do : returning in rax new pivot (stored in rdi at call : precedent_pivot + 1)
    pop rcx  ; saving eip
    jmp pivot_forreal_nocap
pivot_forreal_nocap:
    mov rax, rsp
    add rax, rdi
    sub rax, 2 ; we do these maths to attain list[rdi] due to the placement we chose on the stack
    mov rbx, qword [rax] ; rax := rsp + rdi - 2, and rbx := [rsp + rdi - 2]
    add rdi, 1
    cmp rbx, 0 ; is it a cleared value or a potential new pivot ?
    je pivot_forreal_nocap
    jmp end_pivot
end_pivot:
    push rcx ; putting it back
    ret      ; returning





modulo:
; should return rax := rdi % rsi
    mov rax, rdi
    jmp modulo_loop
modulo_loop:
    sub rax, rsi
    cmp rax, rsi
    jle modulo_loop
    ret


sorting:
; Shoud do : deleting each element divisible by current pivot
    pop rcx  ; saving eip
    mov r14, rdi ; saving our pivot in r14
    mov rbx, rdi
    sub rbx, 2 ; rbx := rdi - 2, beginning of our loop (we will sort from here up to the end)
    jmp sorting_loop
sorting_loop:
    mov rdi, rsp
    add rdi, rbx
    mov rdi, [rdi] ; rdi := [rsp + rdi - 2] == numbers[rdi - 2]
    mov rsi, r14 ; rsi := pivot
    call modulo ; rax := numbers[rdi - 2] % pivot
    cmp rax, 0 ; checking value of modulo
    je delete ; in case modulo == 0 : (divisor) we delete the element by replacing it with a 0
    mov r13, r15
    sub r13, 2 ; r13 := n - 2 >= rbx - 2 (cause rbx is our cursor in the buffer, which has length n - 2)
    cmp rbx, r13 ; comparing our current cursor to the "last cursor possible"
    je end_sorting ; in case we get to the end of the buffer
    add rbx, 1
    jmp sorting_loop
delete:
    mov rdi, 0
    mov r13, r15
    sub r13, 2
    cmp rbx, r13
    je end_sorting
    add rbx, 1
    jmp sorting_loop
end_sorting:
    push rcx ; putting it back
    ret      ; returning





pretty_print:
; Shoud do : showing which primes we got
    pop rcx  ; saving eip
    jmp printing_loop
printing_loop:
    cmp r15, 2 ; have we attained the end of the list ?
    je end_printing
    mov rax, qword [rsp]
    cmp rax, 0 ; is the number we are trying to print a prime ?
    jne printing ; case it's a prime : we print it.
    add rsp, 8 ; case not to print, we free it still
    jmp printing_loop ; and get back to the loop
printing:
    mov rdi, format
    pop rsi
    call printf ; setting up a printf("%d\n", current);
    sub r15, 1
    jmp printing_loop
end_printing:
    push rcx ; putting it back
    ret      ; returning





main:
    push rbp
    mov rbp, rsp
    mov rdi, qword [rsi] ; 'n' in the sieve
    mov r15, rdi ; keeping n right there
    mov rax, 2 ; first pivot
    jmp routine

routine:
    call gen_list
    jmp main_loop
    ; at this point, on the stack we have the array numbers[n] = {2 (@ rsp), ...., n (@ rsp - n + 2)}
main_loop:
    mov rdi, rax ; placing pivot in argument
    call sorting ; deleting each element divisible by current pivot
    add rdi, 1 ; preparing for next step 
    call find_pivot ; returning in rax new pivot
    cmp rax, r15
    jns main_loop ; if our pivot is at the end of the list or more : jump back to our loop

    call pretty_print ; showing which primes we got
    jmp end


end:
    mov rax, 0 ; exit code 0
    leave
    ret

section .data
    format: db "%d\n", 0