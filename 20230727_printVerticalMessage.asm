; copyright:    MaoHuPi (c) 2023
; filepath:     nasmPractice/20230727_printVerticalMessage.asm
; title:        printVerticalMessage
; subtitle:     20230727 nasm practice
; description:  print text content as vertical (print each char of a message)
; environment:  windows x64
; output: <<"endOfOutput";
; horizontal:
; hello
; 
; vertical:
; h
; e
; l
; l
; o
; endOfOutput

bits 64

section .data
	labels:
    .horizontal: 	db "horizontal:"
    .vertical:      db "vertical:"
    .space:         db " "
	message:        db "hello"
    .length:        equ 5

section .bss
	printChar:      resb 1
	printLabel:     resb 64

section .text
	global 	main
	extern	puts

main:       ; function main()
    ; print label "horizontal:"
	mov     rcx     , labels.horizontal
	mov     rbx     , 11
	call	_print
    ; print message content
	mov     rcx     , message
	mov     rbx     , 5
	call	_print

    ; print label " "
	mov     rcx     , labels.space
	mov     rbx     , 1
	call	_print

    ; print label "vertical:"
	mov     rcx     , labels.vertical
	mov     rbx     , 9
	call    _print
    ; print each char in the message
	mov     rax     , 0
    __printChar:
    mov     bl      , [message+rax]
    mov     [printChar], bl
    mov     rcx     , printChar
    push    rax
    mov     rbx     , 1
    call    _print
    pop     rax
    inc     rax
    cmp     rax     , message.length
    jl      __printChar

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