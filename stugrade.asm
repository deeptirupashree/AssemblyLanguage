;DEEPTI SAHU
; ENTER A STUDENT'S NAME UPTO 60 CHARACTER
; ENTER MAXIMUM POINTS, AN INTEGER
; POINTS FOR THE STUDENT, NOT GREATER THAN MAXIMUM
; IF ERROR IN INPUT OCCUR, PRINT AN APPROPRIATE
MESSAGE AND QUIT
; OTHERWISE COMPUTE AND PRINT THE PERCENTAGE OF
MAXIMUM AND GRADES OF THE STUDENT


.MODEL SMALL

.586
.STACK        256
        INCLUDE  CIS21JA.INC

CR    EQU  13
LF    EQU  10
TAB    EQU  09

.CONST
PROMPT1 BYTE    "ENTER THE STUDENT'S NAME $ "
PROMPT2    BYTE    "ENTER MAXPOINTS $ "
PROMPT3 BYTE    "ENTER STUDENT'S POINT $ "
PROMPT4 BYTE    "ENTER X OR N $ "
PROMPT5 BYTE    "STUDENT'S POINT > MAX $ "
PROMPT6 BYTE    "INVALID CODE $"

CRLF    BYTE    CR,LF,'$'
TABOUT    BYTE    TAB,'$'

HUND    WORD        100

.DATA
MAX        WORD    ?
STPTS        WORD    ?
PERCENT        WORD    ?


CODE        BYTE    ?

STR_SIZE    EQU      61
ININFO_S    LABEL    BYTE
        BYTE    STR_SIZE

SACT_LEN    BYTE    ?    ; NUMBER OF BYTES INPUT,
            ; NOT COUNTING THE ENTER KEY

S_ARRAY    BYTE    STR_SIZE DUP(?)


INT_SIZE    EQU      8
ININFO_I    LABEL    BYTE
        BYTE    INT_SIZE

IACT_LEN    BYTE    ?    ;NUMBER OF BYTES INPUT,

I_ARRAY        BYTE    INT_SIZE DUP(?)
        BYTE    "$"


.CODE
START:
        MOV        AX, @DATA
        MOV    DS, AX

; input string

        MOV        AH, 09H
        MOV    DX, OFFSET PROMPT1
        INT    21H
        MOV    DX, OFFSET ININFO_S
        MOV    AH, 0AH
        INT    21H ; ENTER STUDENT'S NAME
        MOV    DX, OFFSET CRLF
        MOV    AH, 09H
        INT    21H
        MOVZX  BX, SACT_LEN
        MOV    S_ARRAY[BX],'$'
  ; input max

        MOV      AH, 09H
        MOV    DX, OFFSET PROMPT2
        INT    21H      ; ENTER MAXIMUM POINTS

        MOV    AH, 0AH
        MOV    DX, OFFSET ININFO_I
        INT    21H    ;  MAX IS INPUT

        MOV    AH, 09H
        MOV    DX, OFFSET CRLF
        INT    21H
        INVOKE  $ASC2UW, OFFSET I_ARRAY; MAX CONVERTED TO
BINARY
        MOV    MAX, AX

; input STPTS

        MOV        AH, 09H
        MOV      DX, OFFSET PROMPT3
        INT      21H      ; ENTER STPTS

        MOV    AH, 0AH
        MOV    DX, OFFSET ININFO_I
        INT    21H    ;  STPTS IS INPUT

        MOV    AH, 09H
        MOV    DX, OFFSET CRLF
        INT    21H
        INVOKE  $ASC2UW, OFFSET I_ARRAY; STPTS CONVERTED
TO BINARY

        MOV    STPTS, AX


;STU TO MAX

        CMP  AX, MAX
        JNA  PROCESS

ERROR1:
        MOV  AH, 09H
        MOV  DX, OFFSET PROMPT5
        INT  21H
        JMP  ENDPRO
PROCESS:

        MOV        AH, 09H
        MOV    DX, OFFSET PROMPT4
        INT    21H
        MOV    AH, 01H
        INT    21H ; ENTER X OR N
        MOV    CODE, AL

        MOV    DX, OFFSET CRLF
        MOV    AH, 09H
        INT    21H

        CMP  CODE, 'X'
        JE      CAL_XCREDIT
        CMP  CODE, 'x'
        JNE      TRYN

