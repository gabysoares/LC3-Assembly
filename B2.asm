; gsoa420
; This program is my own unaided work, and was not copied
; nor written in collaboration with any other person.
; Gabriella Soares

; This program asks the user for a number between 3-23 and checks if valid, if so it ouputs the fibonacci sequence.

.orig x3000
start      and r0,r0, #0
	   add r0,r0,10
	   putc
	   lea r0, enter 			; loads register r0 with starting address of the prompt string
           puts 				; outputs the prompt message
           lea r1, keyValue 			; r1 points to offset 
           and r2, r2,#0  			; number of characters read saved in r2

loop       getc 				; gets the character entered by the user
           add r2, r2, 1  			; increment number of characters read
           str r0, r1, #0 			; store each character
           add r1,r1,#1   			; point to next memory location 
           putc 				; output each character
           add r0, r0 ,#-10 			; check if return/enter key has been entered
           brz ASCIItoDecimal			; if an enter/return key has been pressed then go to checkValue
           brnzp  loop 				; go back to start of loop until enter/return key has been pressed

stop       halt


             

ASCIItoDecimal 	add r1,r2,#-3			; this section converts ASCII to decimal
		brn oneDigit			; if 2 characters (character and enter/return), branch to oneDigit
		ld r3, keyValue     		; load second character
                ld r4, key0
		add r3, r3, r4       		; get either 1 or 2
		add r3, r3, r3       		; For the first digit, multiply by 10
                add r4, r3, 0        		
                add r3,r3,r3         		 
		add r3,r3,r3         		 
		add r3,r3,r4         		; add its value to the second character

		lea r4, keyValue     		
	        ldr r6, r4,1
		ld  r4, key0     
		add r5, r4, r6
	        add r3, r3, r5			
		brnzp startLoop			; r3 a 2 character input

oneDigit	lea r4, keyValue		; load first character
	        ldr r6, r4,0
		ld  r4, key0     		 
	        add r3, r4, r6			; r3 contains single character input



startLoop	ld r2, maxVal			; check the input is less than 24
		add r2, r3,r2
		brp start			; if invalid, go back to prompt user input
		
		ld r2, minVal			; check the input is greater than 2
		add r2,r3,r2
		brn start			; if invalid, go back to prompt user input
		
		lea r0, fib0			; output the first number in fib sequence
           	puts 
		and r0,r0,0			
		add r0, r0,3			

		st r0, fibCtr			; set fibCtr to 0 initially to check when we've reached the user input, stored in fbTarget
		add r3, r3, 1	
		st r3, fibTarget
nextFibValue	ld r0 fibCtr			
		not r0,r0
		add r0, r0, 1			; 2's complement fibCtr 
		ld r3, fibTarget		
		add r0,r0,r3			; check if fibCtr > fibTarget
		brn stop 			; exit after outputting sequence
		ld  r3, fibCtr			; set r3 to fibCtr
		jsr fibonacci

		ld r0, asciiSpace		; outputs space between each fibonacci number printed
		putc
		ld r0, fibCtr			
		add r0, r0, 1			; increment fibCtr by 1
		st r0, fibCtr			
		brnzp nextFibValue
		




fibonacci       add r5, r3, #0       	; load keyValue into r5
		and r1, r1, #0 		; since starting from fibonacci 3, initialize assuming fib 1 and 2  
		add r1, r1, #1	  	; make r1 =1, r2= 1, r3 = 1
		add r2, r1, #0 		; r1 = Fn-1, r3 = Fn-2
		add r3, r1, #0       	; r3 stores Fn


		and r4, r4, #0 	   	; set r4 to be a loop counter 3 to user keyValue
		add r4, r4, #3		; start point for fibonacci sequence

		
fibLoop	 	add r6, r4, #0	     	; compare loop counter and key value 
		add r0,r5, #0		; store keyValue in r0
		not r0, r0		
		add r0, r0, #1		; 2's complement of keyValue
		add r0, r6, r0		; if loop counter < keyValue
	  	
		brz divideAndPrint	; finished calculating fib value, go to outputting
		add r3, r1, r2		; calculate next value in the fib sequence using Fn = Fn-1 + Fn-2
		add r2, r1, 0
		add r1, r3, 0
		add r4, r4, 1
		brnzp fibLoop		

		     
divideAndPrint  and r6,r6, #0  			; r3 = number, r4 = divisor, r0 = result, r6 = remainder
		and r4,r4, #0			; dividing to get the placeholder value eg 28123 / 10000 = 2, then 8123 (remainder) / 1000 = 8
		and r4,r4, #0
		ld r4, highestDivisor		

keepDividing	add r4,r4,0    			; check if r4 0
                brnz exitSub  			
		and r0, r0, #0
		not r4, r4     			; 1's complement
		add r4,r4,#1   			; 2's complement / negative of the divisor

divideLoop	add r2,r3,r4    		; check if number >= divisor
		brn printFib   
		add r0,r0,#1    		; store result
		add r3,r2, #0   		; make remainder the new number
		brnzp divideLoop		


printFib	ld r1, ascii0			; convert from decimal to ascii for outputting
		add r0,r0,r1			
		st   r7, r7Store	
		putc		   		; outputs fib value
		ld  r7, r7Store			; putc changes r7 so save it for return address
		and r6, r6, #0				
		add r6, r6, #10	  		; setting r6 to divide by 10
		and r0,r0,#0

divideBy10	add r4,r4,r6			; divide divsor by 10 to get next place holder divisor eg 10000 to 10000 to 1000 to 10 to 1
		brp doneDiv			
		add r0,r0, #1
		brnzp divideBy10

doneDiv 	add r4, r0, #0
		brnzp keepDividing

exitSub		ret				; return from subroutine

	     

enter .stringz "Enter a number from 3 to 23: "
fib0 .stringz "00001 "                            ; string used to print the value for fibonacci 1
minVal .blkw 1 #-3					
maxVal .blkw 1 #-23
keyValue .blkw 10 #0				  ; memory location to store the user input
key0 .blkw 1 #-48				  ; negative ascii values for numbers to allow ascii to decimal coversion and check valid inputs
key9 .blkw 1 #-57
key1 .blkw 1 #-49
key2 .blkw 1 #-50
key3 .blkw 1 #-51
highestDivisor .blkw 1 #10000			  ; corresponds to the max fibonacci val we can expect for input of 23 


newLine .blkw 1 #10				  
ascii0 .blkw 1 #48
asciiSpace .blkw  1, #32
fibCtr	.blkw 1 0				  
fibTarget .blkw 1 0
r7Store .blkw 1 0                                ; used to save r7 (return from subroutine) program value.


.end