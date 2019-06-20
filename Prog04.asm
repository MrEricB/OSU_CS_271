TITLE Program 4     (Prog04.asm)

; Author: Eric Biersner
; Last Modified: 5-8-19
; OSU email address: biersnee@oregonstate.edu 
; Course number/section: CS 271-400
; Project Number:  4               Due Date: 5-12-19
; Description: Get a number (n) from the user between [1...400]. Check n is in the range.
;				find the nth composit number and display them all to the user.

INCLUDE Irvine32.inc
; range bounds as constants
UPPERLIMIT = 400
LOWERLIMIT = 1

.data

; prompts to show the user
intro			BYTE	"Composite Numbers			Programmed by Eric Biersner", 0
instruction1	BYTE	"Enter the number of composit numbers you would like to see.",0
insturction2	BYTE	"I will accept orders for up to 400 composites",0
inputPrompt		BYTE	"Enter the number of composites to display [1 .. 400]:",0

incorrectPrmpt	BYTE	"Number out of range.Try again.",0
byeMessage		BYTE	"Resutls certified by Eric Biersner. Goodbyge.",0
dispalySpace	BYTE	"   ",0 ;space to keep composite number list is spaced correctly

; varibales
userNum			DWORD	?
currentNum		DWORD	4 ;set current/starting number to 4 since thats the first comp number
totalComps		DWORD	0 ;keep track of howmany composite numbers have been found
compsPerRow		DWORD	10 ;how many comps to dispaly per row

.code
main PROC
	; procedurs to call, as descriped in the assignment outline.
	call	introduction
	call	getUserData
	call	showComposite
	call	farewall

	exit	; exit to operating system
main ENDP

; display intro to the user
introduction PROC
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf

	mov		edx, OFFSET instruction1
	call	WriteString
	call	CrLf

	mov		edx, OFFSET insturction2
	call	WriteString
	call	CrLf
	
	ret
introduction ENDP

; display farewell message to the user
farewall PROC
	call	CrLf 
	mov		edx, OFFSET byeMessage
	call	WriteString
	call	CrLf
	ret
farewall ENDP

; get a number from the user
getUserData PROC
	mov		edx, OFFSET inputPrompt
	call	WriteString
	call	ReadInt
	mov		userNum, eax
	call	checkUserInput 
	ret
getUserData ENDP

; make sure the number the user inputed is in the correct range [1...400]
checkUserInput PROC
	;check if num to low
	cmp		eax, LOWERLIMIT
	jl		ERROR
	;check if nubm to high
	cmp		eax, UPPERLIMIT
	jg		ERROR
	;number is good continue with the program.
	jmp		NUMBERGOOD

	ERROR: ;num out of range
	mov		edx, OFFSET incorrectPrmpt
	call	WriteString
	call	CrLf
	call	getUserData ;get a new number from the user

	NUMBERGOOD:
	mov		ecx, compsPerRow ; use to count how many number we can print on the current line
	ret
checkUserInput ENDP






; diplay composite number upto and including the users input number (ie user enters 3 dispaly 3 composite numbers)
showComposite PROC
	mov		eax, currentNum
	call	WriteDec ;print 4 to the screen since user must ask for at least one composite number
	mov		edx, OFFSET dispalySpace
	call	WriteString
	dec		ecx
	cmp		ecx, 0 ;check if spaces left on current line
	je		NEWLINE

	CHECKNUM: ;check if numbers are composite or not
	inc		totalComps
	call	isComp ; check number
	jmp		FINISHED ;reach this when isComp RET is reached, (i.e. no more composites to find)

	NEWLINE: ;move to the next line to print
	call	CrLF
	mov ecx, compsPerRow
	jmp	CHECKNUM ;jump back up to check for composit number

	FINISHED:
	ret
showComposite ENDP

; check if a number is a composite number
isComp PROC
	mov		eax, totalComps
	mov		ebx, userNum
	cmp		eax, ebx ; check if totalcomps is queal to how many the user wanted to see, if the same no more composites to find
	je		RETURN

	;increnemt currentNumber till find a composite number
	NEXTNUM: 
	inc		currentNum ;increment to the next number to try, 
	mov		ebx, 2 ;reset divisor to 2 for each number we test in TESTNUM

		 ;test divisors 2 through currentNumber to see if currentNum in composite or prime
		TESTNUM:
		cmp		ebx, currentNum ; if ebx equeals currentNum then the number has no divisors and is NOT composite so try next number
		je		NEXTNUM ;go to the next number

		;test for remainder
		mov		eax, currentNum
		mov		edx, 0
		div		ebx ;divide currentNum by ebx, check for remainder
		cmp		edx, 0 ;if remainder 0 then comp num
		je		COMPOSITE

		;not a comp so go to next divisor (ebx)
		inc		ebx
		jmp		TESTNUM

	COMPOSITE: ;found a composite number so display it and look for next comp
	call	showComposite

	RETURN:
	ret ; no more composite numbers to find return so showComposite can ret and program can fishish

isComp ENDP




END main
