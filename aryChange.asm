; DEEPTI SAHU
; MAKE CHANGES IN printAryElm.asm
;1. IN THE INITIALIZATION PROC USE THE STOS TO CLEAR THE ARRAY
;2. IN THE COUNTING PROC USE LODS INSTRUCTION TO ACCESS THE INPUT STRING CHARACTER
;3. IN THE ADDING PROC USE THE LODS INSTRUCTION TO ACCESS THE ARRAY FOR THE CURRENT STRING
;4. IN MAIN HAVE THE USER TYPE STOP! TO QUIT THE PROGRAM RATHER THAN A NULL STRING,
;5. USE THE CMPS INSTRUCTION TO CHECK THE INPUT STRING

.MODEL SMALL
.586
.STACK    256
    INCLUDE  CIS21JA.INC
CR    EQU  13
LF    EQU  10
TAB    EQU  09
LEN    EQU  26

.CONST
PROMPT1 BYTE  " ENTER A STRING: ",  "$"
CRLF    BYTE  CR,LF,'$'
TABOUT  BYTE  TAB,'$'

.DATA

ARUP    WORD  LEN  DUP(?)
ARLO     WORD  LEN  DUP(?)
ARTOTL    WORD  LEN  DUP(?)
ARTOTU     WORD  LEN  DUP(?)

ININFO_S    LABEL  BYTE
STR_SIZE    EQU      81
ININFO_S    LABEL  BYTE

            BYTE    STR_SIZE
SACT_LEN    BYTE    ?
S_ARRAY    BYTE    STR_SIZE DUP (?)
            BYTE    '$'

STRING1    BYTE    '!STOP!'
STRING2    BYTE    '!stop!'


INT_SIZE    EQU        8

I_ARRAY    BYTE    INT_SIZE DUP(?)
            BYTE    '$'

PRINTLINE  MACRO  NEWLINE
            MOV    AH, 09H
            LEA    DX, NEWLINE
            INT    21H
            ENDM

PROMPT    MACRO  STRING , GET_STR
            MOV      AH, 09H
            LEA      DX, STRING
            INT      21H
        PRINTLINE CRLF
        MOV      AH, 0AH
        LEA      DX, GET_STR
        INT      21H
            ENDM

.CODE

START:
      MOV      AX, @DATA
      MOV      DS, AX
      MOV    ES, AX

      PUSH      LEN
      PUSH      OFFSET ARTOTU
      CALL      INITZERO

      PUSH      LEN
      PUSH      OFFSET ARTOTL
      CALL      INITZERO

MAIN_LOOP:
         
          PROMPT  PROMPT1, ININFO_S
          PRINTLINE CRLF

          PUSH    DS
          POP    ES
          CLD
          MOVZX  AX, SACT_LEN
            LEA  DI, S_ARRAY
            LEA  SI, STRING1
            CMPSW
        JE      DNE

            CLD
          MOVZX  AX, SACT_LEN
            LEA  DI, S_ARRAY
            LEA  SI, STRING2
          CMPSW
        JE      DNE

;================================================================================================================
  ;CALL COUNT
  PRO:
          PUSH  AX
      PUSH    OFFSET S_ARRAY
      PUSH    OFFSET ARLO
      PUSH    OFFSET ARUP
      CALL    COUNT

;=========================================================================================================
  ; CALL PRINTOUT

        MOV    AL, 'A'
        MOVZX  AX, AL
        PUSH    AX
        PUSH    OFFSET    ARUP
        PUSH    OFFSET    I_ARRAY
        CALL    PRINTOUT

        PRINTLINE CRLF
        PRINTLINE CRLF

        MOV    AL, 'a'
        MOVZX  AX, AL
        PUSH      AX
        PUSH    OFFSET    ARLO
        PUSH    OFFSET    I_ARRAY
        CALL    PRINTOUT

        PRINTLINE CRLF
        PRINTLINE CRLF

;=========================================================================================================
; CALL ADDUP

        MOV    BX, 26
        PUSH    BX
        PUSH  OFFSET    ARUP
        PUSH    OFFSET    ARTOTU
        CALL    ADDUP

        PUSH    BX
        PUSH    OFFSET    ARLO
        PUSH    OFFSET    ARTOTL
        CALL    ADDUP

          JMP  MAIN_LOOP

;==========================================================================================================
; END OF PROGRAM:

DNE:
          MOV  AL, 'A'
        MOVZX  AX, AL
    PUSH    AX
    PUSH    OFFSET    ARTOTU
        PUSH    OFFSET    I_ARRAY
        CALL    PRINTOUT

    PRINTLINE CRLF

      MOV  AL, 'a'
        MOVZX  AX, AL
    PUSH    AX
    PUSH    OFFSET    ARTOTL
        PUSH    OFFSET    I_ARRAY
        CALL    PRINTOUT

      PRINTLINE CRLF
      PRINTLINE CRLF

        MOV    AH, 4CH
    INT    21H

