TITLE Prog5     (Prog05.asm)

; Author: Eric Biersner
; Last Modified: 5-27-2019
; OSU email address: biersnee@oregonstate.edu
; Course number/section: 271-400
; Project Number:   5             Due Date: 5-26-19
; Description: Get a range from user [10...200]. Generate that many random numbers, with values ranging [100 ... 999]
;				Display the randome numbers unsorted. Sort the numbers and display sorted, calculate and display the median.


INCLUDE Irvine32.inc

;CONSTANTS
MIN=10			
MAX=200			
LO=100			
HI=999
.data

;variables
intro			BYTE	"Sorting Random Integers			Programmed by Eric Biersner", 0
rules			BYTE	"This program generates random numbers in the range [100... 999],", 0
rules2			BYTE	"displays the original list, sorts the list, and calucluates the", 0
rules3			BYTE	"median value. Finally, it displaus the list sorted in descending order", 0
getNum			BYTE	"How many numbers should be generated? [10 .. 200] : ", 0
getNum2			BYTE	"Invalid input", 0
userNum			DWORD	?
numberArr		DWORD	200	DUP(?)
count			DWORD	0
perLine			DWORD	0
unsortPrmp		BYTE	"The unsorted random numbers: ", 0
sortPrmp		BYTE	"The sorted list: ", 0
medianPrmp		BYTE	"The median is ", 0
outerCount		DWORD	?; loop counter for sorting array


.code
main PROC

call	randomize

; show intro and rule prompts
call	introduction

; get user data
push	userNum
call	getData

; fill the array with random numbers
push	OFFSET	numberArr
push	userNum
call	fillArray

; display the unsorted array
push	OFFSET unsortPrmp
push	OFFSET numberArr
push	userNum
call	displayList


; sort the array
push	OFFSET	numberArr
push	userNum
call	sortList

; display the median 
push	OFFSET	numberArr
push	userNum
call	displayMedian

; display the sorted array
push	OFFSET sortPrmp
push	OFFSET numberArr
push	userNum
call	displayList

exit
main ENDP


;Display introduction and rules to the users.
;receives: none
;returns: none
;preconditions: none
;registers changed: none
introduction PROC
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET rules
	call	WriteString
	call	CrLf
	mov		edx, OFFSET rules2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET rules3
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP


;Get number from the user
;receives: usercount
;returns: number of elements to generate, base on user input
;preconditions: none
;registers changed: eax
getData PROC
	; set up the stack fram
	push	ebp
	mov		ebp, esp
	call	CrLf
	jmp		GETUSERNUM

	; get another number from the user
	ERROR:
	mov		edx, OFFSET getNum2
	call	WriteString
	call	CrLf

	GETUSERNUM :
	mov		edx, OFFSET getNum
	call	WriteString
	call	ReadInt
	; copy users number entered onto the stack
	mov		[ebp + 8], eax

	; input validation
	cmp		eax, MAX
	jg		ERROR
	cmp		eax, MIN
	; number too big or small
	jl		ERROR
	mov		userNum, eax
	
	;number is good
	call	CrLf
	pop ebp
	ret 4

getData ENDP


;fill array with random numbers
;receives: address of array, count/userNum of the array
;returns: the first n elements of random nubmers in array, where n is the useres input number
;preconditions: userNum in the range 10-200
;registers changed: eax, ecx, ebx, edx, edi
fillArray PROC

	; setup stack frame
	push	ebp						
	mov		ebp, esp
	; usernum for loop counter
	mov		ecx, [ebp+8]	
	; address of array		
	mov		edi, [ebp+12]
	; set uper and lower limit for random numbers
	mov		ebx, LO	
	mov		edx, HI					
	;upper limit + 1 - lower limit ie 900
	inc		edx
	sub		edx, ebx				

	GENERATENUM:
	; get randomr number
	mov		eax, edx				
	call	RandomRange			;add 100 to the random number
	; make sure number is in ther correct ranger
	add		eax, LO
	; store new number					
	mov		[edi], eax				
	add		edi, 4		
	loop	GENERATENUM	

	pop		ebp
	ret		8
