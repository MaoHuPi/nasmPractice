; copyright:    MaoHuPi (c) 2023
; filepath:     nasmPractice/20230729_macroInstructionApplication.asm
; title:        macroInstructionApplication
; subtitle:     20230729 nasm practice
; description:  use macros to define, concatenate, and count text
; environment:  windows x64
; output: <<"endOfOutput";
; name: MaoHuPi
; endOfOutput

bits 64
cpu x64

%define labelName "name: "
%defstr info MaoHuPi(c)2023
%substr name info 0, 7
%strcat message labelName, name
%strlen messageLength message

section .data
    messageContainer: db message

section .bss
    printChar:      resb 1
    printLabel:     resb 64

section .text
    global  main
    extern  puts

%macro      print  2     ; function print(rcx:address messageContent, rbx:int messageLength)
    ; set arguments
    mov     rcx     , %1
    mov     rbx     , %2

    ; reserve spaces
    sub     rsp     , 40

    ; add chars to the printLabel
    mov     rax     , 0
    push    rdx
    __addChar:
    mov     dl      , [rcx+rax]
    mov     [printLabel+rax], dl
    inc     rax
    cmp     rax     , rbx
    jnz     __addChar
    pop     rdx

    ; call puts function
    mov     rcx     , printLabel
    call    puts
    add     rsp     , 40

    ; remove each char in the printLabel
    mov     rax     , 0
    __removeChar:
    mov     [printLabel+rax], byte 0
    inc     rax
    cmp     rax     , rbx
    jnz     __removeChar

    ; clean register and return
    ; xor     rax     , rax
    xor     rbx     , rbx
    xor     rcx     , rcx
    ; xor     rdx     , rdx
    retn
%endmacro

main:       ; function main()
    ; print message
    ; mov     rcx     , messageContainer
    ; mov     rbx     , messageLength
    ; call    _print
    print  messageContainer, messageLength

    ; exit process
    xor     rax     , rax
    xor     rbx     , rbx
    xor     rcx     , rcx
    xor     rdx     , rdx
    retn