;===============================================================================
; VT220 Emulation and Video Generation
;-------------------------------------------------------------------------------
; Copyright (C)2012-2014 HandCoded Software Ltd.
; All rights reserved.
;
; This software is the confidential and proprietary information of HandCoded
; Software Ltd. ("Confidential Information").  You shall not disclose such
; Confidential Information and shall use it only in accordance with the terms
; of the license agreement you entered into with HandCoded Software.
;
; HANDCODED SOFTWARE MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE
; SUITABILITY OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
; LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
; PARTICULAR PURPOSE, OR NON-INFRINGEMENT. HANDCODED SOFTWARE SHALL NOT BE
; LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING
; OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
;-------------------------------------------------------------------------------
;
; Notes:
;
;
;
;===============================================================================
; Revision History:
;
; 2012-12-31 AJ Initial version
;-------------------------------------------------------------------------------
; $Id: Video.s 30 2014-05-31 21:01:09Z andrew $
;-------------------------------------------------------------------------------

        .include "Hardware.inc"
        .include "VT220.inc"

;===============================================================================
; Macros
;-------------------------------------------------------------------------------

        .macro  DELAY,USEC,DEDUCT
        repeat  #((\USEC * (FOSC / 1000000)) / 2 - \DEDUCT) - 1
        nop
        .endm

;===============================================================================
; Data Areas
;-------------------------------------------------------------------------------

        .section nbss,bss,near
TICKS:  .space  2                       ; Counts the number of 8Hz interrupts
STATE:  .space  2                       ; The index into the state table

TOPSCN: .space  2                       ; The top most scanline 0-9

ROWPTR: .space  2                       ; Pointer to row table               
ROWSCN: .space  2                       ; The scanline being drawn

        .section bss,bss

; The actual screen data  

SCREEN: .space  2 * COLS * (ROWS + 1)

; The status bar along the bottom of the screen

        .global STATUS
STATUS: .space  2 * COLS

; A table of row type and row address for each of the 24 rows of visible data
; and the off-screen scroll row.

        .global ROWTAB
ROWTAB: .space  4 * ROWS
        .global ROWEND
ROWEND: .space  4

; Pixel output buffer area (with extra space for first and last dummy pixels)

BUFFER: .space  2 * (COLS + 2)

;-------------------------------------------------------------------------------

; The font glyphs organised by scanline (repeated twice) to accomodate under-
; lining.

        .section glyphs,bss,align(256)

GLYPH0: .space  1024
GLYPH1: .space  1024
GLYPH2: .space  1024
GLYPH3: .space  1024
GLYPH4: .space  1024
GLYPH5: .space  1024
GLYPH6: .space  1024
GLYPH7: .space  1024
GLYPH8: .space  1024
GLYPH9: .space  1024

;===============================================================================
; Video Generation
;-------------------------------------------------------------------------------

        .equiv  PAL_INDEX,      (PAL  - PAL) / 2
        .equiv  NTSC_INDEX,     (NTSC - PAL) / 2    

        .text
        .global VideoInit
        .extern KeybdSuspend
        .extern KeybdRelease
        .extern FontData
VideoInit:
        clr     TICKS                   ; Initialse 8Hz counter

;-------------------------------------------------------------------------------

        mov     #tblpage(FontData),w0   ; Prepare to read font glyphs
        mov     w0,TBLPAG
        mov     #tbloffset(FontData),w1
        mov     #0,w3

ExpandFont:
        tblrdl.b [w1++],w0              ; Expand row 0
        mov     #GLYPH0,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 1
        mov     #GLYPH1,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 2
        mov     #GLYPH2,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 3
        mov     #GLYPH3,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 4
        mov     #GLYPH4,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 5
        mov     #GLYPH5,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 6
        mov     #GLYPH6,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 7
        mov     #GLYPH7,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 8
        mov     #GLYPH8,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        tblrdl.b [w1++],w0              ; Expand row 9
        mov     #GLYPH9,w2
        add     w2,w3,w2
        mov.b   w0,[w2]
        add     #512,w2
        mov.b   w0,[w2]

        inc     w3,w3                   ; More glyphs to install
        mov     #0x120,w0
        cpseq   w3,w0
        bra     ExpandFont              ; Yes.

