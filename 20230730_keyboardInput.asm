; copyright:    MaoHuPi (c) 2023
; filepath:     nasmPractice/20230730_keyboardInput.asm
; title:        keyboardInput
; subtitle:     20230730 nasm practice
; description:  press the left and right keys of the keyboard to move the position of "I" in the output string
; environment:  windows x64
; output: <<"endOfOutput";
; I_________
; _I________
; __I_______
; ___I______
; ____I_____
; _____I____
; ______I___
; _______I__
; ________I_
; _________I
; _________I
; _________I
; _________I
; ________I_
; _______I__
; ______I___
; _____I____
; ____I_____
; ___I______
; __I_______
; _I________
; I_________
; I_________
; I_________
; I_________
; I_________
; _I________
; __I_______
; endOfOutput

bits 64
cpu x64

section .data
    char:
    .empty:         db "_"
    .i:             db "I"
    platform:       db "I_________", 0
    .length:        equ $ - platform - 1

section .bss
    pressedKey:     resb 1
    position:       resb 1

section .text
    global main
    extern puts
    extern getch
    extern MessageBeep

main:
    mov     [pressedKey], byte 1
    mov     [position], byte 0

    __animation:
    cmp     [pressedKey], byte 27
    je      __exit

    cmp     [pressedKey], byte 0
    je      __arrowStart
    cmp     [pressedKey], byte 224
    jne     __noArrow

    __arrowStart:
    call    getch
    mov     [pressedKey], al
    push    rbx
    mov     rbx     , [position]
    mov     al     , [char.empty]
    mov     [platform+rbx], al
    ; call    _clearPlatform

    cmp     [pressedKey], byte 75
    jne     __noLeft
    cmp     rbx     , 0
    jng     __noDec
    dec     rbx
    __noDec:
    jmp     __arrowEnd
    __noLeft:

    cmp     [pressedKey], byte 77
    jne     __noRight
    push    rdx
    mov     rdx     , platform.length
    dec     rdx
    cmp     rbx     , rdx
    pop     rdx
    jnl     __noInc
    inc     rbx
    __noInc:
    jmp     __arrowEnd
    __noRight:

    __arrowEnd:
    mov     al     , [char.i]
    mov     [platform+rbx], al
    mov     [position], rbx
    pop     rbx

    __noArrow:
    
    mov     rcx     , platform
    call    puts
    ; mov     rbx     , platform.length
    ; call    _print
    
    call    getch
    mov     [pressedKey], al
    jmp     __animation

    __exit:
    push    255
    call    MessageBeep
    retn

_clearPlatform:
    push    rbx
    mov     rbx     , [char.empty]
    push    rdx
    mov     rdx     , 0
    __clear:
    mov     [platform+rdx], rbx
    inc     rdx
    cmp     rdx     , platform.length
    jl      __clear
    pop     rdx
    pop     rbx
    retn