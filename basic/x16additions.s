

VERA_BASE = $9F20

VERA_ADDR_L   	  = (VERA_BASE + $00)
VERA_ADDR_M   	  = (VERA_BASE + $01)
VERA_ADDR_H   	  = (VERA_BASE + $02)
VERA_DATA0        = (VERA_BASE + $03)
VERA_DATA1        = (VERA_BASE + $04)
VERA_CTRL         = (VERA_BASE + $05)

VERA_IEN          = (VERA_BASE + $06)
VERA_ISR          = (VERA_BASE + $07)
VERA_IRQ_LINE_L   = (VERA_BASE + $08)

VERA_DC_VIDEO     = (VERA_BASE + $09)
VERA_DC_HSCALE    = (VERA_BASE + $0A)
VERA_DC_VSCALE    = (VERA_BASE + $0B)
VERA_DC_BORDER    = (VERA_BASE + $0C)

VERA_DC_HSTART    = (VERA_BASE + $09)
VERA_DC_HSTOP     = (VERA_BASE + $0A)
VERA_DC_VSTART    = (VERA_BASE + $0B)
VERA_DC_VSTOP     = (VERA_BASE + $0C)

VERA_L0_CONFIG    = (VERA_BASE + $0D)
VERA_L0_MAPBASE   = (VERA_BASE + $0E)
VERA_L0_TILEBASE  = (VERA_BASE + $0F)
VERA_L0_HSCROLL_L = (VERA_BASE + $10)
VERA_L0_HSCROLL_H = (VERA_BASE + $11)
VERA_L0_VSCROLL_L = (VERA_BASE + $12)
VERA_L0_VSCROLL_H = (VERA_BASE + $13)

VERA_L1_CONFIG    = (VERA_BASE + $14)
VERA_L1_MAPBASE   = (VERA_BASE + $15)
VERA_L1_TILEBASE  = (VERA_BASE + $16)
VERA_L1_HSCROLL_L = (VERA_BASE + $17)
VERA_L1_HSCROLL_H = (VERA_BASE + $18)
VERA_L1_VSCROLL_L = (VERA_BASE + $19)
VERA_L1_VSCROLL_H = (VERA_BASE + $1A)

VERA_AUDIO_CTRL   = (VERA_BASE + $1B)
VERA_AUDIO_RATE   = (VERA_BASE + $1C)
VERA_AUDIO_DATA   = (VERA_BASE + $1D)

VERA_SPI_DATA     = (VERA_BASE + $1E)
VERA_SPI_CTRL     = (VERA_BASE + $1F)

VERA_PSG_BASE     = $1F9C0
VERA_PALETTE_BASE = $1FA00
VERA_SPRITES_BASE = $1FC00

;***************
monitor:
	jsr bjsrfar
	.word $c000
	.byte BANK_MONITOR
	; does not return

;***************
codex:
   jsr bjsrfar
   .word $c000
   .byte BANK_CODEX
	; does not return

;***************
geos: ; syntax error now that GEOS is gone
	ldx #errsn
	jmp error

;***************
color	jsr getcol ; fg
	lda coltab,x
	jsr bsout
	jsr chrgot
	bne :+
	rts
:	jsr chkcom
	jsr getcol ; bg
	lda #1 ; swap fg/bg
	jsr bsout
	lda coltab,x
	jsr bsout
	lda #1 ; swap fg/bg
	jmp bsout


getcol	jsr getbyt
	cpx #16
	bcc :+
	jmp fcerr
:	rts

coltab	;this is an unavoidable duplicate from KERNAL
	.byt $90,$05,$1c,$9f,$9c,$1e,$1f,$9e
	.byt $81,$95,$96,$97,$98,$99,$9a,$9b

;***************
; convert byte to binary in zero terminated string and
; return it to BASIC
bind:	jsr chrget ; get char
	jsr chkopn ; check opening paren
	jsr frmadr ; get 16 bit word in Y/A
; lofbuf starts at address $00FF and continues into
; page 1 ($0100).
; Forcing address size to 16bit allows us to cross
; from zero page to page $01 when using .X as an index
	ldx #0
	phy	   ; save low byte
	tay	   ; save high byte to check for 0 later
	cmp #0
	bne @LOOP
	pla