;-------------------------------------------------------------------------------

        mov     #ROWTAB,w1
        mov     #SCREEN,w2
        mov     #2 * COLS,w3
        mov     #TYPE_NORM,w4

        .rept   ROWS + 1
        mov     w2,[w1++]               ; Set the data pointer
        add     w2,w3,w2
        mov     w4,[w1++]               ; And row type
        .endr

        mov     #0x000,w0               ; Clear entire screen area
        mov     #SCREEN,w2
        repeat  #(ROWS + 1) * COLS - 1
        mov     w0,[w2++]

        mov     #STATUS,w1              ; Clear the status line
        mov     #(1<<ATTR_INVERT)|0x000,w0
        repeat  #COLS-1
        mov     w0,[w1++]

        sub     #30,w1                  ; Add Product name
        mov     #(1<<ATTR_INVERT)|'V',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'T',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'-',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'2',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'2',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'0',w0
        mov     w0,[w1++]

        mov     #(1<<ATTR_INVERT)|0x00,w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'(',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'1',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'4',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'.',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'0',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|'5',w0
        mov     w0,[w1++]
        mov     #(1<<ATTR_INVERT)|')',w0
        mov     w0,[w1++]

;-------------------------------------------------------------------------------

        mov     #NTSC_INDEX,w0          ; Assume NTSC generation
        btsc    MODE_PORT,#MODE_PIN
        mov     #PAL_INDEX,w0           ; No, pin configured for PAL
        mov     w0,STATE
        clr     TOPSCN

;-------------------------------------------------------------------------------

        clr     T2CON                   ; Configure timer 2 as 16-bit
        mov     #NTSC_PERIOD-1,w0       ; .. and assume NTSC
        btsc    MODE_PORT,#MODE_PIN
        mov     #PAL_PERIOD-1,w0        ; .. unless its PAL
        mov     w0,PR2
        clr     TMR2
        bset    T2CON,#TON              ; And start the display

        bset    IPC1,#T2IP0             ; Set high priority (7)
        bset    IPC1,#T2IP1
        bset    IPC1,#T2IP2

        bclr    IFS0,#T2IF              ; Clear any pending interrupts
        bset    IEC0,#T2IE              ; .. and enable

;-------------------------------------------------------------------------------

        clr     T4CON                   ; Configure timer 4/5 as 32-bit
        bset    T4CON,#T32
        mov     #TMR4_PERIOD_LSW,w0     ; .. and set period
        mov     w0,PR4
        mov     #TMR5_PERIOD_MSW,w0
        mov     w0,PR5
        clr     TMR5
        clr     TMR4
        bset    T4CON,#TON              ; And start the display

        bset    IPC7,#T5IP0             ; Set medium priority (5)
        bclr    IPC7,#T5IP1
        bset    IPC7,#T5IP2

        bclr    IFS1,#T5IF              ; Clear any pending interrupts
        bset    IEC1,#T5IE              ; .. and enable

        return                          ; All done

;-------------------------------------------------------------------------------

; When Timer4/5 overflows increment the 8Hz counter used to control blinking
; characters on the screen and smooth scrolling.

        .global __T5Interrupt
__T5Interrupt:
        inc     TICKS                   ; Bump counter
        bclr    IFS1,#T5IF              ; .. and clear interrupt
        retfie

;-------------------------------------------------------------------------------

; When Timer2 overflows execute the next stage in the video generation state
; machine.

        .global __T2Interrupt
__T2Interrupt:
        push.d  w0                      ; Save user registers
        push    w2
        mov     STATE,w0
        inc     STATE
        bra     w0

;-------------------------------------------------------------------------------

PAL:
        .rept   5
        bra     PALLongSync             ; 5x Long Sync (0)
        .endr
        .rept   5
        bra     PALShortSync            ; 5x Short Sync (2.5)
        .endr
        .rept   37
        bra     PALBlankLine            ; 38x Blank Line (5)
        bra     PALBlankSkip
        .endr
        bra     PALBlankLine            ; Last stops keyboard I/O
        bra     PALKeybdStop
        .rept   240
        bra     PALScanLine             ; 24x Visible Lines (45)       
       .endr
        .rept   2
        bra     PALBlankLine
        bra     PALBlankSkip
        .endr
        bra     PALStatusLine0          ; 1x Status Line (285)       
        bra     PALStatusLine1
        bra     PALStatusLine2
        bra     PALStatusLine3
        bra     PALStatusLine4
        bra     PALStatusLine5
        bra     PALStatusLine6
        bra     PALStatusLine7
        bra     PALStatusLine8
        bra     PALStatusLine9
        bra     PALBlankLine            ; Lead out (295)
        bra     PALKeybdStart
        .rept   14
        bra     PALBlankLine
        bra     PALBlankSkip
        .endr
        .rept   5
        bra     PALShortSync            ; Short sync (310)
        .endr
        bra     PALShortSyncAndReset    ; Total 313.5 Lines

