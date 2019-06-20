TITLE Number Accumulator     (prog03.asm)

; Author: Eric Biersner
; Last Modified:  5-4-19
; OSU email address: biersnee@oregonstate.edu
; Course number/section: CS 271-400
; Project Number:  3               Due Date: 5-5-19
; Description: Get user name,and greet. Propmt user for a number, validat it is in the 
;				inclusive range [-100,-1], count and acuumulate the number of valid numbers entered
;				until user enters a non valid numver (ie the enter 3). Display the rounded average (int) of neg numbers
;				Display neg num count, sum of neg, average of neg.

INCLUDE Irvine32.inc

LIMIT = -100
LOW_LIMIT = -1

.data
;messages to the user
introPrompt	BYTE	"Welcom to the Integer Accumulator by Eric Biersner", 0
namePrompt	BYTE	"What is your name? ", 0
grtPrompt	BYTE	"Hello, ", 0
rulePrompt	BYTE	"Please enter numbers in [-100, -1] ",0
moreRlPrmt	BYTE	"Enter a non-negative number when you are finished to see results. ", 0
tooLowPrmt	BYTE	"The number you entered was too low, must be between -100 and -1. ",0

getNumPrmt	BYTE	"Enter number: ",0
numEntered	BYTE	"You entered ",0
numEntered2	BYTE	" valid numbers",0
userTotal	BYTE	"The sum of your valid numbers is ",0
userRound	BYTE	"THe rounded average is ",0
endPrompt	BYTE	"Thank your for playing Integer Accumulator! See you again soon, ",0

;varialbes 
userName	BYTE	256 DUP(0)
enteredNum	DWORD	?
currentSum	DWORD	0 ;total sum of the valid numbers the user has entered
average		DWORD	0
count		DWORD	0 ; how many valid numbers the user has entered
increase	DWORD	1 ; how much to increase count, and currentNUm by each iteration

.code
main PROC

;greet the user
mov		edx, OFFSET introPrompt
call	WriteString
call	CrLF

;get user name
mov		edx, OFFSET namePrompt
call	WriteString
mov		edx, OFFSET userName
mov		ecx, 255
call	ReadString

;user greeting
mov		edx, OFFSET grtPrompt
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf

;display rules
mov		edx, OFFSET rulePrompt
call	WriteString
call	CrLf
mov		edx, OFFSET moreRlPrmt
call	WriteString
call	CrLf




;get numbers from user

enterNums:
mov		edx, OFFSET getNumPrmt
call	WriteString
call	ReadInt
mov		enteredNum, eax

;validate input
mov		eax, enteredNum
cmp		eax, LOW_LIMIT
JG		endMessage ; number was posivive move to end program
cmp		eax, LIMIT 
jl		errorMsg ; number too low ask user for a display message and ask again

;update total
mov		eax, currentSum
mov		ebx, enteredNum
add		eax, ebx
mov		currentSum, eax

;update count
mov		eax, count
mov		ebx, increase
add		eax, ebx
mov		count, eax

jmp enterNums ;loop back for more inputs from the user



errorMsg:
; num entered less than -100
mov		edx, OFFSET tooLowPrmt
call	WriteString
call	CrLf
jmp		enterNums



endMessage: 
;Your entered: X valid numbers
mov		edx, OFFSET numEntered
call	WriteString
mov		eax, count
call	WriteDec
mov		edx, OFFSET numEntered2
call	WriteString
call	CrLf
; if no valid entered end program
mov		eax, count
cmp		eax, 1
jl		noNumEnd

;sum of numbers message
mov		edx, OFFSET userTotal
call	WriteString
mov		eax, currentSum
call	WriteInt
call	CrLf

;calculate the average
mov		eax, currentSum
mov		ebx, count
xor		edx, edx ;set edx to zero
cdq
idiv	ebx
mov		average, eax

endProgram:
;display average to the user
mov		edx, OFFSET userRound
call	WriteString
mov		eax, average
call	WriteInt
call	CrLf
noNumEnd:
;thank the user and end program
mov		edx, OFFSET endPrompt
call	WriteString
mov		edx, OFFSET userName
call	WriteString
call	CrLf



	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