@LOOP:	asl	   ; high bit to carry
	pha	   ; save .A for next iteration
	lda #'1'
	bcs :+
	dec
:	sta a:lofbuf,X
	pla	   ; restore .A
	inx
	cpy #0
	bne :+
	cpx #8
	bne @LOOP
	bra @DONE
:	cpx #8
	bcc @LOOP
	bne :+
	pla
:	cpx #16
	bne @LOOP
@DONE:	stz a:lofbuf,X ; zero terminate string
	jsr chkcls ; end of conversion, check closing paren
	pla        ; remove return address from stack
	pla
	jmp strlitl; allocate and return string value from lofbuf

;***************
; convert byte to hex in zero terminated string and
; return it to BASIC
hexd:	jsr chrget ; get char
	jsr chkopn ; check opening paren
	jsr frmadr ; get 16 bit word in Y/A
	ldx #0	   ; use .X for indexing
	phy	   ; Save low byte
	cmp #0	   ; If high-byte is 0, we only convert low byte
	beq @LOWBYTE
	jsr byte_to_hex_ascii
	sta a:lofbuf,X
	tya
	inx
	sta a:lofbuf,X
	inx
@LOWBYTE:
	pla	   ; restore low byte
	jsr byte_to_hex_ascii
	sta a:lofbuf,X
	tya
	inx
	sta a:lofbuf,X
	inx
	stz a:lofbuf,X
	jsr chkcls ; end of conversion, check closing paren
	pla        ; remove return address from stack
	pla
	jmp strlitl; allocate and return string value from lofbuf

; convert byte into hex ASCII in A/Y
; copied from monitor.s
byte_to_hex_ascii:
	pha
        and     #$0F
        jsr     @LBCC8
        tay
        pla
        lsr
        lsr
        lsr
        lsr
@LBCC8: clc
        adc     #$F6
        bcc     @LBCCF
        adc     #$06
@LBCCF: adc     #$3A
        rts

;***************
vpeek	jsr chrget
	jsr chkopn ; open paren
	jsr getbyt ; byte: bank
	phx
	jsr chkcom
	lda poker
	pha
	lda poker + 1
	pha
	jsr frmadr ; word: offset
	sty VERA_ADDR_L
	sta VERA_ADDR_M
	pla
	sta poker + 1
	pla
	sta poker
	pla
	sta VERA_ADDR_H
	jsr chkcls ; closing paren
	ldy VERA_DATA0
	jmp sngflt

;***************
vpoke	jsr getbyt ; bank
	phx
	jsr chkcom
	jsr getnum
	pla
	sta VERA_ADDR_H
	lda poker
	sta VERA_ADDR_L
	lda poker+1
	sta VERA_ADDR_M
	stx VERA_DATA0
	rts

;***************
bvrfy
	lda #1
	bra :+
bload
	lda #0
:	pha
	jsr plsvbin
	bcc bload2
	pla
	bcs :+
bload2
	jmp cld8        ; -> load command w/ ram bank switch to chosen bank

vload	jsr plsv        ;parse the parameters
	bcc vld1        ;require bank/addr
:	jmp snerr

bvload	jsr plsvbin	;parse, with SA=2 if successful
	bcs :-

vld1	lda andmsk      ;bank number
	adc #2
	jmp cld10       ;jump to load command

;***************
old	beq old1
	jmp snerr
old1	lda txttab+1
	ldy #1
	sta (txttab),y
	jsr lnkprg
	clc
	lda index
	adc #2
	sta vartab
	lda index+1
	adc #0
	sta vartab+1
	ldx #stkend-256 ;set up end of stack
	txs
	jmp ready

; ----------------------------------------------------------------
; XXX This is very similar to the code in MONITOR. When making
; XXX changes, have a look at both versions!
; ----------------------------------------------------------------
;***************
dos	beq ptstat      ;no argument: print status
	jsr frmevl
	bit valtyp
	bmi @str
; numeric
	jsr getadr
	cmp #0          ;lo
	beq :+
@fcerr	jmp fcerr
:	cpy #8           ;hi
	bcc @fcerr
	cpy #32
	bcs @fcerr
	tya
	jmp dossw