;-------------------------------------------------------------------------------

NTSC:
        .rept   5
        bra     NTSCLongSync            ; 5x Long Sync (0)
        .endr
        .rept   5
        bra     NTSCShortSync           ; 5x Short Sync (2.5)
        .endr
        .rept   25
        bra     NTSCBlankLine           ; 26x Blank Line (5)
        bra     NTSCBlankSkip
        .endr
        bra     NTSCBlankLine
        bra     NTSCKeybdStop
        .rept   240
        bra     NTSCScanLine            ; 24x Visible Lines (31)             
        .endr
        bra     NTSCStatusLine0         ; 1x Status Line (271)             
        bra     NTSCStatusLine1
        bra     NTSCStatusLine2
        bra     NTSCStatusLine3
        bra     NTSCStatusLine4
        bra     NTSCStatusLine5
        bra     NTSCStatusLine6
        bra     NTSCStatusLine7
        bra     NTSCStatusLine8
        bra     NTSCStatusLine9
        bra     NTSCBlankLine           ; Lead out (281)
        bra     NTSCKeybdStart    
        .rept 3
        bra     NTSCBlankLine
        bra     NTSCBlankSkip    
        .endr
        .rept 4
        bra     NTSCShortSync            ; Short sync (285)
        .endr
        bra     NTSCShortSyncAndReset    ; Total 287 Lines

;===============================================================================
; PAL Generation
;-------------------------------------------------------------------------------

; Generates a short 2uS synchronisation pulse and then returns from the
; interrupt.

PALShortSync:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 2uS sync pulse
        mov     w14,LATB
        DELAY   2,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        mov     #ROWTAB,w0              ; Reset the row number
        mov     w0,ROWPTR
        mov     TOPSCN,w0               ; .. and scan line
        mov     w0,ROWSCN
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a short 2uS synchronisation pulse and resets TBLPTR to the start of
; the PAL state table before returning from the interrupt.

PALShortSyncAndReset:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 2uS sync pulse
        mov     w14,LATB
        DELAY   2,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        mov     #PAL_INDEX,w0           ; Reset PAL state offset
        mov     w0,STATE
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a long 30uS vertical syncronisation pulse then returns from the
; interrupt.

PALLongSync:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 30uS sync pulse
        mov     w14,LATB
        DELAY   30,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a 4uS image synchronisation pulse for a blank line.  

PALBlankLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        DELAY   4,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        pop     RCOUNT
        bra     PALBlankSkip

PALKeybdStop:
        rcall   KeybdSuspend            ; Diable keyboard while drawing
        bra     PALBlankSkip

PALKeybdStart:
        rcall   KeybdRelease            ; Enabdle keyboard while blank

PALBlankSkip:
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     w2
        pop.d   w0
        retfie
        
;-------------------------------------------------------------------------------

PALScanLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        mov     ROWPTR,w0               ; Load row details
        mov     [w0+0],w1               ; Fetch data pointer
        mov     [w0+2],w0               ; and row type
        DELAY   4,3
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        rcall   DrawLine

        inc     ROWSCN,WREG             ; Increase the scan line
        cp      w0,#10                  ; Finished the last line?
        bra     nz,1f                   ; No.
        inc2    ROWPTR                  ; Yes, bump row pointer
        inc2    ROWPTR
        clr     w0                      ; .. and reset scan line
1:      mov     w0,ROWSCN  

        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

PALStatusLine0:
        mov     #GLYPH0,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine1:
        mov     #GLYPH1,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine2:
        mov     #GLYPH2,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine3:
        mov     #GLYPH3,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine4:
        mov     #GLYPH4,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine5:
        mov     #GLYPH5,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine6:
        mov     #GLYPH6,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine7:
        mov     #GLYPH7,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine8:
        mov     #GLYPH8,w2              ; Point w2 at font scan line data
        bra     PALStatusLine
PALStatusLine9:
        mov     #GLYPH9,w2              ; Point w2 at font scan line data
        bra     PALStatusLine

PALStatusLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        mov     #STATUS,w1
        DELAY   4,1
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        repeat  #15
        nop
        call    DrawSingle
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;===============================================================================
; NTSC Generation
;-------------------------------------------------------------------------------

; Generates a short 2uS synchronisation pulse and then returns from the
; interrupt.

NTSCShortSync:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 2uS sync pulse
        mov     w14,LATB
        DELAY   2,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        mov     #ROWTAB,w0              ; Reset the row number
        mov     w0,ROWPTR
        mov     TOPSCN,w0               ; .. and scan line
        mov     w0,ROWSCN
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a short 2uS synchronisation pulse and resets TBLPTR to the start of
; the NTSC state table before returning from the interrupt.

