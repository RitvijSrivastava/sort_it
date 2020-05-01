;; PROGRAM TO INPUT AN ARRAY AND SORT THE ARRAY

ORG 100H

include 'emu8086.inc'

; Define variables and data
.DATA
    LEN DW 0            ;Store the size of the array
    ARR DW 100 DUP(?)   ;Declare the array with null values    
    
    i DW 0              ; Act as loop variable
    j DW 0              ; Act as loop variable
    
    tmp DW 0            ; Holds temp value      

; Code area starts here
.CODE  

    ; Main Procedure acts as the driver code
    ; Call all other procedures
    MAIN PROC 
        
        CALL take_input         ; Procedure to take input 
        PRINTN 'Sorting...'
        PRINTN
        CALL sort_bubble_asc    ; Procedure to sort the array in ascending order    
        PRINTN 'Array Sorted!'
        PRINTN
        CALL print_array        ; Procedure to print the array
      
    MAIN ENDP

RET  
 
;Procedure to take input
take_input PROC  
    
     PRINT 'Enter the size of the array: '
    CALL scan_num       ; Predefined procedure to call input a number in CX
    MOV LEN,CX
    PRINTN 
    PRINTN
    
    PRINT 'Enter the values of the array: (Press enter after every value)' 
    
    MOV AX, LEN         ; CX acts as the counter for the loop
    AND AX, 0FH         ; Convert from hexadecimal to decimal format  
        
    MOV SI, 0000H   ;SI stores the offset of the arr
    PRINTN                                           
    
    input: 
        CALL scan_num
        MOV ARR[SI] , CX 
        PRINTN
        ADD SI, 2
        SUB AX, 1
        JNZ input  
        
RET             ;Return to caller    
take_input ENDP  

;Procedure to print the array
print_array PROC 
    
    PRINTN
    PRINT 'The Array: '
    PRINTN
    
    MOV SI , 0000H
    MOV CX , LEN
    AND CX, 0FH
    
    array: 
        MOV AX, ARR[SI]
        ADD SI, 2
        CALL print_num
        PRINT ' '
        SUB CX, 1
        JNZ array
    PRINTN
    
RET
print_array ENDP  

;Procedure to BUBBLE SORT the array in ascending order
sort_bubble_asc PROC 
        
        ;SI and DI act as offsets for the ARR. 
        ;SI acts as index for current place and 
        ;DI acts as index for the next value in the array
        
        MOV SI, 0000H     
        MOV DI, 0000H
         
        ; i,j,tmp act as loop variable
        ; i acts the outer loop variable and ranges from LEN - 0
        ; tmp acts as limit to the inner loop ranges from 1 - LEN
        ; j acts as inner loop variable and ranges from (LEN-tmp-1) - 1 
         
        MOV i, 0000
        MOV j, 0000 
        MOV tmp, 0000
        
        ; AX and CX act as temporary storage
        
        MOV AX, 0000H
        MOV CX ,0000H
        
        ; LEN needs to converted into decimal form from hexadecimal to work
        
        MOV AX, LEN
        AND AX, 0FH
        
        MOV i , AX

        outer:
            
            MOV SI, 0000
            MOV DI, 0000
            ADD DI, 2       ; DI always points to the next value in the array
            
            MOV AX, LEN
            AND AX, 0FH
            SUB AX, tmp
            SUB AX, 1
            MOV j, AX
             
            inner: 
                MOV AX, ARR[SI]
                MOV CX, ARR[DI]
                CMP AX, CX   
                
                JLE inc_j   ; Swap if AX > CX
                
                ;;Swapping the numbers using XCHG
                XCHG AX,CX
                MOV ARR[SI], AX
                MOV ARR[DI], CX 
                                
                inc_j:
                 
                   ADD SI, 2
                   ADD DI ,2
                    
                   SUB j , 1 
                   CMP j, 0  
                   
                JG inner
            
            ADD tmp, 1
            SUB i, 1 
            
            JNZ outer
           
RET
sort_bubble_asc ENDP

; Predefined functions
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM_UNS

END