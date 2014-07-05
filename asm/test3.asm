;; m68000 instruction test #1
;; address and data registers
;; basic loops
;; shifter
;; mul/div
	
        ORG     $0
	long	$1b000
	long	$100
	
        ORG     $100
	;; test basic regs
test1
        MOVE.L #$00000000,D0
        MOVE.L #$80010001,D1
        MOVE.L #$80020002,D2
        MOVE.L #$80030003,D3
        MOVE.L #4,D4
        MOVE.L #5,D5
        MOVE.L #6,D6
        MOVE.L #7,D7

	;; test movem
	move.l	#$14000,a0
	movem.l	d0-d7,(a0)

	;; check reg contents
	cmpi.l	#0,d0
	bne	bad1
	cmpi.l	#$80010001,d1
	bne	bad1
	cmpi.l	#$80020002,d2
	bne	bad1
	cmpi.l	#$80030003,d3
	bne	bad1
	cmpi.l	#4,d4
	bne	bad1
	cmpi.l	#5,d5
	bne	bad1
	cmpi.l	#6,d6
	bne	bad1
	cmpi.l	#7,d7
	bne	bad1

	;; make sure movem worked
	move.l	#$1401c,a0
	move.l	(a0),d0
	cmpi.l	#7,d0
	bne	bad1

	;; test offset
	move.l	#$14000,a0
	move.l	$4(a0),d1
	cmpi.l	#$80010001,d1
	bne	bad1

	;; test offset
	move.l	#$144d6,a0
	move.l	$4(a0),d1

	;; basic loop
test2
        MOVE.L #4,D2
	clr.l	d0
LOOP1   ADD.L   #1,D0
        SUBQ.L  #1,D2
        BNE     LOOP1
	cmpi.l	#4,d0
	bne	bad2

	;; bug
	MOVE.L	#$0000ffff,D7
	moveq	#4,D7
	cmpi.l	#4,d7
	bne	bad2

	;; post inc 1
	move.l	#$14000,a0
	MOVE.L  (A0)+,d0
	MOVE.L  (A0)+,d1
	MOVE.L  (A0)+,d2
	MOVE.L  (A0)+,d3
        cmp.L	#$00000000,D0
	bne	bad2
        cmp.L	#$80010001,D1
	bne	bad2
        cmp.L	#$80020002,D2
	bne	bad2
        cmp.L	#$80030003,D3
	bne	bad2

	;;
	move.l	#$14000,a5
	move.l	#$15000,a3
	move.l	#$15008,a4
	move.w	(a5)+,(a3)+
	move.w	(a5)+,(a3)+
	move.w	(a5)+,(a3)+
	move.w	(a5)+,(a3)+

	cmpa.l	a4,a3
	bne.s	bad2
	
	move.l	#$15000,a0
	MOVE.L  (A0)+,d0
	MOVE.L  (A0)+,d1
        cmp.L	#$00000000,D0
	bne.s	bad2
        cmp.L	#$80010001,D1
	bne.s	bad2

	;;
	move.l	#$14000,a4
	move.l	#$15000,a3
	cmpm	(a4)+,(a3)+
	bne.s	bad2
	cmpm	(a4)+,(a3)+
	bne.s	bad2
	bra.s	test2a

bad2	move.l	#2,d0
	STOP    #$2700
	BRA	bad2

	;; basic loop, post inc a reg
test2a
        MOVE.L	#$0000ffff,D7
	moveq	#4,D7
	move.l	#$14000,a0
loop2	MOVE.L  #$0,(A0)+
	DBF 	D7,loop2

	;; bug
        MOVE.L	#$0000ffff,D1
	tst.w	$958000.l	
	DBF 	D1,test2b
	BRA	bad2
test2b
	cmp.l	#$0000fffe,d1
	bne	bad2
	
	;; movem test
	move.l	#$14000,a0
	move.l	#$fff0,d0
	move.l	#$fff1,d1
	move.l	#$fff2,d2
	move.l	#$fff3,d3
	movem.l	(a0),d0-d3
	cmpi.l	#0,d0
	bne	bad2
	cmpi.l	#0,d1
	bne	bad2
	cmpi.l	#0,d2
	bne	bad2
	cmpi.l	#0,d3
	bne	bad2

	;; predecrement, postincrement
        MOVE.L #$00000000,D0
        MOVE.L #$80010001,D1
        MOVE.L #$80020002,D2
        MOVE.L #$80030003,D3
	
	move.l	#$16000,A0
        move.l  A0,A7
	movem.l	d0/d1/d2,-(a7)
	movem.l	(a7)+,d0/d1/d2

	cmp.L	#$00000000,D0
	bne	bad2
        cmp.L	#$80010001,D1
	bne	bad2
        cmp.L	#$80020002,D2
	bne	bad2
        cmp.L	#$80030003,D3
	bne	bad2

	;; shifter
test3
	move.l	#$aa55,d0
        ASL.L   #4,D0
	cmpi.l	#$aa550,d0
	bne	bad3

	;; shifter
	move.l	#$55aa,d0
        ASR.L   #4,D0
	cmpi.l	#$55a,d0
	bne	bad3

	;; mul
	move.l	#2,d1
	move.l	#12,d0
	muls	d0,d1
	cmpi.l	#24,d1
	bne	bad4

	;; div
	move.l	#144,d1
	move.l	#12,d0
	divs	d0,d1
	cmpi.l	#12,d1
	bne	bad4

	move.l	#0,d0
DONE    STOP    #$2700
	BRA	DONE

bad1	move.l	#1,d0
	STOP    #$2700
	BRA	bad1
	
bad3	move.l	#3,d0
	STOP    #$2700
	BRA	bad3

bad4	move.l	#4,d0
	STOP    #$2700
	BRA	bad4

        END     $1000