NTSCShortSyncAndReset:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 2uS sync pulse
        mov     w14,LATB
        DELAY   2,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        mov     #NTSC_INDEX,w0          ; Reset NTSC state offset
        mov     w0,STATE
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a long 30uS vertical syncronisation pulse the returns from the
; interrupt.

NTSCLongSync:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 30uS sync pulse
        mov     w14,LATB
        DELAY   30,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

; Generates a 4uS image synchronisation pulse for a blank line.  

NTSCBlankLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        DELAY   4,0
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        pop     RCOUNT
        bra     NTSCBlankSkip

NTSCKeybdStop:
        rcall   KeybdSuspend            ; Diable keyboard while drawing
        bra     NTSCBlankSkip

NTSCKeybdStart:
        rcall   KeybdRelease            ; Enabdle keyboard while blank

NTSCBlankSkip:
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     w2
        pop.d   w0
        retfie

;-------------------------------------------------------------------------------

NTSCScanLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        mov     ROWPTR,w0               ; Load row details
        mov     [w0+0],w1               ; Fetch data pointer
        mov     [w0+2],w0               ; and row type
        DELAY   4,3
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        rcall   DrawLine

        inc     ROWSCN,WREG             ; Increase the scan line
        cp      w0,#10                  ; Finished the last line?
        bra     nz,1f                   ; No.
        inc2    ROWPTR                  ; Yes, bump row pointer
        inc2    ROWPTR
        clr     w0                      ; .. and reset scan line
1:      mov     w0,ROWSCN  

        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

NTSCStatusLine0:
        mov     #GLYPH0,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine1:
        mov     #GLYPH1,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine2:
        mov     #GLYPH2,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine3:
        mov     #GLYPH3,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine4:
        mov     #GLYPH4,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine5:
        mov     #GLYPH5,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine6:
        mov     #GLYPH6,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine7:
        mov     #GLYPH7,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine8:
        mov     #GLYPH8,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine
NTSCStatusLine9:
        mov     #GLYPH9,w2              ; Point w2 at font scan line data
        bra     NTSCStatusLine

NTSCStatusLine:
        push    RCOUNT
        bclr    w14,#SYNC_PIN           ; Generate 4uS sync pulse
        mov     w14,LATB
        mov     #STATUS,w1
        DELAY   4,1
        bset    w14,#SYNC_PIN
        mov     w14,LATB
        repeat  #15
        nop
        call    DrawSingle
        bclr    IFS0,#T2IF              ; Clear interrupt and return
        pop     RCOUNT
        pop     w2
        pop.d   w0
        retfie

;===============================================================================
; Scan Line Generation
;-------------------------------------------------------------------------------

        .equiv  R_ROWPTR,       w1
        .equiv  R_GLYPH,        w2

        .equiv  R_PIXELS,       w4
        .equiv  R_MASK,         w5
        .equiv  R_DATA,         w6
        .equiv  R_CHAR,         w7
        .equiv  R_PINBIT,       w8
        .equiv  R_NXTBIT,       w9

;-------------------------------------------------------------------------------

DrawLine:
        mov     ROWSCN,w2
        bra     w0
        bra     1f
        bra     2f
        bra     3f
        bra     4f

1:      sl      w2,#10,w2
        mov     #GLYPH0,w0
        add     w0,w2,w2
        nop
        bra     DrawSingle

2:      sl      w2,#10,w2
        mov     #GLYPH0,w0
        add     w0,w2,w2
        nop
        bra     DrawDouble

3:      lsr     w2,#1,w2
        sl      w2,#10,w2
        mov     #GLYPH0,w0
        add     w0,w2,w2
        bra     DrawDouble

4:      lsr     w2,#1,w2
        sl      w2,#10,w2
        mov     #GLYPH5,w0
        add     w0,w2,w2
        bra     DrawDouble

;-------------------------------------------------------------------------------

