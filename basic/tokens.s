	.segment "BASIC"
	jmp init         ;hard reset
	jmp panic        ;soft reset
	.byt "CBMBASIC"
stmdsp	.word end-1
	.word for-1
	.word next-1
	.word data-1
	.word inputn-1
	.word input-1
	.word dim-1
	.word read-1
	.word let-1
	.word goto-1
	.word run-1
	.word if-1
	.word restor-1
	.word gosub-1
	.word return-1
	.word rem-1
	.word cstop-1
	.word ongoto-1
	.word fnwait-1
	.word cload-1
	.word csave-1
	.word cverf-1
	.word def-1
	.word poke-1
	.word printn-1
	.word print-1
	.word cont-1
	.word list-1
	.word clear-1
	.word cmd-1
	.word csys-1
	.word copen-1
	.word cclos-1
	.word get-1
	.word scrath-1
fundsp	.word sgn
	.word int
	.word abs
usrloc	.word usrpok
	.word fre
	.word pos
	.word sqr
	.word rnd
	.word log
	.word exp
	.word cos
	.word sin
	.word tan
	.word atn
	.word peek
	.word len
	.word strd
	.word val
	.word asc
	.word chrd
	.word leftd
	.word rightd
	.word midd
optab	.byt 121
	.word bfaddt-1
	.byt 121
	.word fsubt-1
	.byt 123
	.word bfmultt-1
	.byt 123
	.word bfdivt-1
	.byt 127
	.word bfpwrt-1
	.byt 80
	.word andop-1
	.byt 70
	.word orop-1
negtab	.byt 125
	.word negop-1
nottab	.byt 90
	.word notop-1
ptdorl	.byt 100
	.word dorel-1
q=128-1

;**************************************
stmdsp2	; statements
	.word monitor-1
	.word dos-1
	.word old-1
	.word geos-1
	.word vpoke-1
	.word vload-1
	.word cscreen-1
	.word pset-1
	.word line-1
	.word frame-1
	.word rect-1
	.word char-1
	.word mouse-1
	.word color-1
	.word test-1
	.word reset-1
	.word cls-1
	.word codex-1
	.word locate-1
	.word boot-1
	.word ckeymap-1
	.word bload-1
	.word bvload-1
	.word bvrfy-1
	.word setbank-1
	.word fminit-1
	.word fmnote-1
	.word fmdrum-1
	.word fminst-1
	.word fmvib-1
	.word fmfreq-1
	.word fmvol-1
	.word fmpan-1
	.word fmplay-1
	.word fmchord-1
	.word fmpoke-1
	.word psginit-1
	.word psgnote-1
	.word psgvol-1
	.word psgwav-1
	.word psgfreq-1
	.word psgpan-1
	.word psgplay-1
	.word psgchord-1
	.word reboot-1
	.word poweroff-1
	.word i2cpoke-1
	.word sleep-1
	.word cbsave-1
	.word cmenu-1
	.word cren-1
	.word linputn-1
	.word linput-1
	.word binputn-1
	.word help-1
	.word banner-1

	; functions
ptrfunc	.word vpeek
	.word mx
	.word my
	.word mb
	.word joy
	.word hexd
	.word bind
	.word i2cpeek
	.word pointer
	.word strptr
	.word rptd
ptrend
num_esc_statements = (ptrfunc - stmdsp2) / 2
num_esc_functions = (ptrend - ptrfunc) / 2
;**************************************

reslst	.byt "EN",$c4
endtk	=$80
	.byt "FO",$d2
fortk	=$81
	.byt "NEX",$d4
	.byt "DAT",$c1
datatk	=$83
	.byt "INPUT",$a3
	.byt "INPU",$d4
	.byt "DI",$cd
	.byt "REA",$c4
	.byt "LE",$d4
	.byt "GOT",$cf
gototk	=$89
	.byt "RU",$ce
runtk   =$8a
	.byt "I",$c6
	.byt "RESTOR",$c5
resttk  =$8c
	.byt "GOSU",$c2
gosutk	=$8d
	.byt "RETUR",$ce
	.byt "RE",$cd
remtk	=$8f
	.byt "STO",$d0
	.byt "O",$ce
	.byt "WAI",$d4
	.byt "LOA",$c4
	.byt "SAV",$c5
	.byt "VERIF",$d9
	.byt "DE",$c6
	.byt "POK",$c5
	.byt "PRINT",$a3
	.byt "PRIN",$d4
printk	=$99
	.byt "CON",$d4
	.byt "LIS",$d4
	.byt "CL",$d2
	.byt "CM",$c4
	.byt "SY",$d3
	.byt "OPE",$ce
	.byt "CLOS",$c5
	.byt "GE",$d4
	.byt "NE",$d7
scratk	=$a2
