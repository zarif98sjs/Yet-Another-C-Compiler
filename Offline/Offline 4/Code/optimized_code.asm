.MODEL SMALL

.STACK 100H
.DATA
IS_NEG DB ?
FOR_PRINT DW ?
CR EQU 0DH
LF EQU 0AH
NEWLINE DB CR, LF , '$'

.CODE

OUTPUT PROC
               
        MOV CX , 0FH     
        PUSH CX ; marker
        
        MOV IS_NEG, 0H
        MOV AX , FOR_PRINT
        TEST AX , 8000H
        JE OUTPUT_LOOP
                    
        MOV IS_NEG, 1H
        MOV AX , 0FFFFH
        SUB AX , FOR_PRINT
        ADD AX , 1H
        MOV FOR_PRINT , AX

    OUTPUT_LOOP:
    
        ;MOV AH, 1
        ;INT 21H
        
        MOV AX , FOR_PRINT
        XOR DX,DX
        MOV BX , 10D
        DIV BX ; QUOTIENT : AX  , REMAINDER : DX     
        
        MOV FOR_PRINT , AX
        
        PUSH DX
        
        CMP AX , 0H
        JNE OUTPUT_LOOP
        
        ;LEA DX, NEWLINE ; DX : USED IN IO and MUL,DIV
        ;MOV AH, 9 ; AH,9 used for character string output
        ;INT 21H;

        MOV AL , IS_NEG
        CMP AL , 1H
        JNE OP_STACK_PRINT
        
        MOV AH, 2
        MOV DX, '-' ; stored in DL for display 
        INT 21H
            
        
    OP_STACK_PRINT:
    
        ;MOV AH, 1
        ;INT 21H
    
        POP BX
        
        CMP BX , 0FH
        JE EXIT_OUTPUT
        
       
        MOV AH, 2
        MOV DX, BX ; stored in DL for display 
        ADD DX , 30H
        INT 21H
        
        JMP OP_STACK_PRINT

    EXIT_OUTPUT:
    
        ;POP CX 

        LEA DX, NEWLINE
        MOV AH, 9 
        INT 21H
    
        RET     
      
OUTPUT ENDP



main PROC
MOV AX, @DATA
MOV DS, AX
PUSH BP
MOV BP,SP
SUB SP,26
; b=0;
MOV WORD PTR [bp-10],0
MOV CX,[bp-10]
MOV WORD PTR [bp-4],CX
; c=1;
MOV WORD PTR [bp-12],1
MOV CX,[bp-12]
MOV WORD PTR [bp-6],CX
; for(i=0;i<4;i++){a=3;while(a--){b++;}}
MOV WORD PTR [bp-14],0
MOV CX,[bp-14]
MOV WORD PTR [bp-8],CX
L4:
; i<4;
MOV WORD PTR [bp-16],4
MOV AX,[bp-8]
CMP AX,[bp-16]
jl L0
MOV WORD PTR [bp-18],0
JMP L1
L0:
MOV WORD PTR [bp-18],1
L1:
; check for loop condition
CMP [bp-18],0
JE L5
; a=3;
MOV WORD PTR [bp-22],3
MOV CX,[bp-22]
MOV WORD PTR [bp-2],CX
; while(a--){b++;}
L2:
; a--
MOV AX,[bp-2]
MOV WORD PTR [bp-24],AX
DEC WORD PTR [bp-2]
; check while loop condition
CMP [bp-24],0
JE L3
; b++;
MOV AX,[bp-4]
MOV WORD PTR [bp-26],AX
INC WORD PTR [bp-4]
JMP L2
L3:
; i++
MOV AX,[bp-8]
MOV WORD PTR [bp-20],AX
INC WORD PTR [bp-8]
JMP L4
L5:
; printf(a);
MOV AX,[bp-2]
MOV FOR_PRINT,AX
CALL OUTPUT
; printf(b);
MOV AX,[bp-4]
MOV FOR_PRINT,AX
CALL OUTPUT
; printf(c);
MOV AX,[bp-6]
MOV FOR_PRINT,AX
CALL OUTPUT
L_main:
ADD SP,26
POP BP
;DOS EXIT
MOV AH,4ch
INT 21h
main ENDP
END MAIN