DrawSingle:
        push.d  w4                      ; Save user registers
        push.d  w6
        push.d  w8
        DELAY   10,11                   ; Back Porch

        mov     #BUFFER,R_PIXELS        ; Set up pixel buffer pointer
        mov     #0x1ff,R_MASK           ; And character mask

        clr     [R_PIXELS--]            ; Start with a blank character
        mov     #NORM_PIN,R_PINBIT

        .rept   COLS+1
        btst.c  [++R_PIXELS],#7         ; Draw pixel 7
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     [R_ROWPTR++],R_DATA     ; Fetch next character and attributes
        and     R_DATA,R_MASK,R_CHAR    ; .. and extract the glyph code

        btst.c  [R_PIXELS],#6           ; Draw pixel 6
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov.b   [R_GLYPH+R_CHAR],R_CHAR ; Map the glyph code to pixel pattern
        mov.b   R_CHAR,R_DATA           ; .. and make a copy 

        btst.c  [R_PIXELS],#5           ; Draw pixel 5
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    TICKS,#3                ; Blank phase of flashing?
        clr.b   R_DATA                  ; Yes, clear pixel pattern

        btst.c  [R_PIXELS],#4           ; Draw pixel 4
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_FLASH      ; Is this character flashing?
        mov     R_DATA,R_CHAR           ; Yes, replace with blinking pattern

        btst.c  [R_PIXELS],#3           ; Draw pixel 3
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_INVERT     ; Is the character inverse video?
        com.b   R_CHAR,R_CHAR           ; Yes, invert the pixel pattern

        btst.c  [R_PIXELS],#2           ; Draw pixel 2
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     R_CHAR,[R_PIXELS+2]     ; Save the next pixel pattern
        mov     #NORM_PIN,R_NXTBIT      ; Assume normal intensity

        btst.c  [R_PIXELS],#1           ; Draw pixel 1
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_BOLD       ; Is the characater bold?
        mov     #BOLD_PIN,R_NXTBIT      ; Yes, change output in

        btst.c  [R_PIXELS],#0
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     #(1<<SYNC_PIN),R_SHADOW ; Switch to new output pin
        mov     R_NXTBIT,R_PINBIT
        .endr

        nop
        nop
        mov     R_SHADOW,NORM_LAT       ; And turn off last pixel (if any)

        bclr    w14,#NORM_PIN
        mov     w14,NORM_LAT

        pop.d   w8
        pop.d   w6
        pop.d   w4
        return

;-------------------------------------------------------------------------------

DrawDouble:
        push.d  w4                      ; Save user registers
        push.d  w6
        push.d  w8
        DELAY   10,(11+8*5)             ; Back Porch

        mov     #BUFFER,R_PIXELS        ; Set up pixel buffer pointer
        mov     #0x1ff,R_MASK           ; And character mask

        clr     [R_PIXELS--]            ; Start with a blank character
        mov     #NORM_PIN,R_PINBIT

        .rept   (COLS/2)+1
        btst.c  [++R_PIXELS],#7         ; Draw pixel 7
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     [R_ROWPTR++],R_DATA     ; Fetch next character and attributes
        and     R_DATA,R_MASK,R_CHAR    ; .. and extract the glyph code

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#6           ; Draw pixel 6
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov.b   [R_GLYPH+R_CHAR],R_CHAR ; Map the glyph code to pixel pattern
        mov.b   R_CHAR,R_DATA           ; .. and make a copy 

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#5           ; Draw pixel 5
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    TICKS,#3                ; Blank phase of flashing?
        clr.b   R_DATA                  ; Yes, clear pixel pattern

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#4           ; Draw pixel 4
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_FLASH      ; Is this character flashing?
        mov     R_DATA,R_CHAR           ; Yes, replace with blinking pattern

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#3           ; Draw pixel 3
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_INVERT     ; Is the character inverse video?
        com.b   R_CHAR,R_CHAR           ; Yes, invert the pixel pattern

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#2           ; Draw pixel 2
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     R_CHAR,[R_PIXELS+2]     ; Save the next pixel pattern
        mov     #NORM_PIN,R_NXTBIT      ; Assume normal intensity

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#1           ; Draw pixel 1
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        btsc    R_DATA,#ATTR_BOLD       ; Is the characater bold?
        mov     #BOLD_PIN,R_NXTBIT      ; Yes, change output in

        nop
        nop
        nop
        nop
        nop

        btst.c  [R_PIXELS],#0
        bsw.c   R_SHADOW,R_PINBIT
        mov     R_SHADOW,NORM_LAT
        mov     #(1<<SYNC_PIN),R_SHADOW ; Switch to new output pin
        mov     R_NXTBIT,R_PINBIT

        nop
        nop
        nop
        nop
        nop

        .endr

        nop
        nop
        mov     R_SHADOW,NORM_LAT       ; And turn off last pixel (if any)

        bclr    w14,#NORM_PIN
        mov     w14,NORM_LAT

        pop.d   w8
        pop.d   w6
        pop.d   w4
        return

        .end