CAL_XCREDIT:
        MOV  BX, 5
        JMP  PRINT_NAME


TRYN:
        CMP    CODE,'N'
        JE    NOCREDIT
        CMP    CODE,'n'
        JE    NOCREDIT
        MOV AH, 09H
        MOV DX, OFFSET PROMPT6
        INT 21H
        JMP ENDPRO

NOCREDIT:
        SUB BX, BX
PRINT_NAME:
        MOV        DX, OFFSET S_ARRAY
        MOV    AH, 09H
        INT    21H

CALC_PERCENT:
        MOV  AX, STPTS
        MUL  HUND
        DIV  MAX
        MOV  PERCENT, AX
        ADD  BX, AX


;START GRADES
;OUTPUT PERCENT
        INVOKE $UW2ASC, PERCENT, OFFSET I_ARRAY,
INT_SIZE, ' '
        MOV      AH, 09H
        MOV    DX, OFFSET I_ARRAY
        INT    21H

        MOV    DX, OFFSET TABOUT
        INT    21H

        MOV    AX, BX
        CMP    AX, 90
        JNAE  TRYB
        MOV    DL, "A"

        JMP    GRADE
TRYB:
        CMP    AX, 80
        JNAE    TRYC
        MOV    DL, "B"
        JMP    GRADE
TRYC :
        CMP    AX, 75
        JNAE    TRYD
        MOV    DL, "C"
        JMP    GRADE
TRYD:
        CMP    AX,70
        JNAE    SETF
        MOV    DL, "D"
        JMP    GRADE
SETF:
        MOV      DL, "F"


GRADE:
        MOV  AH, 02H
        INT  21H


ENDPRO:
        MOV  AH, 09H
        MOV  DX, OFFSET CRLF
        INT  21H
        MOV  DX, OFFSET CRLF
        INT  21H
        MOV    AH, 4CH
        INT  21H
        END  START
; DEEPTI SAHU
; LAB 2
; ENTER A STUDENT'S NAME UPTO 60 CHARACTER
; ENTER MAXIMUM POINTS, AN INTEGER
; POINTS FOR THE STUDENT, NOT GREATER THAN MAXIMUM
; IF ERROR IN INPUT OCCUR, PRINT AN APPROPRIATE MESSAGE AND QUIT
; OTHERWISE COMPUTE AND PRINT THE PERCENTAGE OF MAXIMUM AND GRADES OF THE STUDENT


.MODEL SMALL

.586
.STACK        256
        INCLUDE  CIS21JA.INC

CR    EQU  13
LF    EQU  10
TAB    EQU  09

.CONST
PROMPT1 BYTE    "ENTER THE STUDENT'S NAME $ "
PROMPT2    BYTE    "ENTER MAXPOINTS $ "
PROMPT3 BYTE    "ENTER STUDENT'S POINT $ "
PROMPT4 BYTE    "ENTER X OR N $ "
PROMPT5 BYTE    "STUDENT'S POINT > MAX $ "
PROMPT6 BYTE    "INVALID CODE $"

CRLF    BYTE    CR,LF,'$'
TABOUT    BYTE    TAB,'$'

HUND    WORD        100

.DATA
MAX        WORD    ?
STPTS        WORD    ?
PERCENT        WORD    ?


CODE        BYTE    ?

STR_SIZE    EQU      61
ININFO_S    LABEL    BYTE
        BYTE    STR_SIZE

SACT_LEN    BYTE    ?    ; NUMBER OF BYTES INPUT,
            ; NOT COUNTING THE ENTER KEY

S_ARRAY    BYTE    STR_SIZE DUP(?)


INT_SIZE    EQU      8
ININFO_I    LABEL    BYTE
        BYTE    INT_SIZE

IACT_LEN    BYTE    ?    ;NUMBER OF BYTES INPUT,

I_ARRAY      BYTE    INT_SIZE DUP(?)
      BYTE    "$"


