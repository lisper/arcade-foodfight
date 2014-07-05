; Author : Greg Colley
; Date   : 04/12/1998

NUM1    EQU     2
NUM2    EQU     6               ; Loop controll Counter

        ORG     $0
	long	$2000
	long	$1000
	
        ORG     $1000
        MOVE.L #0,D0            ; Set the Data register to 0
        MOVE.L #NUM2,D2         ; Move Num2 (6) to D2

LOOP    ADD.L   #NUM1,D0        ; Add Num1 (2) to D0
        SUBQ.L  #1,D2           ; Take 1 away from D0
        BNE     LOOP            ; Branch if result not Zero

;RESULT IN D0

DONE    STOP    #$2700
	BRA	DONE
        END     $1000

