;-------------------;
; Fibonacci sequence
; By: Daniel
; 2022-11-25
;-------------------;

;-------------------; SYSTEM CALLS
SYS_WRITE equ 1 ; write to _
SYS_EXIT equ 60 ; end program
;-------------------;

;-------------------;
STDOUT equ 1 ; standard output
;-------------------;

section .bss

section .data
finished: db 10, "Done.", 10
doneLen: equ $-finished
newLine: db 10
newLineLen: equ $-newLine

    section .text
    global _start
_start:
; Initialize the first two numbers of the Fibonacci sequence
mov r8, 0 ; number 0
mov r9, 1 ; number 1

    ; Initialize the counter to 2
    mov r10, 2         ; counter

    ; Print first 2 numbers
    push r8
    call PrintSingleDigitInt
    add rsp, 4

    push r9
    call PrintSingleDigitInt
    add rsp, 4

    loop:
    ; Calculate the next number in the sequence
    mov r11, r9        ; store previous value of r9 in r11
    add r9, r8         ; add r8 and r9 and store the result in r9
    mov r8, r11        ; update r8 with the previous value of r9

    ; Print r9
    push r9
    call PrintSingleDigitInt
    add rsp, 4

    ; Increment the counter
    inc r10

    ; Check if the counter is equal to 7
    cmp r10, 7
    je done            ; jump to done if flag is equal to
    jmp loop           ; jump to loop if flag is not equal to

    done:
    ; Done
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, finished
    mov rdx, doneLen
    syscall

    ; SYS_EXIT SUCCESS
   	mov rax, SYS_EXIT     ; Setting system call to 60(sys_exit)
  	mov rbx, 0            ; Setting rdi to 0(program succesful)(return 0)
  	syscall               ; system call 

PrintSingleDigitInt:
    ; takes in a single digit int and prints the assci equivalent
    ; when a function is called, the return value is placed on the stack

    ; we need to keep this, so that we can return to the corret place in our program!
    pop r14                     ; pop the return address to r9
    pop r15                     ; pop the "parameter" we placed on the stack
    add r15, 48                 ; add the ascii offset
    push r15                    ; place it back onto the stack

    ; write value on the stack to STDOUT
    mov rax, 1                  ; system call for write
    mov rdi, 1                  ; file handle 1 is stdout
    mov rsi, rsp                ; the string to write popped from the top of the stack
    mov rdx, 1                  ; number of bytes
    syscall                     ; invoke operating system to do the write

    ;add     $8, %rsp    # restore sp -> not sure this is neede!

    ; https://stackoverflow.com/questions/8201613/printing-a-character-to-standard-output-in-assembly-x86
    ; print a new line
    mov rax, 1                  ; system call for write
    mov rdi, 1                  ; file handle 1 is stdout
    mov rsi, newLine
    mov rdx, 1                  ; number of bytes
    syscall                     ; invoke operating system to do the write

    push r14                    ; put the return address back on the stack to get back
    ret                         ; return