.CODE
START:
        MOV        AX, @DATA
        MOV    DS, AX

; input string
        MOV        AH, 09H
        MOV    DX, OFFSET PROMPT1
        INT    21H
        MOV    DX, OFFSET ININFO_S
        MOV    AH, 0AH
        INT    21H ; ENTER STUDENT'S NAME
        MOV    DX, OFFSET CRLF
        MOV    AH, 09H
        INT    21H
        MOVZX  BX, SACT_LEN
        MOV    S_ARRAY[BX],'$'
  ; input max

        MOV      AH, 09H
        MOV    DX, OFFSET PROMPT2
        INT    21H      ; ENTER MAXIMUM POINTS

        MOV    AH, 0AH
        MOV    DX, OFFSET ININFO_I
        INT    21H    ;  MAX IS INPUT

        MOV    AH, 09H
        MOV    DX, OFFSET CRLF
        INT    21H
        INVOKE  $ASC2UW, OFFSET I_ARRAY; MAX CONVERTED TO BINARY
        MOV    MAX, AX

; input STPTS

        MOV        AH, 09H
        MOV      DX, OFFSET PROMPT3
        INT      21H      ; ENTER STPTS

        MOV    AH, 0AH
        MOV    DX, OFFSET ININFO_I
        INT    21H    ;  STPTS IS INPUT

        MOV    AH, 09H
        MOV    DX, OFFSET CRLF
        INT    21H
        INVOKE  $ASC2UW, OFFSET I_ARRAY; STPTS CONVERTED TO BINARY

        MOV    STPTS, AX


;STU TO MAX

        CMP  AX, MAX
        JNA  PROCESS

ERROR1:
        MOV  AH, 09H
        MOV  DX, OFFSET PROMPT5
        INT  21H
        JMP  ENDPRO
PROCESS:

        MOV        AH, 09H
        MOV    DX, OFFSET PROMPT4
        INT    21H
        MOV    AH, 01H
        INT    21H ; ENTER X OR N
        MOV    CODE, AL

        MOV    DX, OFFSET CRLF
        MOV    AH, 09H
        INT    21H

        CMP  CODE, 'X'
        JE      CAL_XCREDIT
        CMP  CODE, 'x'
        JNE      TRYN

CAL_XCREDIT:
        MOV  BX, 5
        JMP  PRINT_NAME


TRYN:
        CMP    CODE,'N'
        JE    NOCREDIT
        CMP    CODE,'n'
        JE    NOCREDIT
        MOV AH, 09H
        MOV DX, OFFSET PROMPT6
        INT 21H
        JMP ENDPRO

NOCREDIT:
        SUB BX, BX
PRINT_NAME:
        MOV        DX, OFFSET S_ARRAY
        MOV    AH, 09H
        INT    21H

CALC_PERCENT:
        MOV  AX, STPTS
        MUL  HUND
        DIV  MAX
        MOV  PERCENT, AX
        ADD  BX, AX


;START GRADES
;OUTPUT PERCENT
        INVOKE $UW2ASC, PERCENT, OFFSET I_ARRAY, INT_SIZE, ' '
        MOV      AH, 09H
        MOV    DX, OFFSET I_ARRAY
        INT    21H

        MOV    DX, OFFSET TABOUT
        INT    21H

        MOV    AX, BX
        CMP    AX, 90
        JNAE  TRYB
        MOV    DL, "A"

        JMP    GRADE
TRYB:
        CMP    AX, 80
        JNAE    TRYC
        MOV    DL, "B"
        JMP    GRADE
TRYC :
        CMP    AX, 75
        JNAE    TRYD
        MOV    DL, "C"
        JMP    GRADE
TRYD:
        CMP    AX,70
        JNAE    SETF
        MOV    DL, "D"
        JMP    GRADE
SETF:
        MOV      DL, "F"


GRADE:
        MOV  AH, 02H
        INT  21H


ENDPRO:
        MOV  AH, 09H
        MOV  DX, OFFSET CRLF
        INT  21H
        MOV  DX, OFFSET CRLF
        INT  21H
        MOV    AH, 4CH
        INT  21H
        END  START
