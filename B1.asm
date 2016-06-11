; gsoa420
; This program is my own unaided work, and was not copied
; nor written in collaboration with any other person.
; Gabriella Soares

; This program asks the user for a number between 0-9 and checks if valid, if so it ouputs a 4 digit binary representation.

.orig x3000
start      lea r0, enter 			; loads register r0 with starting address of the prompt string
           puts 				; outputs the prompt message
           lea r1, keyValue 			; r1 points to offset 
           and r2, r2,#0  			; number of characters read saved in r2
loop       getc 				; gets the character entered by the user
           add r2, r2, 1  			; increment number of characters read
           str r0, r1, #0 			; store each character
           add r1,r1,#1   			; point to next memory location 
           putc 				; output each character
           add r0, r0 ,#-10 			; check if return/enter key has been entered
           brz checkValue 			; if an enter/return key has been pressed then go to checkValue
           brnzp  loop 				; go back to start of loop until enter/return key has been pressed
stop       halt


checkValue add r2,r2,-2  		        ; check if last character is a digit 0-9 i.e valid
           brz checkIsDigit                     ; if only 1 character, then proceed to check if character is a digit
           brnzp stop				; if more than one character then stop



checkIsDigit ld r3,keyValue
             ld  r4, key0
	     add r5, r3, r4 			; check if number entered is between 0 and 9
	     brn stop                           ; if less than 0, stop, invalid character 
             ld  r4, key9			
	     add r5, r3, r4						
	     brp stop                           ; if greater than 9, stop, invalid character 
	     
outputBinary ld  r3, keyValue        		
             ld  r4, key0
             add r0, r3, r4			; r0 contains a number 0-9
             add r5,r3, r4			; r5 contains number 0-9
             add r0, r0, r0			
             add r0, r0, r0   			; R0 = 5*I (sizeof each entry is 5. 4 characters and zero terminator)
             add r0, r5, r0			
             lea r1, bin0   			; R1 is the address of the beginning of the array (bin0)
             add r0, r0, r1   			; R0 cntains address of the I-th element
             puts			
	     ld r0, newLine		
             putc        
	     brnzp start			; loops back to start and asks user for a number again

enter .stringz "Enter a digit: "

keyValue .blkw 10 #0				; memory to store user input
key0 .blkw 1 #-48				; negative ASCII value of key 0 and 9 for checking valid inputs
key9 .blkw 1 #-57
newLine .blkw 1 #10

bin0 .stringz "0000"
bin1 .stringz "0001"
bin2 .stringz "0010"
bin3 .stringz "0011"
bin4 .stringz "0100"
bin5 .stringz "0101"
bin6 .stringz "0110"
bin7 .stringz "0111"
bin8 .stringz "1000"
bin9 .stringz "1001"

.end