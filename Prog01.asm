TITLE Programming Assignment 1    (Prog1.asm)

; Author: Eric Biersner
; Last Modified: 4/10/19
; OSU email address: biersnee@oregonstate.edu
; Course number/section: 271-400
; Project Number: 1                 Due Date: 4/14/19
; Description: Get two integers from user, and preform addiction, subtraction, multiplicatin and divison, displaying the results

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; inputs
number1		DWORD	?	;users 1st number
number2		DWORD	?	;users 2nd number
result		DWORD	?	;result of math operation between the two numbers
remainder	DWORD	?	;remainder from division operations

; prompts to show the user
introPrompt	BYTE	"Elementrary Arithmetic by Eric Biersner",0														;display program title and author to the user
instruction	BYTE	"Enter 2 numbers and I will show you the sun, difference, product, quotiend, and remainder.",0	;display instructions to user
num1Prompt	BYTE	"Please enter a first number: ",0	; prompt the user to enter numbers
num2Prompt	BYTE	"Please Enter a second number (less than the first): ",0
endMessage	BYTE	"Impressed? Bye!",0
remMessage	BYTE	"remainder",0
space		BYTE	" ",0



.code
main PROC

; show user the intro and rules
	mov		edx, OFFSET introPrompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruction
	call	WriteString
	call	CrLf
; get user input 
	mov		edx, OFFSET num1Prompt
	call	WriteString
	call	ReadInt
	mov		number1, eax
	
	mov		edx, OFFSET num2Prompt
	call	WriteString
	call	ReadInt
	mov		number2, eax
; make sure second number is less than first number
checkNums:	
	cmp		eax, number1 ; check if number2 is less than number 1
	jl		exitLoop
	mov		edx, OFFSET num2Prompt
	call	WriteString
	call	ReadInt
	mov		number2, eax
	jmp		checkNums ;jump back to start loop over again
exitLoop:
; get sum
	mov		eax, number1
	mov		ebx, number2
	add		eax, ebx
	mov		result, eax
;display the result
	mov		eax, number1
	call	WriteDec
	mov		al, 43		; + ascii symbol
	call	WriteChar
	mov		eax, number2
	call	WriteDec
	mov		al, 61 ; = ascii symbol
	call	WriteChar
	mov		eax, result
	call	WriteDec
	call	CrLf
		
; get difference
	mov		eax, number1
	mov		ebx, number2
	sub		eax, ebx
	mov		result, eax
;display the result
	mov		eax, number1
	call	WriteDec
	mov		al, 45		; - ascii symbol
	call	WriteChar
	mov		eax, number2
	call	WriteDec
	mov		al, 61 ; = ascii symbol
	call	WriteChar
	mov		eax, result
	call	WriteDec
	call	CrLf

; get product
	mov		eax, number1
	mov		ebx, number2
	mul		ebx
	mov		result, eax
;display the result
	mov		eax, number1
	call	WriteDec
	mov		al, 42		; - ascii symbol
	call	WriteChar
	mov		eax, number2
	call	WriteDec
	mov		al, 61 ; = ascii symbol
	call	WriteChar
	mov		eax, result
	call	WriteDec
	call	CrLf
	
; get quotiant and remainder
	mov		edx, 0
	mov		eax, number1
	mov		ebx, number2
	div		ebx
	mov		result, eax
	mov		remainder, edx
;display the result
	mov		eax, number1
	call	WriteDec
	mov		al, 47		; / ascii symbol
	call	WriteChar
	mov		eax, number2
	call	WriteDec
	mov		al, 61 ; = ascii symbol
	call	WriteChar
	mov		eax, result
	call	WriteDec
	mov		eax, remainder
	mov		edx, OFFSET space
	call	WriteString
	mov		edx, OFFSET remMessage
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	call	WriteDec
	call	CrLf

; ending message to the user
	mov		edx, OFFSET endMessage
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
