; This is a copy of ZPBASIC and BVARS from basic/declare.s
; if that one changes, this one must change too

.segment "ZPBASIC" : zeropage
linnum	.res 2           ;$14 location to store line number before buf
                         ;    so that "bltuc" can store it all away at once.
                         ;    a comma (preload or from rom)
                         ;    used by input statement since the
                         ;    data pointer always starts on a
                         ;    comma or terminator.

poker	=linnum          ;$14 set up location used by poke
                         ;    temporary for input and read code

tempst	.res 9           ;$19 storage for numtmp temp descriptors


; --- pointers into dynamic data structures ---;
txttab	.res 2           ;$2B pointer to beginning of text.
                         ;    doesn't change after being
                         ;    setup by "init".
frespc	.res 2           ;$35 pointer to new string
inpptr	.res 2           ;$43 this remembers where input is coming from


forpnt	.res 2           ;$49 a variable's pointer for "for" loops
                         ;    and "let" statements
lstpnt	=forpnt          ;$49 pntr to list string
andmsk	=forpnt          ;$49 the mask used by wait for anding
eormsk	=forpnt+1        ;$4A the mask for eoring in wait

; CHRGET
chrget	.res 6           ;$73
chrgot	.res 1           ;$79
.assert * = $EE, error, "cc65 depends on TXTPTR = $EE, change with caution"
txtptr	.res 6           ;$7A
qnum	.res 11          ;$80

.segment "BVARS"
;                      C64 location
;                         VVV
endchr	.res 1           ;$08 the other delimiting character
trmpos	.res 1           ;$09 position of terminal carriage
verck	.res 1           ;$0A CBM: single-use tmp for LOAD
count	.res 1           ;$0B a general counter
dimflg	.res 1           ;$0C in getting a pointer to a variable
                         ;    it is important to remember whether it
                         ;    is being done for "dim" or not.
                         ;    dimflg and valtyp must be
                         ;    consecutive locations.
valtyp	.res 1           ;$0D the type indicator
                         ;    0=numeric 1=string
intflg	.res 1           ;$0E tells if integer
dores	.res 1           ;$0F whether can or can't crunch res'd words YYY
                         ;    turned on when "data"
                         ;    being scanned by crunch so unquoted
                         ;    strings won't be crunched
garbfl	=dores           ;$0F whether to do garbage collection

subflg	.res 1           ;$10 flag whether sub'd variable allowed.
                         ;    "for" and user-defined function
                         ;    pointer fetching turn
                         ;    this on before calling "ptrget"
                         ;    so arrays won't be detected.
                         ;    "stkini" and "ptrget" clear it.
                         ;    also disallows integers there.
inpflg	.res 1           ;$11 flags whether we are doing "input"
                         ;    or "read".

channl	.res 1           ;$13 holds channel number
temppt	.res 1           ;$16 pointer at first free temp descriptor
                         ;    initialized to point to tempst

lastpt	.res 2           ;$17 pointer to last-used string temporary
.assert * = $03E1, error, "cc65 depends on VARTAB = $03E1, change with caution"
vartab	.res 2           ;$2D pointer to start of simple
                         ;    variable space.
                         ;    updated whenever the size of the
                         ;    program changes, set to [txttab]
                         ;    by "scratch" ("new").
arytab	.res 2           ;$2F pointer to beginning of array
                         ;    table.
                         ;    incremented by 6 whenever
                         ;    a new simple variable is found, and
                         ;    set to [vartab] by "clearc".
strend	.res 2           ;$31end of storage in use.
                         ;    increased whenever a new array
                         ;    or simple variable is encountered.
                         ;    set to [vartab] by "clearc".
fretop	.res 2           ;$33 top of string free space
; This instance of `memsiz` is deprecated, and BASIC should now be querying the kernal via `memtop` instead
memsiz	.res 2           ;$37 highest location in memory

; --- line numbers and textual pointers ---:
curlin	.res 2           ;$39 current line #.
                         ;    set to 0,255 for direct statements
oldlin	.res 2           ;$3B old line number (setup by ^c,"stop"
                         ;    or "end" in a program).
oldtxt	.res 2           ;$3D old line number (setup by ^c,"stop"
                         ;    or "end" in a program).
datlin	.res 2           ;$3F data line # -- remember for errors
datptr	.res 2           ;$41 pointer to data. initialized to point
                         ;    at the zero in front of [txttab]
                         ;    by "restore" which is called by "clearc".
                         ;    updated by execution of a "read"
varnam	.res 2           ;$45 variable's name is stored here
opptr	.res 2           ;$4B pointer to current op's entry in "optab"
vartxt	=opptr           ;$4B pointer into list of variables
opmask	.res 1           ;$4D mask created by current operator

four6	.res 1           ;$53 variable constant used by garb collect

jmper	.res 3           ;$54
size	=jmper+1         ;$55
basic_fa .res 1          ;    default device address

.segment "BVARS"
	crambank: .res 1
.segment "BVARSB0"
	crombank: .res 1
    rennew: .res 2
    renold: .res 2
    reninc: .res 2
    rencur: .res 2
    rentmp: .res 2
    rentmp2: .res 2