fillArray ENDP


; sort values in an array
;receives: address of the array, userNum
;returns: array sorted large to small
;preconditions: usernum and array are initialized
;registers changed: eax, ebx, ecx, edi
sortList PROC
	push	ebp
	mov		ebp, esp
	; loop counter set to userNum
	mov		ecx, [ebp + 8]
	; set outer loop to 1 less
	dec		ecx

	OUTERLOOP:
	;mov		edi,[ebp+16]
	mov		edi,[ebp+12]
	mov		outerCount,ecx

	INNERLOOP:
	mov		eax, [edi]
	; compare "array[a]" and "array[a+1]"
	cmp		eax, [edi + 4]

	jg		NEXTNUM
	; swap numbers
	xchg	eax, [edi + 4]
	mov		[edi],eax


	NEXTNUM:
	add		edi, 4
	loop	INNERLOOP

	mov		ecx, outerCount
	loop	OUTERLOOP

	pop		ebp
	ret		8
sortList ENDP


; calculate and display median to the suer
;receives: address of array, userNumber
;returns: display the array's median value
;preconditions: userNumber initialized, and array initialized with values
;registers changed: eax, ebx, ecx
displayMedian PROC
	
	push	ebp	
	mov		ebp, esp
	; array address
	mov		edi, [ebp+12]
	; userNum set
	mov		eax, [ebp+8]
	
	; check if amount of elements is odd or even		
	cdq
	mov		ebx, 2
	div		ebx
	cmp		edx, 0
	; odd number
	jne		ISODD
	ISEVEN:
	dec		eax	
	;add the two middle elements together						
	mov		ebx, [edi+eax*4]
	inc		eax
	mov		ecx, [edi+eax*4]
	mov		eax, ebx
	add		eax, ecx
	mov		ebx, 2
	div		ebx					
	; display the median to the user
	mov		edx, OFFSET medianPrmp
	call	WriteString	
	call	WriteDec		
	jmp		RETURN

	ISODD:
	mov		ebx, [edi+eax*4]
	mov		eax, ebx						
	; display the median to the user
	mov		edx, OFFSET medianPrmp
	call	WriteString	
	call	WriteDec
	RETURN:
	call	CrLf
	pop		ebp
	ret		8
displayMedian ENDP



; display the numbers in the array
;receives: address of array, usersnum, prompt for user
;returns: displays userNum of elements in the array
;preconditions: userNum is 10..200, array is filled
;registers changed: eax, ebx, ecx, edx, esi
displayList PROC

	; set up stk frame
	push	ebp							
	mov		ebp, esp
	; count elements in the arr
	mov		ecx, 0						
	; counter for elements perline
	mov		ebx, 0
	; array's address						
	mov		esi, [ebp+12]
	; prompt to show user
	mov		edx, [ebp+16]
	; prompt to show user			
	call	CrLf
	call	WriteString	
	call	CrLf

	DISPLAYARRY:
	;dispaly number
	mov		eax, [esi+ecx*4]			
	call	WriteDec					
	inc		ebx
	; if displayed 10 numbers go to new line
	cmp		ebx, 10						
	je		NEWLINE						
	cmp		ecx, [ebp+8]
	je		NEWLINE
	; display tab instead of new line
	mov		eax, "	"					
	call	WriteChar
	jmp		LOOPARRAY

	; move to next line
	NEWLINE:
	call	CrLf
	sub		ebx, 10

	; loop userNum times
	LOOPARRAY:
	inc		ecx							
	cmp		ecx, [ebp+8]
	jne		DISPLAYARRY

	; done dispalying numbers
	call	CrLf
	call	CrLf
	pop		ebp
	ret		12


displayList ENDP

END main
