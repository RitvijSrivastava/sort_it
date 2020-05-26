; Author: Ritvij Srivastava (ritvijsrivastava99@gmail.com)

;; PROGRAM TO INPUT AN ARRAY AND SORT THE ARRAY

ORG 100H

include 'emu8086.inc'

;; Define variables for the array
.DATA
    LEN DW 0            ;Store the size of the array
    ARR DW 100 DUP(?)   ;Declare the array with null values    
    
    i DW 0              ; Act as loop variable
    j DW 0              ; Act as loop variable
    
    tmp DW 0            ; Holds temp value      
                                   
                                           
;; Code area starts here
.CODE  

    ; Main Procedure acts as the driver code
    ; Call all other procedures
    MAIN PROC 
        
        
        CALL take_input         ; Procedure to take input 
        
        PRINTN
        CALL asc_or_desc
        PRINTN 
        PRINTN
        CALL selection_or_bubble
        PRINTN
        PRINTN 
        PRINTN 'Sorting...'
        PRINTN
        ;CALL sort_bubble_asc    ; Procedure to sort the array in ascending order    
        PRINTN 'Array Sorted!'
        PRINTN
        CALL print_array        ; Procedure to print the array
      
    MAIN ENDP

RET   

;; Procedure to choose between selection sort and bubble sort
selection_or_bubble PROC
   PRINT 'Choose 1 for Bubble sort and 2 for Selection Sort: '
   CALL scan_num
   MOV BX, 0000H
   MOV BX, CX
   CMP BX, 01H      
   JE BUBBLE        ; If 1 then bubble sort
   CMP AX, 01H
   JE ASC_SEL       ; Check if ascending or descending
   CALL sort_select_desc
   RET
   ASC_SEL: 
        CALL sort_select_asc
        RET
   BUBBLE: 
        CMP AX, 01H      ; Check if ascending or descending    
        JE ASC_BUB  
        CALL sort_bubble_desc
        RET
        ASC_BUB: 
            CALL sort_bubble_asc
            RET 
   
RET
selection_or_bubble ENDP
    

;; Procedure to choose between ascending and descending
asc_or_desc PROC
    PRINT 'Choose 1 for Ascending order and 2 for Descending order: '
    CALL scan_num     ; Predefined procedure to input a number in CX
    MOV AX, 0000H
    MOV AX, CX
    ;CMP AX, 01H
    
    ;JE ASC
    ;CALL sort_bubble_desc
    ;RET
    ;ASC: CALL sort_bubble_asc
     
RET
asc_or_desc ENDP    
 
;; Procedure to take input
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

; Procedure to BUBBLE SORT in Descending order
sort_bubble_desc PROC
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

        outerr:
            
            MOV SI, 0000
            MOV DI, 0000
            ADD DI, 2       ; DI always points to the next value in the array
            
            MOV AX, LEN
            AND AX, 0FH
            SUB AX, tmp
            SUB AX, 1
            MOV j, AX
             
            innerr: 
                MOV AX, ARR[SI]
                MOV CX, ARR[DI]
                CMP CX, AX   
                
                JLE incr_j   ; Swap if CX > AX
                
                ;;Swapping the numbers using XCHG
                XCHG AX,CX
                MOV ARR[SI], AX
                MOV ARR[DI], CX 
                                
                incr_j:
                 
                   ADD SI, 2
                   ADD DI ,2
                    
                   SUB j , 1 
                   CMP j, 0  
                   
                JG innerr
            
            ADD tmp, 1
            SUB i, 1 
            
            JNZ outerr
           
RET
sort_bubble_desc ENDP   

;; Procedure to SELECTION SORT in Ascending order
sort_select_asc PROC
   MOV SI, 0000H
   MOV DI, 0000H
                
   MOV AX, 0000H
   MOV BX, 0000H  
   MOV CX, 0000H
   MOV i, 0000H
   MOV j, 0000H
   
   loop_outer:
       MOV BX, SI      ; BX stores the minimum index of the Array
       MOV AX, i   
       
       MOV j , AX
       ADD j , 1  
       
       MOV DI, SI
       ADD DI, 2   
       
       loop_inner:  
            
           MOV AX, ARR[BX]
           MOV CX, ARR[DI]
           CMP AX, CX                   ; If (ARR[DI] < ARR[BX]) then set the min index
           JLE cont_j
           
           ; Set the minimum index
           MOV BX, DI 
           
           cont_j:
              ADD DI, 2                   ; Increment DI
                
              ADD j, 1 
              MOV AX, LEN 
              CMP j, AX
              
              JL loop_inner      ; j < LEN; then continue inner loop     
           
           ;Swap values at SI and BX
           MOV AX, ARR[SI]
           MOV CX, ARR[BX]
           XCHG AX, CX
           MOV ARR[SI], AX
           MOV ARR[BX], CX  
           
           ADD SI, 2            ; Increment SI
           ADD i, 1    
           
           MOV AX, LEN
           SUB AX , 1
           CMP i , AX
           
           JL loop_outer   
         
    
RET
sort_select_asc ENDP

;; Procedure to SELECTION SORT in Descending order 
sort_select_desc PROC
   MOV SI, 0000H
   MOV DI, 0000H            
   MOV AX, 0000H
   MOV BX, 0000H  
   MOV CX, 0000H
   MOV i, 0000H
   MOV j, 0000H
   
   loop_outerr:
       MOV BX, SI      ; tmp stores the minimum index of the Array    
       
       MOV AX, i
       MOV j , AX
       ADD j , 1
       
       MOV DI, SI
       ADD DI, 2
       
       loop_innerr:  
            
           MOV AX, ARR[BX]
           MOV CX, ARR[DI]
           CMP CX, AX                   ; If (ARR[BX] < ARR[DI]) then set the min index
           JLE continue_j
           
           ; Set the minimum index
           MOV BX, DI 
           
           continue_j:
              ADD DI, 2                   ; Increment DI
                
              ADD j, 1 
              MOV AX, LEN 
              CMP j, AX
              
              JL loop_innerr      ; j < LEN; then continue inner loop     
           
           ;Swap values at SI and BX
           MOV AX, ARR[SI]
           MOV CX, ARR[BX]
           XCHG AX, CX
           MOV ARR[SI], AX
           MOV ARR[BX], CX  
           
           ADD SI, 2            ; Increment SI
           ADD i, 1  
           
           MOV AX, LEN
           SUB AX , 1
           CMP i , AX
           
           JL loop_outerr        ; i < LEN - 1 then continue outer loop
RET
sort_select_desc ENDP

; Predefined functions
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_SCAN_NUM
DEFINE_PRINT_NUM_UNS

END