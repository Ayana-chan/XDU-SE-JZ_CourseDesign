DATA SEGMENT
    strin DB 'input number (less than 5 charactors): $'
    strout DB 'binary: $'
    strerrnull DB 'ERROR: No Any Input.$'
    strerrcha DB 'ERROR: Too Many Charactors.$'
    strerrnotnum DB 'ERROR: Not a Number.$'
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

BEGIN:
    LEA DX,strin
    MOV AH,09H
	INT 21H

    MOV CX,0005H
    MOV AX,0000H
    MOV BH,00H
    MOV DX,0000H

LINCHR:     ;循环输入五个字符并进行处理

    CALL INCHR

    ;检测回车
    CMP BL,0DH
    JNE CTN
    ;第一个就是回车，报空err
    CMP CX,0005H
    JE ERRNUL
    ;正常的结束输入，开始准备输出
    JMP OUTC

CTN:    ;不是回车，继续处理
    ;检测是否为数字
    CMP BL,30H
    JB ERRNNUM
    CMP BL,39H
    JA ERRNNUM

    ;转真值
    SUB BL,30H

MULTEN:
    ;第一次循环不需要乘十
    CMP CX,0005H
    JE ADDAB

    PUSH BX

    ;乘十
    MOV BX,000AH
    MUL BX

    POP BX

ADDAB:
    ;相加
    ADD AX,BX
    
    JNC ADDNC   ;处理进位，加到DL中
    ADD DL,01H
ADDNC:
    LOOP LINCHR

    ;第六个字符需要输入回车,如果不是回车说明输入过多
    CALL INCHR

    CMP BL,0DH
    JNE ERRCHR

OUTC:   ;输出二进制
OUTDL:
    ;判断是否需要输出DL
    CMP DL,00H
    JE OUTAH

    MOV BL,DL
    CALL OUTBINY

    CALL PTSPACE

    JMP OUTAH1  ;防止DL和AL都非0、AH是0时AH不输出
OUTAH:
    ;判断是否需要输出AH
    CMP AH,00H
    JE OUTAL
OUTAH1:

    MOV BL,AH
    CALL OUTBINY
    
    CALL PTSPACE
OUTAL:
    MOV BL,AL
    CALL OUTBINY
    
    CALL NEXTLINE   ;输出完毕

    JMP BEGIN


;三个报错并回到起点
ERRNNUM:    ;非数字错误
    CALL NEXTLINE

    LEA DX,strerrnotnum
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN

ERRCHR:     ;输入太多字符
    CALL NEXTLINE

    LEA DX,strerrcha
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN

ERRNUL:     ;无数字输入（只输入了回车）
    ; CALL NEXTLINE     ;已经有回车了

    LEA DX,strerrnull
    MOV AH,09H
	INT 21H

    CALL NEXTLINE

    JMP BEGIN


;functions

;读取一个字符并存入BL
INCHR:
    PUSH AX

    MOV AH,01H
    INT 21H

    ;与q和Q比较，相同则退出
    CMP AL,'Q'
    JE EXIT
    CMP AL,'q'
    JE EXIT

    MOV BL,AL

    POP AX
    RET

;输出BL的二进制
OUTBINY:
    PUSH AX
    PUSH CX

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

    POP CX
    POP AX

    RET 
;end OUTBINY

;换行
NEXTLINE:
    PUSH AX

    LEA DX,CRLF
	MOV AH,09H
	INT 21H

    POP AX

    RET
;end NEXTLINE

;添加空格
PTSPACE:
    PUSH AX
    PUSH DX

    MOV DL,' '
    MOV AH, 02H
    INT 21H

    POP DX
    POP AX

    RET
;end PTSPACE

EXIT:
	MOV AH,4CH
	INT 21H
CODE ENDS
END START
END