@str	jsr frefac      ;get ptr to string, length in .a
	cmp #0
	beq ptstat      ;no argument: print status
	sta verck       ;save length
	ldx index1
	ldy index1+1
	jsr setnam
	ldy #0
	lda (index1),y
; dir?
	cmp #'$'
	beq disk_dir
; switch default drive?
	cmp #'8'
	beq dossw
	cmp #'9'
	beq dossw

;***************
; DOS command
	sec
	jsr listen_cmd
	ldy #0
:	lda (index1),y
	jsr iecout
	iny
	cpy verck       ;length?
	bne :-
	jsr unlstn
	lda curlin+1
	inc
	beq ptstat
	rts

; in:  C=1 show "DEVICE NOT PRESENT" on error
;      C=0 return error in C
; out: C=0 no error
;      C=1 error
listen_cmd:
	php
	jsr getfa
	jsr listen
	lda #$6f
	jsr second
	jsr readst
	bmi @error
	plp
	clc
	rts
@error:	plp
	bcs device_not_present
	sec
	rts
device_not_present:
	ldx #5 ; "DEVICE NOT PRESENT"
	jmp error


clear_disk_status:
	clc
	bra ptstat2
;***************
; print status
ptstat	sec
ptstat2	php
	; keep C:
	; for printing status, print error
	; for clearing status, return error
	jsr listen_cmd
	bcc :+
	plp
	rts
:	jsr unlstn
	jsr getfa
ptstat3	jsr talk
	lda #$6f
	jsr tksa
dos11	jsr iecin
	beq dos0
	plp
	php
	bcc :+
	jsr bsout
:	cmp #13
	bne dos11
dos0	plp
	jmp untalk

;***************
; switch default drive
dossw	sta basic_fa
	rts

getfa:
	lda #8
	cmp basic_fa
	bcs :+
	lda basic_fa
:	rts


;***************
;  read & display the disk directory

LOGADD = 15

disk_dir
	jsr getfa
	tax
	lda #LOGADD     ;la
	ldy #$60        ;sa
	jsr setlfs
	jsr open        ;open directory channel
	jsr readst
	bpl :+
	lda #LOGADD
	jsr close
	jmp device_not_present
:	ldx #LOGADD
	jsr chkin       ;make it an input channel

	jsr crdo

	ldy #4          ;first pass only- trash first four bytes read

@d20
@d25	jsr basin
	jsr readst
	bne disk_done   ;...branch if error
	dey
	bne @d25        ;...loop until done

	jsr basin       ;get # blocks low
	pha
	jsr readst
	tay
	pla
	cpy #0
	bne disk_done   ;...branch if error
	tax
	jsr basin       ;get # blocks high
	pha
	jsr readst
	tay
	pla
	cpy #0
	bne disk_done   ;...branch if error
	jsr linprt      ;print # blocks

	lda #' '
	jsr bsout       ;print space  (to match loaded directory display)

	ldy #0
@d30	jsr basin       ;read & print filename & filetype
	beq @d40        ;...branch if eol
	pha
	jsr readst
	tax
	pla
	cpx #0
	bne disk_done   ;...branch if error
	bit mode
	bvs @d30out     ; ISO mode
	cmp #$22
	beq @d30qtsw    ; quotation mark
	cpy #0
	beq @d30out     ; not inside of quotes
	cmp #$60
	bcc @d30out     ; is unshifted character
	cmp #$80
	bcc @d30sub20   ; shifted character, subtract $20
	cmp #$e0
	bcs @d30ques    ; unprintable, show ?
	bra @d30out     ; the rest are valid PETSCII
@d30sub20
	sec
	sbc #$20
@d30out
	jsr bsout
	bra @d30

@d40	jsr crdo        ;start a new line
	jsr stop
	beq disk_done   ;...branch if user hit STOP
	ldy #2
	bra @d20
@d30qtsw ; toggle y between 0 and 1 to indicate whether we're inside quotes
	cpy #0
	beq :+
	dey
	dey
:	iny
	bra @d30out
@d30ques
	lda #'?'
	bra @d30out

