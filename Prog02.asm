TITLE Programming Assignment 2     (Prog02.asm)

; Author: Eric Biersner
; Last Modified: 4/18/19
; OSU email address: biersnee@oregonstate.edu
; Course number/section: 271-400
; Project Number:  2             Due Date: 4/21/19
; Description: Greet User, get a number from user and calculate a nth fibonacci number, from the user inputed number. Make sure the number the user entered is in the range [1 .. 46]

INCLUDE Irvine32.inc

; Constants
	LOWER = 1	; lower and upper limits on numbers the user can enter
	UPPER = 46

.data
;prompts to show the user
progName		BYTE	"Fibonacci Numbers",0
progAuthor		BYTE	"Programmed by Eric Biersner",0

namePrompt		BYTE	"What's your name? ",0
greetPrompt		BYTE	"Hello, ", 0

fibPrompt		BYTE	"Enter the number of Fibonacci terms to be displayed",0
fibPrompt2		BYTE	"Give the number as an integer in the range [1 .. 46].",0
getFibPrompt	BYTE	"How many Fibonacci terms do you want? ",0

outRangePrompt	BYTE	"Out of range. Enter a number in [1 .. 46]",0

endPrompt		BYTE	"Results certified by Leonardo Pisano.",0
byePrompt		BYTE	"Goodbye, ",0
period			BYTE	".",0
space			BYTE	"     ",0

;variablse to use later
userName		BYTE	45 DUP(0)	; hold the users name max 45 characters
fibNumber		DWORD	?			; nth fib number to find that the user enters

; numbers to be used to calculate fib numbers
currentNum		DWORD	?
nextNum			DWORD	?
prevNum			DWORD	?
rowCount		DWORD	?			; number of fibs calculated
.code
main PROC

; Introduction and title displayed to user
	mov		edx, OFFSET progName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET progAuthor
	call	WriteString
	call	CrLf
	call	CrLf

; Prompt user to get their name, and greet them
	mov		edx, OFFSET namePrompt
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName ; max size for nubmer of characters in username
	call	ReadString			; read the users name in

	mov		edx, OFFSET greetPrompt
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; Prompt user to get their nth fib number
	mov		edx, OFFSET fibPrompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET fibPrompt2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET getFibPrompt
	call	WriteString
	call	ReadInt

	mov		fibNumber, eax
; check number is in correct range
CHECKRANGE:
	mov		eax, fibNumber
	cmp		eax, UPPER
	jg		NEWNUMBER
	cmp		eax, LOWER
	jl		NEWNUMBER
	
	jmp		FINDFIB	; user input is good jump to calc the fib numbesrs
; get a new number from the user
NEWNUMBER:
	mov		edx, OFFSET outRangePrompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET getFibPrompt
	call	WriteString
	call	ReadInt
	mov		fibNumber, eax
	jmp		CHECKRANGE
	
; calculat the fib numbers
FINDFIB:
	call	CrLf ;just for spacing to make easier to read
; initial set up to find nth fib number
	mov		ecx, fibNumber ;will be use as counter in a loop
	mov		nextNum, 0
	mov		currentNum, 1
	mov		prevNum, 0
	mov		rowCount, 0
	

CALCULATE:
; calculate and print fib numbers
	mov		eax, currentNum
	call	WriteDec
	inc		rowCount
	
	; next becomes current + prev
	mov		eax, prevNum
	add		eax, currentNum
	mov		nextNum, eax 
	; prev becomse current
	mov		eax, currentNum
	mov		prevNum, eax
	; current becomes next to loop back and print
	mov		eax, nextNum
	mov		currentNum, eax

	; determine if print a space or go to new line
	mov		edx, 0
	mov		eax, rowCount
	mov		ebx, 5
	div		ebx
	mov		eax, 0
	cmp		edx, eax
	JZ		NEWLINE		
	mov		edx, OFFSET space
	call	WriteString
	JMP		NOLINE
NEWLINE:
	call	CrLf
NOLINE:
	loop	CALCULATE

; Say goodbye to the uers
	call	CrLf	; just to make easier to read terminal
	call	CrLf
	mov		edx, OFFSET endPrompt
	call	WriteString
	call	CrLf
	mov		edx, OFFSET byePrompt
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
