; copyright:    MaoHuPi (c) 2023
; filepath:     nasmPractice/20230728_functionAsArgument.asm
; title:        functionAsArgument
; subtitle:     20230728 nasm practice
; description:  pass a function as an argument and print the corresponding value in the specified range
; environment:  windows x64
; output: <<"endOfOutput";
; _fun: x => x**x
; 0
; 1
; 4
; 27
; 256
; 3125
; 46656
; 823543
; 16777216
; 387420489

; _fun2: x => x**2
; 0
; 1
; 4
; 9
; 16
; 25
; 36
; 49
; 64
; 81
; endOfOutput

bits 64

section .data
    div10:          dd 10
    labels:
    .fun:           db "_fun: x => x**x"
    .fun2:          db "_fun2: x => x**2"
    .space:         db " "

section .bss
	fplCounter:     resb 1
    printContent:   resb 64
    printReverce:   resb 64
    printLabel:     resb 64

section .text
	global 	main
	extern	puts

main:           ; function main()
    ; print label "_fun: x => x**x"
	mov     rcx     , labels.fun
	mov     rbx     , 15
	call	_print
    ; set _fun to arguments and call _funProcess function
    mov     rax     , _fun
    mov     rdx     , 10
    call    _funProcess

    ; print label " "
	mov     rcx     , labels.space
	mov     rbx     , 1
	call	_print

    ; print label "_fun2: x => x**2"
	mov     rcx     , labels.fun2
	mov     rbx     , 16
	call	_print
    ; set _fun2 to arguments and call _funProcess function
    mov     rax     , _fun2
    mov     rdx     , 10
    call    _funProcess

    ; exit process
	xor     rax     , rax
	xor     rbx     , rbx
	xor     rcx     , rcx
	xor     rdx     , rdx
	retn

_print:     ; function _print(rcx:address messageContent, rbx:int messageLength)
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

_printInt:      ; function _print(rcx:int number)

    ; int to str
    mov     ebx     , 0
    mov     [printContent], rcx
    mov     eax     , [printContent]
    __printInt_addChar:
    xor     dl     , dl
    div     dword [div10]
    add     dl     , 48
    mov     [printContent+ebx], dl
    inc     ebx
    cmp     eax     , 0
    jne     __printInt_addChar

    ; reverce content
    push    rcx
    mov     eax     , 0
    __printInt_reverceChar:
    mov     edx     , ebx
    dec     edx
    sub     edx     , eax
    mov     cl      , [printContent+edx]
    mov     [printReverce+eax], cl
    inc     eax
    cmp     eax     , ebx
    jl      __printInt_reverceChar
    pop     rcx

    ; print content
	sub     rsp     , 40
    ; mov     edx     , ebx
    ; add     edx     , 48
    ; mov     [printContent], edx
    ; mov     rcx     , printContent
    mov     rcx     , printReverce
	call    puts
	add     rsp     , 40
	xor     rcx     , rcx

    ; clear content buffer
    __printInt_removeChar:
    dec     ebx
    xor     dl     , dl
    mov     [printContent+ebx], dl
    mov     [printReverce+ebx], dl
    cmp     ebx     , 0
    jg      __printInt_removeChar
    mov     ebx     , 0

	retn

_power:         ; function _power(rcx:int b, rbx:int t)
    push    rax
    mov     rax     , 1
    __power_loop:
    mul     rcx
    dec     rbx
    cmp     rbx     , 0
    jg      __power_loop
    mov     rcx     , rax
    pop     rax
    retn

_fun:           ; function _fun(rcx:int x)
    ; x = x**x
    push    rbx
    mov     rbx, rcx
    call    _power
    pop     rbx
    retn

_fun2:           ; function _fun(rcx:int x)
    ; x = x**x
    push    rbx
    mov     rbx, 2
    call    _power
    pop     rbx
    retn
    
_funProcess:    ; function _funcProcess(rax:function vFunction, rdx:int rangeMax)
    ; for each number of 0 ~ rangeMax
    mov     rcx     , 0
    __funProcess_loop:
    mov     [fplCounter], rcx
    push    rcx
    push    rdx

    ; call vFunction to get corresponding value
    mov     rcx     , [fplCounter]
    call    rax

    ; print value
    push    rax
    call    _printInt
    pop     rax
    pop     rdx
    pop     rcx

    ; run untile the counter value is equal to rangeMax
    inc     rcx
    cmp     rcx     , rdx
    jnz     __funProcess_loop

    retn