disk_done
	jsr clrch
	lda #LOGADD
	sec
	jmp close

; like getbyt, but negative numbers will become $FF
getbytneg:
	jsr frmnum      ;get numeric value into FAC
	lda facsgn
	bpl @pos
	ldx #$ff
	rts
@pos:	jmp conint      ;convert to byte

;***************
mouse:
	jsr getbytneg
	phx
	sec
	jsr screen_mode
	pla
	jmp mouse_config

;***************
mx:
	jsr chrget
	ldx #fac
	jsr mouse_get
	lda fac+1
	ldy fac
	jmp givayf0

;***************
my:
	jsr chrget
	ldx #fac
	jsr mouse_get
	lda fac+3
	ldy fac+2
	jmp givayf0

;***************
mb:
	jsr chrget
	ldx #fac
	jsr mouse_get
	tay
	jmp sngflt

;***************
joy:
	jsr chrget
	jsr chkopn ; open paren
	jsr getbyt ; byte: joystick number (0-4)
	cpx #5
	bcc :+
	jmp fcerr
:	phx
	jsr chkcls ; closing paren
	pla
	jsr joystick_get
	iny
	bne :+
	lda #<minus1 ; not present?
	ldy #>minus1 ; then return -1
	jmp movfm
:	eor #$ff
	tay
	txa
	eor #$ff
	lsr
	lsr
	lsr
	lsr
	jmp givayf0

minus1:	.byte $81, $80, $00, $00, $00

;***************
reboot:
	ldx #5
:	lda reboot_copy,x
	sta $0100,x
	dex
	bpl :-
	jmp $0100

reboot_copy:
	stz rom_bank
	jmp ($fffc)

;***************
cls:
	lda #$93
	jmp outch

;***************
locate:
	jsr screen
	stx poker
	sty poker+1

	jsr getbyt ; byte: line
	php
	dex
	bmi @error
	cpx poker+1
	bcs @error
	plp
	phx
	bne @1

; just set the line, leave the column the same
	sec
	jsr plot
	bra @2

@1:	jsr chkcom
	jsr getbyt
	txa
	tay
	dey
	bmi @error
	cpy poker
	bcs @error

@2:	plx
	clc
	jmp plot

@error:
	jmp fcerr

;***************
ckeymap:
	jsr frmstr
	cmp #10
	bcs @fcerr
	tay
	lda #0
	sta a:lofbuf,y  ;make a copy, so we can
	dey             ;zero-terminate it
:	lda (index1),y
	sta a:lofbuf,y
	dey
	bpl :-
	ldx #<lofbuf
	ldy #>lofbuf
	clc
	jsr keymap
	bcs @fcerr
	rts
@fcerr:	jmp fcerr

setbank:
	jsr getbyt
	stx crambank
	jsr chrgot
	beq @done
	jsr chkcom
	jsr getbyt
	stz ram_bank
	stx crombank
@done:
	lda crambank
	sta ram_bank
	rts

;***************
;Clears the flag set when the 40/80 key (=Scroll Lock) is pressed
;This function is intended to be called when the Kernal enters/returns
;to the BASIC editor to prevent 40/80 key
;presses during program execution to take effect
clear_4080_flag:
	stz ram_bank
	lda shflag
	and #255-32
	sta shflag
	lda crambank
	sta ram_bank
	rts

;***************
test:
	beq @test0
	jsr getbyt
	txa
	cmp #4
	bcc @run
	jmp fcerr

@test0:	lda #0
@run:
	pha	; index
	ldx #@copy_end-@copy-1
:	lda @copy,x
	sta $0400,x
	dex
	bpl :-
	jmp $0400

@copy:
	sei
	lda #BANK_DEMO
	sta rom_bank
	lda #<$c000
	sta 2
	lda #>$c000
	sta 3
	lda #<$1000
	sta 4
	lda #>$1000
	sta 5
	ldx #$40
	ldy #0
:	lda (2),y
	sta (4),y
	iny
	bne :-
	inc 3
	inc 5
	dex
	bne :-
	lda #$6c
	sta $0400
	pla
	asl
	sta $0401
	lda #$10
	sta $0402
	stz rom_bank
	cli
	jmp $0400
