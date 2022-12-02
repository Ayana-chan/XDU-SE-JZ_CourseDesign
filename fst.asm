DATA SEGMENT
    strhello DB 'helloworld!$'
    strname DB 'input your name:$'
    strid DB 'input your id:$'
    buffid DB 30,?,30 DUP(0)
    buffname DB 30,?,30 DUP(0)
    strasc DB 'Please input character:$'
    strascans1 DB ' ASCII code of $'
    strascans2 DB ' is: $'
    CRLF DB 0DH,0AH,'$'
DATA ENDS

MYSTACK SEGMENT PARA STACK
    DW  256 DUP(?)
MYSTACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    ;assign dataseg
    MOV AX,DATA
    MOV DS,AX

HELLO:
    LEA DX,strhello
	MOV AH,09H
	INT 21H

    CALL NEXTLINE

PNAME:
	LEA DX,strname
	MOV AH,09H
	INT 21H
	
	LEA DX,buffname
	MOV AH,0AH
	INT 21H

    CALL NEXTLINE

    ;add name's $
    MOV AL,buffname+1   ;str's length
	ADD AL,2
	MOV AH,0
	MOV SI,AX
	MOV buffname[SI],'$'    ;at 1+length+2

    ;output
    MOV DX,OFFSET [buffname+2]
	MOV AH,09H
	INT 21H

	CALL NEXTLINE
	
PID:
	LEA DX,strid
	MOV AH,09H
	INT 21H
	
	LEA DX,buffid
	MOV AH,0AH
	INT 21H
	
    CALL NEXTLINE

    ;add id's $
	MOV AL,buffid+1 ;str's length
	ADD AL,2
	MOV AH,0
	MOV SI,AX
	MOV buffid[SI],'$'  ;SI=length+2
	
    ;output
	MOV DX,OFFSET [buffid+2]
	MOV AH,09H
	INT 21H
	
	CALL NEXTLINE

ASC:
    LEA DX,strasc
	MOV AH,09H
	INT 21H

    ;input a char
	MOV AH,01H
    INT 21H

    MOV BL,AL

    ;'q' to end
    CMP BL,'q'
    JE EXIT

    CALL NEXTLINE

    CALL PRTASC
    JMP ASC


;functions

;print BL's ASCII in binary
PRTASC:
    ;print answer's str
    LEA DX,strascans1
    MOV AH,09H
	INT 21H

    MOV DL,BL
    MOV AH, 02H
    INT 21H
    
    LEA DX,strascans2
    MOV AH,09H
	INT 21H

    ;print ASCII
    MOV CX,8
PTBIT:
    ROL BL,1    ;CF=the highest bit
    JC IS1     
    MOV DL,'0'  ;CF=0
    JMP DISP
IS1:
    MOV DL,'1' ;CF=1
DISP:
    MOV AH, 02H
    INT 21H
    LOOP PTBIT
TORET:
    CALL NEXTLINE

    RET 
;end PRTASC

;print CRLF
NEXTLINE:
    LEA DX,CRLF
	MOV AH,09H
	INT 21H

    RET
;end NEXTLINE

EXIT:
	MOV AH,4CH
	INT 21H
CODE ENDS
END START
END