;---------------------------------------------------------------------------------------------------------------------
; ADDUP PROC::  ; LODSW  ;LOAD AX WITH A WORD OR AL WITH A BYTE

  ADDUP  PROC    NEAR
        PUSH    BP
        MOV    BP, SP
        PUSH    DI
        PUSH    CX
        PUSH    DS
        POP    ES
        CLD                ;CLEARS DIRECTION FLAG TO 0, FROM LEFT TO RIGHT
    MOV     CX, [BP+ 8] ; CX = ADDRESS OF LEN
        MOV    DI, [BP+4] ;  DI = ADDRESS OF TOT LOWER
        MOV    SI, [BP+6] ; SI = ADDRESS OF TOT UPPER


LABEL1:
                                  ; MOV    AX, WORD PTR [SI]
                                  ;ADD    WORD PTR [DI], AX
        CLD
      LODSW
        ADD    DI, 2
        ADD    SI, 2
        LOOP    LABEL1  ; LOOPING #OF CHAR

        POP      CX
        POP      DI
        POP      BP
        RET      6
ADDUP  ENDP

;==============================================================================================================
; INITIZ PROC:    ; STOSW; STORE  ; INCREMENT DI BY 2 IF ITS A WORD

INITZERO  PROC      NEAR
      PUSH      BP
            MOV      BP, SP
      PUSH      DI
      PUSH      CX
      PUSH    DS
      POP    ES
      CLD
            MOV      DI, [ BP+ 4]  ;  ADDRESS OF THE ARRAY
      MOV      CX, [ BP+ 6]  ; LENGTH OF THE STRING


  TOP:
          CLD
          MOV  AX,  WORD PTR [DI]
          MOV    AX, 0
      STOSW
        LOOP  TOP

      POP      CX
      POP      DI
      POP      BP
          RET      4
INITZERO  ENDP


;=====================================================================================================================

;================================================================================================================
; COUNT PROC:    ; LODS, LOADS AX WITH A WORD


COUNT    PROC      NEAR
      PUSH      BP
      MOV    BP, SP
      PUSH    CX
      PUSH    BX
      PUSH    SI

          PUSH    LEN
      PUSH    OFFSET ARUP
      CALL    INITZERO

      PUSH    LEN
      PUSH    OFFSET ARLO
      CALL    INITZERO

          PUSH  DS
          POP  ES
          CLD
          MOV    CX, [BP + 10]  ; ADDRESS OF LEN
            MOV  DI, [BP + 8]  ; S_ARRAY

COUNTER:

          MOV    BL, BYTE PTR [DI]
      CMP    BL, 'A'
          JB    NEXTCHAR
      CMP    BL, 'Z'
      JBE    CAL_UP
      CMP    BL,'a'
      JB      NEXTCHAR
      CMP    BL, 'z'
      JA    NEXTCHAR
      JMP    CAL_LOW

CAL_UP:

        SUB    BL, 'A'
        MOV    SI, [BP+4]    ; UPPER CASE
        JMP    NEXTPRO

CAL_LOW:

        SUB    BL, 'a'
        MOV    SI, [BP+6]  ; LOWER CASE

NEXTPRO:

        ADD    BL, BL
        ADD    BX, SI
        CLD
        LODSW
        INC    WORD PTR [BX]
NEXTCHAR:

          INC    DI
        LOOP    COUNTER

        POP    SI
        POP    BX
        POP    CX
        POP    BP
        RET    8
COUNT    ENDP



;============================================================================================================

PRINTOUT PROC    NEAR
    PUSH    BP
    MOV    BP, SP
    PUSH    SI
    PUSH    CX
    PUSH    DX
    PUSH    DI

        MOV    CX, 26
        MOV    BL, [BP+ 8]  ; LETTERS AS 'A' OR 'a'
    MOV    SI, [BP+ 6]  ;  ADDRESS OF TOT UP AND LOW
    MOV    DI, [BP+4]  ;  ADDRESS I_ARRAY

LABEL2:

    MOV    DL, BL
        MOV    AH, 02H
        INT    21H

    INVOKE    $UW2ASC,[SI], DI, 8, ' '
       
        MOV    AH, 09H
        MOV    DX, DI
        MOV    AH, 09H
        INT    21H
       
        MOV    DL, ' '
        MOV    AH, 02H
        INT    21H

        MOV    DL, 09H
        MOV    AH, 02H
        INT    21H

        INC    BL
    ADD    SI, 2
    LOOP    LABEL2

    POP    DI
        POP    DX
    POP    CX
    POP    SI
        POP    BP
    RET    6

  PRINTOUT  ENDP

        END    START