@copy_end:

uc_address = $42

; reset/poweroff: trigger system reset/poweroff via i2c to smc
reset:
	ldy #2
	bra :+
poweroff:
	ldy #1
:
	lda #0
	ldx #uc_address
	jmp i2c_write_byte

; I2CPOKE <address>,<register>,<value>
i2cpoke:
	jsr getbyt
	phx
	jsr chkcom
	jsr getbyt
	phx
	jsr chkcom
	jsr getbyt
	txa
	ply
	plx
	jsr i2c_write_byte
	bcc :+
i2cerr:
	ldx #errnp ; not present
	jmp error
:
	rts

; I2CPEEK(address,register)
i2cpeek:
	jsr chrget
	jsr chkopn ; open paren
	jsr getbyt ; byte: device/address
	phx
	jsr chkcom
	jsr getbyt ; byte: register number
	phx
	jsr chkcls ; close paren
	ply
	plx
	jsr i2c_read_byte
	bcs i2cerr
	tay
	jmp sngflt

; SLEEP <jiffies>
sleep:
	bne @val
	ldy #0
	ldx #0
	bra @slp
@val:
	jsr frmadr
	ldy poker
	ldx poker+1
@slp:
	bannex_call bannex_sleep_cont
@end:
	rts

; BSAVE "FILENAME",<device>,<bank>,<start address>,<end address>
cbsave:
	jsr plsvbin     ;parse file-related parms up to and including start address
	bcs @error      ;require bank/address parms
	; Preserve the start address
	ldx poker
	phx
	ldy poker+1
	phy
	jsr chkcom
	jsr frmadr
	ldx andmsk      ;switch to the requested bank
	stx ram_bank
	ldx poker
	ldy poker+1
	pla
	sta poker+1
	pla
	sta poker
	lda #<poker
	jsr bsave       ;save it headerless
	bcc :+
	ldx #errfnf
	jmp error
@error:
	ldx #errsn
	jmp error
:	rts


cmenu:
	jsr bjsrfar
	.word $c000
	.byte BANK_UTIL
	jsr stkini
	jmp readyx

; REN [newstart[,increment[,oldstart]]]
; line renumber
cren:
	lda curlin+1
	inc
	beq @imm ; ensure renumber only happens in direct mode
	ldx #errid
	jmp error
@imm:
	stz ram_bank
	lda #10
	sta rennew
	stz rennew+1
	sta reninc
	stz reninc+1
	stz renold
	stz renold+1

	jsr chrgot
	beq @go

	jsr frmadr
	lda poker
	sta rennew
	lda poker+1
	sta rennew+1

	jsr chrgot
	beq @go

	jsr chkcom
	jsr frmadr
	lda poker
	sta reninc
	lda poker+1
	sta reninc+1

	jsr chrgot
	beq @go

	jsr chkcom
	jsr frmadr
	lda poker
	sta renold
	lda poker+1
	sta renold+1

@go:
	; make sure rennew < 65280
	lda rennew+1
	inc
	beq @errlin
	; make sure reninc > 0.
	lda reninc+1
	bne @startok
	lda reninc
	bne @startok
@errlin:
	ldx #errfc
	jmp error
@startok:
	bannex_call bannex_renumber
	bcs @fail
	; resets table pointers and return to BASIC
	jmp cleart
@fail:
	jsr cleart
	ldx #errov
	jmp error

;******************************************************************
;
; STRPTR(var_name) - return address of string for var_name
;
;******************************************************************
strptr:
	jsr pointer
	lda poker       ; valtyp saved
	beq type_err
	jsr getadr0
	cmp #0
	beq @null
	ldy #1
	lda (poker),y
	sta facho+1
	iny
	lda (poker),y
	sta facho
	bra ptr3
@null:
	rts             ;let the zero stand

;******************************************************************
;
; POINTER(var_name) - return address of descriptor for var_name
; adapted from BASIC_C128_04/pointer.src
;
;******************************************************************
pointer:
	jsr chrget
	jsr chkopn      ;test for open paren
	jsr isletc      ;test if character follows parens
	bcc syntax_err  ;...syntax error if not.
	jsr ptrget      ;look for this varname in table
	ldx valtyp
	stx poker       ;stashing it here temporariliy
	cmp #>zero      ;is this a dummy pointer (system variable)?
	bne ptr2
	lda #0          ;if so, return 0
	tay
