TITLE: Assignment #6A        (Assignment_6A.asm)

; Author: Eric Biersner
; Last Modified: 6-8-2019
; OSU email address: biersnee@oregonstate.edu
; Course number/section: 271-400
; Project Number:6					Due Date: 6-9-2019
; Description: Implement your own ReadVal and WriteVal procedures for unsigned integers, 
;			   implement getString and displayString using macros.
;			   Write a test program that gets 10 valid integers from the users.
;			   Display the integers the uers entered, their sum, and their average. 

INCLUDE Irvine32.inc

ARRAYSIZE = 10 ; size of array, ie how many numbers to get from the user.

;MACROS
displayString  MACRO	string
     push      edx                ;Save edx register
     mov       edx, OFFSET string
     call      WriteString
     pop       edx                ;Restore edx
ENDM

getString      MACRO     var, string
     push      ecx
     push      edx
     displayString string         ;Ask the user to enter a string
     mov       edx ,OFFSET var     ;place to store it
     mov       ecx, (SIZEOF var) - 1                                        
     call      ReadString
     pop       edx
     pop       ecx
ENDM

.data
intro				BYTE	"PROGRAMMING ASSIGNMENT 6:  Designing low-level I/O procedures",10,
							"Written By:  Eric Biersner", 0
rules				BYTE	"Please provide 10 unsigned decimal integers.", 10,
							"Each number needs to be small enough to fit inside a 32 bit register.", 10,
							"After you have finished inputting the raw numbers I will display a list", 10,
							"of the integers, their sum, and their average value.", 0
exitPrompt			BYTE	"Thanks for playing! ",0
userInstruction     BYTE	") Enter a number: ",0
invalidNum          BYTE	"ERROR: You did not enter an unsigned number or your number was too big",10,
							"Please try again: ",0
sumPrompt           BYTE	"The sum of your numbers is: ",0
avgPrompt           BYTE	"The average of your numbers is: ",0
comma               BYTE	", ",0
userNumPropt        BYTE	"You entered the following numbers: ",0
count               DWORD     0 ;count of numbers in array
numArray            DWORD     ARRAYSIZE DUP(?) ;array of numbers the user enters
arraySum            DWORD     0
userinput           BYTE      25 DUP(?) ;string to store the users inputed number size arbitrary since it has to be validated later in program
userNum             DWORD     ? ;user number as a number not string
lengthOfInput       DWORD     0 ;track how long ther user number as a string is

.code
main PROC
	;Show User Rules, and introduction
	call	Introduction

	;Counter to get 10 numbers from user
	mov		ecx, ARRAYSIZE
	;loop to get numbers from user
	GetNums:
	push	OFFSET numArray
	push	count
	call	ReadVal
	inc		count               
	loop	GetNums
         
	call	CrLf 
    
	;display the numbers back to the user
	displayString userNumPropt 
	call	CrLf         
	push    OFFSET numArray
	push    ARRAYSIZE
	call    WriteVal
     
	call	CrLf     

	; get sum and average and display them
	push	OFFSET numArray
	push	ARRAYSIZE
	push	arraySum
	call	calculateSum

	push	arraySum
	push	ARRAYSIZE 
	call	calculateAverage

	call	CrLf
	call	programFinished
	exit
main ENDP


; Displays Intro and rules to the user
; Receives: Nothing
; Returns: Nothing
; Registers changed: None
introduction PROC
	displayString intro
	call    CrLf
	displayString rules
	call    CrLf
	call	CrLf
	ret
introduction ENDP

; Calculates and displays the sum
; Receives: array, sum, and ARRAYSIZE 
; Returns: Nothing
; Registers changed: ebp, edi, ecx, edx, eax, ebx
calculateSum PROC
	push      ebp
	mov       ebp, esp
	mov       edi, [ebp+16]
	mov       ecx, [ebp+12]
	mov       ebx, [ebp+8]

	theLoop:
	;set eax to number, and add it to the sum
	mov       eax, [edi]
	add       ebx, eax
	;move on to the next
	add       edi, 4
	loop      theLoop
     
	displayString sumPrompt
	mov       eax, ebx
	call      WriteDec
	call      CrLf
	mov       arraySum, ebx
	pop       ebp
	ret       12
calculateSum ENDP


; calucluates and displays the average of the numbers the user entered
; Receives: sum , ARRAYSIZE
; Returns: Nothing
; Registers changed: eax, ebx, ebp
calculateAverage PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+12]
	mov		ebx, [ebp+8]
	;setting up division
	mov		edx, 0
	idiv	ebx

	displayString avgPrompt
	call	WriteDec

	pop		ebp
	ret		8
calculateAverage ENDP

; Gets number from the user, validates it, converts the input string to integers
; Receives: array, count
; Returns: Nothing
; Registers changed: eax, ecx, edx, edi, esi, ebp
ReadVal PROC
	pushad
	mov		ebp, esp
	;set eax to the current counter
	mov		eax, [ebp+36]
	;add 1 b/c start at 0 not 1
	add		eax, 1
	call	WriteDec
	getString userinput, userInstruction
	;validate the numbers
	jmp		validate

	;if unable to validate
	getNew:
	getString userinput, invalidNum ;get a new number
	validate:
	mov		lengthOfInput, eax
	mov		ecx, eax
	mov		esi, OFFSET userinput
	mov		edi, OFFSET userNum

	;setup a loop to go digit by digit
	counter:
	lodsb
	;check if valus is less 0, ie not a num 
	cmp		al,48
	jl		notNum
	; check if value is more than 9, ie not a num
	cmp		al,57
	jg		notNum
	loop	counter
	jmp		isNum 

	notNum:                                 
	;Grab another number
	jmp		getNew

	isNum:
	mov		edx, OFFSET userinput
	mov		ecx, lengthOfInput

	;http://programming.msjc.edu/asm/help/source/irvinelib/parsedecimal32.htm
	;ParseDecimal32 convert unsigned decimal integer into binary
	;will set the carry flag if it's larger than allowable size, if it is set then get a new number
	call	ParseDecimal32                    
	; check carry flag, ie to large a number                                       
	jc		getNew
	
    
	;move into edx the array ; set array to edx
	mov		edx, [ebp+40]
	;move into ebx the current count ; set the current count to ebx
	mov		ebx, [ebp+36]
	;place the number, multiply the ebx by size of dword for location in array
	imul	ebx, 4
	mov		[edx+ebx], eax
	

	popad
	ret	8
ReadVal ENDP

; Displays the array of numbers inputed to the user
; Receives: array, and ARRAYSIZE
; Returns: Nothing
; Registers changed
; Registers changed: eax, ecx, edi, ebp
WriteVal PROC
	push      ebp
	mov       ebp, esp
	mov       edi, [ebp+12]
	mov       ecx, [ebp+8]

	writeValLoop:
	mov       eax, [edi]
	call      WriteDec
	; check if last number to print, if is then no comma after it, if ecx==1
	cmp       ecx, 1
	je        noComma                       
	displayString comma
	add       edi, 4
	noComma:
	loop      writeValLoop

	pop       ebp
	ret       8
WriteVal ENDP

; Display Exit message tot the user
; Receives: Nothing
; Returns: Nothing
; Registers changed: none
programFinished PROC
	displayString exitPrompt
	call      CrLf
	ret
programFinished ENDP

END main