ptr2:
	sty facho
	sta facho+1
	jsr chkcls      ;look for closing paren
ptr3:
	jmp gu16fc      ;get the unsigned PTR value into FAC

line_delimeter = poker
check_delimiter = poker+1
err_on_max_string = poker+1

syntax_err:
	jmp snerr       ;syntax error
type_err:
	jmp chkerr      ;this calls error with errtm

; utility subroutine with two entry points
; for BINPUT#, LINPUT# and LINPUT
ninput_common:
	jsr getbyt
	stx channl
	jsr chkin
	bcs gen_err
	jsr chkcom
linput_common:
	jsr isletc      ;test for alpha character
	bcc syntax_err  ;...syntax error if not.
	jsr ptrget      ; get pointer of variable into A/Y
	ldx valtyp      ; make sure it's a string variable
	beq type_err    ; it's numeric, we don't handle that
	sta forpnt
	sty forpnt+1    ; stash variable pointer
	lda #13
	sta line_delimeter
	lda #$c0
	sta check_delimiter
	rts


;******************************************************************
;
; BINPUT# <channel>, <string var_name>, <size>
; reads a block of text from an open file of at most <size> bytes
;
;******************************************************************
binputn:
	jsr ninput_common
	stz check_delimiter

	jsr chkcom
	jsr getbyt
	txa
	beq iq_err
	bra in2var

;******************************************************************
;
; LINPUT# <channel>, <string var_name>[, <delimiter>]
; reads a line of text from an open file, with an arbitrary
; delimiter. 13 (CR) is the default delimiter.
;
;******************************************************************
linputn:
	jsr ninput_common
	jsr chrgot
	beq :+
	jsr chkcom
	jsr getbyt
	stx line_delimeter
:

	lda #255
	bra in2var

iq_err:
	lda #errfc
gen_err:
	tax
	jmp error


;******************************************************************
;
; LINPUT <string var_name> - reads a line of text via the keyboard
; (or more specifically, calls `basin` to retrieve a line of text)
;
;******************************************************************
linput:
	jsr linput_common
	lda #buflen

in2var:             ; input (line or block) to var
	sta size        ; store max length
	jsr strspa      ; allocate string space

	ldy #0
in2varc:
	jsr basin
	bit check_delimiter
	bvc in2sto
	cmp line_delimeter
	beq in2done
in2sto:
	sta (dsctmp+1),y
	iny
	ldx channl
	beq in2noch
	jsr readst
	and #$40
	bne in2done
in2noch:
	cpy size
	bcc in2varc
	bit err_on_max_string
	bpl in2done

	ldx #errls      ;string too long error
	jmp error
in2done:
	tya
	sta (forpnt)
	ldy #1
	lda dsctmp+1
	sta (forpnt),y
	iny
	lda dsctmp+2
	sta (forpnt),y
	lda channl
	beq :+
	jsr clrch
	stz channl
	rts
:	lda line_delimeter
	jmp bsout


;******************************************************************
;
; RPT$(<byte>,<count>) - returns a string comprised of
; <byte> repeated <count> times.  Byte is a value from 0-255
;
;******************************************************************

rptd:
	jsr chrget
	jsr chkopn      ;test for open paren
	jsr getbyt
	phx             ;preserve character byte
	jsr chkcom
	jsr getbyt
	jsr chkcls
	txa             ;count = A
	beq iq_err      ;zero count makes no sense
	jsr strspa      ;allocate the string of length A
	ldy #0
	pla             ;A = the byte to be repeated
@1:
	sta (dsctmp+1),y
	iny
	cpy dsctmp
	bcc @1
	pla
	pla
	jmp putnew      ;return the string literal to BASIC

help:
	bannex_call bannex_help
	rts

banner:
	bannex_call bannex_splash
	rts

; BASIC's entry into jsrfar
.setcpu "65c02"
.export bjsrfar
bjsrfar:
.include "jsrfar.inc"
